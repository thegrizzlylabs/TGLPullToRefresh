//
//  UIScrollView+TGLPullToRefresh.h
//
//  Created by Bruno Virlet on 12/10/15.
//  Copyright © 2015 The Grizzly Labs. All rights reserved.
//
//  Copyright (c) 2013 Thomas Park
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "UIScrollView+TGLPullToRefresh.h"

#import <objc/runtime.h>

// ------------------------------------------------------------------------------------------------------------------------


const CGFloat TGLPullToRefreshTriggerHeight = 100.0f;

const void *TGLPullToRefreshHandlerKey = &TGLPullToRefreshHandlerKey;

// ---

@interface TGLPullToRefreshHandler : NSObject

@property (nonatomic, unsafe_unretained) UIScrollView *scrollView;
@property (nonatomic, copy) void (^refreshHandler)();
@property (nonatomic, weak) UIView<TGLPullToRefreshActivityViewProtocol> *loadingIndicatorView;
@property (nonatomic, assign) UIEdgeInsets originalInset;
@property (nonatomic, assign, getter=isRefreshing) BOOL refreshing;
@property (nonatomic, assign) BOOL isChangingContentInset;
@property (nonatomic, assign) CGFloat triggerLength;

@end

@implementation TGLPullToRefreshHandler

- (void)dealloc {
    [self _removeObservers];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    if (_scrollView) {
        [self _removeObservers];
    }

    _scrollView = scrollView;
    self.originalInset = scrollView.contentInset;
    [self _setupObservers];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object != self.scrollView) {
        return;
    }

    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat visibleOffset = - (self.scrollView.contentOffset.y + self.scrollView.contentInset.top);
        CGFloat visibleProgress = visibleOffset/self.triggerLength;

        if (visibleProgress > 1 && !self.isRefreshing && !self.scrollView.isDragging) {
            self.refreshing = YES;

            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState  animations:^{
                    _isChangingContentInset = YES;

                    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top + self.triggerLength, self.scrollView.contentInset.left,
                                                                      self.scrollView.contentInset.bottom, self.scrollView.contentInset.right)];

                    _isChangingContentInset = NO;
                } completion:^(BOOL finished) {
                    if (self.refreshHandler) {
                        self.refreshHandler();
                    }
                }];
            });
        }

        if (!self.isRefreshing) {
            [self.loadingIndicatorView setProgress:visibleProgress];
        }
        self.loadingIndicatorView.hidden = !self.isRefreshing && visibleProgress <= 0;

    } else if ([keyPath isEqualToString:@"contentInset"]) {
        if (_isChangingContentInset) {
            return;
        }

        CGFloat insetOffset = 0.;
        if (self.isRefreshing) {
            // This means that someone has changed the contentInset while we were in refreshing mode.
            // In that mode, we have offset the contentInset by triggerLength, but we don't want to save
            // that in the originalInset!
            insetOffset = - self.triggerLength;
        }
        self.originalInset = UIEdgeInsetsMake(self.scrollView.contentInset.top + insetOffset, self.scrollView.contentInset.left, self.scrollView.contentInset.bottom, self.scrollView.contentInset.right);
    }
}

- (void)setRefreshing:(BOOL)refreshing {
    _refreshing = refreshing;
    self.loadingIndicatorView.hidden = !refreshing;
    [self.loadingIndicatorView setRefreshing:refreshing];
}

- (void)endRefreshing {
    self.refreshing = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        _isChangingContentInset = YES;
        self.scrollView.contentInset = self.originalInset;
        _isChangingContentInset = NO;
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Private

- (void)_setupObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)_removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
}

@end

// -------------

@interface UIScrollView ()
@property (nonatomic, strong) TGLPullToRefreshHandler *tgl_pullToRefreshHandler;

@end

@implementation UIScrollView (TGLPullToRefresh)

- (void)tgl_setupPullToRefreshWithView:(UIView<TGLPullToRefreshActivityViewProtocol>*)loadingIndicator triggerLength:(CGFloat)triggerLength handler:(void (^)(void))refreshHandler {

    TGLPullToRefreshHandler *handler = [[TGLPullToRefreshHandler alloc] init];
    handler.scrollView = self;
    handler.loadingIndicatorView = loadingIndicator;
    handler.refreshHandler = refreshHandler;
    handler.triggerLength = triggerLength;
    [self tgl_setPullToRefreshHandler:handler];
}

- (void)tgl_setupPullToRefreshWithView:(UIView<TGLPullToRefreshActivityViewProtocol>*)loadingIndicator handler:(void (^)(void))refreshHandler {
    [self tgl_setupPullToRefreshWithView:loadingIndicator triggerLength:TGLPullToRefreshTriggerHeight handler:refreshHandler];
}

- (void)tgl_endRefreshing {
    [self.tgl_pullToRefreshHandler endRefreshing];
}

- (void)tgl_setPullToRefreshHandler:(TGLPullToRefreshHandler *)handler {
    objc_setAssociatedObject(self, TGLPullToRefreshHandlerKey, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TGLPullToRefreshHandler *)tgl_pullToRefreshHandler {
    return objc_getAssociatedObject(self, TGLPullToRefreshHandlerKey);
}

@end

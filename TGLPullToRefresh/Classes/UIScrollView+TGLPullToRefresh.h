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

#import <UIKit/UIKit.h>

/**
 TGLPullToRefresh is a very easy to use "pull to refresh" component.

 The goal is to make it super easy to customize. Unlike UIRefreshControl, it doesn't force
 you to use a specific activity indicator. With TGLPullToRefresh, you can use the view you
 like as long as it implements a minimalistic protocol.
 */

/**
 Your loading indicator view must implement this protocol.
 */
@protocol TGLPullToRefreshActivityViewProtocol <NSObject>

// Progress <= 1: if user releases, refresh is not triggered
// Progress > 1: if user releases, refresh is triggered
- (void)setProgress:(CGFloat)progress;

// Set to YES when refresh is triggered, set to YES when refresh is done
- (void)setRefreshing:(BOOL)refreshing;

@end

/**
 Use this category to implement the pull to refresh mechanism on any scroll view
 */
@interface UIScrollView (TGLPullToRefresh)
/**
 @param triggerLength: how much you need to pull before the refresh triggers
 */
- (void)tgl_setupPullToRefreshWithView:(UIView<TGLPullToRefreshActivityViewProtocol>*)refreshActivityView triggerLength:(CGFloat)triggerLength handler:(void (^)(void))refreshHandler;
- (void)tgl_setupPullToRefreshWithView:(UIView<TGLPullToRefreshActivityViewProtocol>*)refreshActivityView handler:(void(^)(void))refreshHandler;

/**
 To be called in your refreshHandler when the refreshing action is over
 */
- (void)tgl_endRefreshing;


@end

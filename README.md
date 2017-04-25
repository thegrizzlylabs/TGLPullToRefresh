# TGLPullToRefresh

[![CI Status](http://img.shields.io/travis/bvirlet/TGLPullToRefresh.svg?style=flat)](https://travis-ci.org/bvirlet/TGLPullToRefresh)
[![Version](https://img.shields.io/cocoapods/v/TGLPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/TGLPullToRefresh)
[![License](https://img.shields.io/cocoapods/l/TGLPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/TGLPullToRefresh)
[![Platform](https://img.shields.io/cocoapods/p/TGLPullToRefresh.svg?style=flat)](http://cocoapods.org/pods/TGLPullToRefresh)

## Example

## Requirements

## Installation

TGLPullToRefresh is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TGLPullToRefresh"
```

## Usage

In `viewDidLoad`, `awakeFromNib`:
```Objective-C
[self.tableView tgl_setupPullToRefreshWithView:self.pullToRefreshActivityView handler:^{
  // Load data
  // …
}];
```

TGLPullToRefresh should work on any UIScrollView.

## Author

Bruno Virlet, bruno.virlet@gmail.com

## License

TGLPullToRefresh is available under the MIT license. See the LICENSE file for more info.

#
# Be sure to run `pod lib lint TGLPullToRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TGLPullToRefresh'
  s.version          = '0.1.0'
  s.summary          = 'A flexible pull-to-refresh for UIScrollView.'
  s.description      = <<-DESC
TGLPullToRefresh provides a light, flexible implementation of the pull-to-refresh paradigm. Unlike UIRefreshControl, it lets you use any "progress" view you want. It also handles dynamically changing content offsets. You can see it in action in the list views of Pyfl (https://getpyfl.com/download).
                       DESC

  s.homepage         = 'https://github.com/bvirlet/TGLPullToRefresh'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bvirlet' => 'bruno.virlet@gmail.com' }
  s.source           = { :git => 'https://github.com/bvirlet/TGLPullToRefresh.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bvirlet'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TGLPullToRefresh/Classes/**/*'
end

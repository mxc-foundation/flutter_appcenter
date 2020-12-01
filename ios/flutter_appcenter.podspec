#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_appcenter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_appcenter'
  s.version          = '1.0.10'
  s.summary          = 'Continuously build, test, release, and monitor apps for every platform.'
  s.description      = <<-DESC
  Visual Studio App Center brings together multiple common services into a DevOps cloud solution. Developers use App Center to Build, Test, and Distribute applications. Once the app\'s deployed, developers monitor the status and usage of the app using the Analytics and Diagnostics services.
                       DESC
  s.homepage         = 'https://github.com/zhbh/flutter_appcenter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MXC' => 'zh.bh.sam@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'AppCenter', '~> 3.2.0'
  s.dependency 'AppCenter/Distribute', '~> 3.2.0'
  s.platform = :ios, '9.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end

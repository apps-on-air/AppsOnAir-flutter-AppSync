#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint appsonair_flutter_appsync.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'appsonair_flutter_appsync'
  s.version          = '1.2.0'
  s.summary          = 'AppsOnAir AppSync Flutter SDK — manage forced updates, regular updates and maintenance mode.'
  s.description      = <<-DESC
The AppsOnAir AppSync Flutter SDK lets you manage forced and regular app updates, as well as enable maintenance mode, directly via AppsOnAir.
                       DESC
  s.homepage         = 'https://appsonair.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'devtools-logicwind' => 'devtools@logicwind.com' }
  s.source           = { :path => '.' }
  # Source files live in the SPM layout directory (shared between CocoaPods and SPM)
  s.source_files     = 'appsonair_flutter_appsync/Sources/appsonair_flutter_appsync/**/*.{swift,h,m}'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  
  # AppsOnAir App Sync IOS POD
  s.dependency 'AppsOnAir-AppSync',  '1.4.0'
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end

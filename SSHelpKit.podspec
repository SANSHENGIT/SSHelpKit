#
#  Be sure to run `pod spec lint SSHelpKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#


Pod::Spec.new do |spec|
  spec.name         = 'SSHelpKit'
  spec.version      = '0.1'
  spec.summary      = '内部库'
  spes.platform     = :ios, '8.0'

  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/SANSHENGIT/SSHelpKit'
  spec.authors      = { 'MuZiLee' => 'admin@sanshengit.com' }

  spec.source       = { :git => 'https://github.com/SANSHENGIT/SSHelpKit.git', :tag => '0.1' }
  spec.source_files = 'SSHelpKit/**/*'

  spec.framework    = 'UIKit'
  spec.dependency 'AFNetworking'

end
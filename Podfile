# WePeiYang Podfile

platform :ios, '8.0'
use_frameworks!
target 'WePeiYang' do

pod 'AFNetworking'
pod 'pop'
pod 'FXForms'
pod 'FDStackView'
pod 'BlocksKit'
pod 'SwiftyJSON', '~>2.4.0'
pod 'ObjectMapper', '~>1.5.0'
pod 'MJExtension'
pod 'MJRefresh'
pod 'SVProgressHUD'
pod 'ChameleonFramework'
pod 'JZNavigationExtension'
pod 'WebViewJavascriptBridge'
pod 'DZNEmptyDataSet'
pod 'JBChartView'
pod 'Charts', '~>2.3.0'
pod 'SnapKit', '~>0.22.0'
pod 'WMPageController'
pod 'FMDB'
pod 'IDMPhotoBrowser'
pod 'SlackTextViewController'
pod 'STPopup'
pod 'DateTools'
pod 'IGIdenticon'

end

target 'WePeiYangTests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
	        config.build_settings['SWIFT_VERSION'] = '2.3'
	  end
  end
end

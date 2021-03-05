Pod::Spec.new do |spec|
  spec.name         = "HYAddressSelectionView"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of HYAddressSelectionView."
  spec.license      = "MIT"
  spec.author       = { "xiehaiyan" => "1170068445@qq.com" }
  spec.platform     = :ios, "8.0"
  spec.homepage     = "https://github.com/JxXiaoXie/HYAddressSelectionView.git"
  spec.source       = { :git => "https://github.com/JxXiaoXie/HYAddressSelectionView.git", :tag => "#{spec.version}" }
  spec.source_files = "HYAddressSelectionView/**/*.{h,m,xib}","HYAddressSelectionView/**/**/*.{h,m,xib}","HYAddressSelectionView/**/**/**/*.{h,m,xib}"
  spec.resources    = "HYAddressSelectionView/Resources/*.plist"
end

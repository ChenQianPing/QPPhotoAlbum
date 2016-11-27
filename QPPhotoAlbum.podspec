Pod::Spec.new do |s|

s.name         = "QPPhotoAlbum"
s.version      = "1.0.0"
s.summary      = "QPPhotoAlbum for Objective-C."
s.description  = <<-DESC
It is a QPPhotoAlbum used on iOS, which implement by Objective-C.
DESC
s.homepage     = "https://github.com/ChenQianPing/QPPhotoAlbum"
s.license      = "MIT"
s.author             = { "QianPing Chen" => "pingkeke@163.com" }
s.platform     = :ios, "8.0"
s.source       = { :https://github.com/ChenQianPing/QPPhotoAlbum.git", :tag => s.version.to_s }
s.source_files  = "QPPhotoAlbum/*.{h,m}"
s.framework  = "Foundation","UIKit","AVFoundation","MobileCoreServices"
s.module_name = 'QPPhotoAlbum'

end

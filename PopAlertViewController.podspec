

Pod::Spec.new do |s|


  s.name         = "PopAlertViewController"
  s.version      = "0.0.1"
  s.summary      = "第一次制作"

  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/Dreamle"


  s.license      = { :type => "MIT", :text => <<-LICENSE
           Copyright DreamLee 2018-2019
           LICENSE
      }

  s.author             = { "admin" => "404436209@qq.com" }
  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Dreamle/PopupAlertViewController.git", :tag => s.version }


  s.source_files  = "PopupAlertViewController/PopAlertViewController/PopAlert"
 
  s.requires_arc = true


end
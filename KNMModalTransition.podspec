Pod::Spec.new do |s|
  s.name         = "KNMModalTransition"
  s.version      = "0.1.0"
  s.summary      = "A modal transition base class that abstracts the differences between iOS 7 and 8, as well as different orientations."
  s.description  = <<-DESC
                   This class abstracts the differences between iOS 7 and iOS 8, as
                   well as between different interface orientations when using
                   custom animated modal transitions. 
                   DESC
  s.homepage     = "https://github.com/konoma/ios-modal-transition"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Markus Gasser" => "markus.gasser@konoma.ch" }

  s.ios.deployment_target = '7.0'

  s.source       = { :git => "https://github.com/konoma/ios-modal-transition.git", :tag => "v0.1.0" }
  s.source_files = 'Library'
  s.frameworks   = 'Foundation', 'UIKit'
  s.requires_arc = true
end

Pod::Spec.new do |s|
  s.name         = "KNMModalTransition"
  s.version      = "0.1.0"
  s.summary      = "A base class that provides an abstraction over UIViewControllerTransitioningDelegate and UIViewControllerAnimatedTransitioning."
  s.description  = <<-DESC
                   KNMModalTransition is a modal transition base class that provides some
                   abstractions over `UIViewControllerTransitioningDelegate` and
                   `UIViewControllerAnimatedTransitioning`. Also contains some helpers
                   to deal with orientation changes.
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

Pod::Spec.new do |s|
  s.name         = "TripleLiftSDK"
  s.version      = "0.0.2"
  s.summary      = "Lightweight iOS SDK for TripleLift native advertising"
  s.description  = <<-DESC
                   The TripleLift iOS SDK assists in implementing 
                   Sponsored Content (SC) images into iOS applications.
                   DESC
  s.homepage     = "http://triplelift.com"
  s.license      = { :type => "Github Copyright (license is unknown)", :text => <<-LICENSE
    F. Copyright and Content Ownership
    1. We claim no intellectual property rights over the material you provide to the Service. 
    Your profile and materials uploaded remain yours. However, by setting your pages to be viewed publicly, 
    you agree to allow others to view your Content. By setting your repositories to be viewed publicly, 
    you agree to allow others to view and fork your repositories.
    LICENSE
  }
  
  s.author             = { "TripleLift" => "info@triplelift.com" }
  s.platform     = :ios
  
  # Note: This Podspec is currently only be used internally at CardinalBlue
  s.source       = { :git => "https://github.com/cardinalblue/triplelift-ios-sdk.git", :tag => "0.0.2" }
  
  s.source_files  = "TripleLiftSDK/**/*.{h,m}"
  s.public_header_files = "TripleLiftSDK/**/*.h"

  s.requires_arc = true
end

Pod::Spec.new do |s|
  s.name         = "TripleLiftSDK"
  s.version      = "0.0.2"
  s.summary      = "Lightweight iOS SDK for TripleLift native advertising"
  s.description  = <<-DESC
                   The TripleLift iOS SDK assists in implementing 
                   Sponsored Content (SC) images into iOS applications.
                   DESC
  s.homepage     = "http://triplelift.com"
  s.license      = "Unknown"
  s.author             = { "TripleLift" => "info@triplelift.com" }
  s.platform     = :ios
  
  # Note: This Podspec is currently only be used internally at CardinalBlue
  s.source       = { :git => "https://github.com/cardinalblue/triplelift-ios-sdk", :tag => "0.0.2" }
  
  s.source_files  = "TripleLiftSDK/**/*.{h,m}"
  s.public_header_files = "TripleLiftSDK/**/*.h"
end

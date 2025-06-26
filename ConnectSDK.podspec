# There are two usage options of this podspec:
# * pod "ConnectSDK" will install the full ConnectSDK version (without Amazon
#   Fling SDK support; if you need it, please use the source ConnectSDK project
#   directly);
# * pod "ConnectSDK/Core" will install the core only (Lite version) without
#   external dependencies.
#
# Unfortunately, Amazon Fling SDK is not distributed via CocoaPods, so we
# cannot include its support in a subspec in an automated way.

Pod::Spec.new do |s|
  s.name         = "MyConnectTVSDK"
  s.version      = "1.0.0"
  s.summary      = "MyConnectTVSDK - A unified SDK to connect iOS apps to Smart TVs using DIAL, DLNA, Chromecast, and more."

  s.description  = <<-DESC
    MyConnectTVSDK is a customized fork of ConnectSDK that simplifies integration with smart TVs such as LG, Samsung, Roku, Chromecast, and others. 
    It abstracts device discovery and communication using protocols like DIAL, DLNA, Chromecast, ECG, and more.
  DESC

  s.homepage     = "https://github.com/Rajib-Sarwar/My-Connect-SDK-iOS"
  s.license      = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author       = { "Rajib Sarwar" => "you@example.com" }
  s.social_media_url   = "http://twitter.com/RajibSarwar"
  s.platform     = :ios, "11.0"
  s.ios.deployment_target = "11.0"
  s.source       = {
    :git => "https://github.com/Rajib-Sarwar/My-Connect-SDK-iOS.git",
    :tag => s.version,
    :submodules => true
  }

  s.xcconfig = {
    "OTHER_LDFLAGS" => "$(inherited) -ObjC"
  }

  s.requires_arc = true
  s.libraries = "z", "icucore"

  s.prefix_header_contents = <<-PREFIX
    #define MY_CONNECT_SDK_VERSION @"#{s.version}"
    //#define CONNECT_SDK_ENABLE_LOG

    #ifndef kConnectSDKWirelessSSIDChanged
    #define kConnectSDKWirelessSSIDChanged @"MyConnectTVSDK_Wireless_SSID_Changed"
    #endif

    #ifdef CONNECT_SDK_ENABLE_LOG
        #ifdef DEBUG
        #   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
        #else
        #   define DLog(...)
        #endif
    #else
        #   define DLog(...)
    #endif
  PREFIX

  non_arc_files = [
    "core/Frameworks/asi-http-request/External/Reachability/*.{h,m}",
    "core/Frameworks/asi-http-request/Classes/*.{h,m}"
  ]

  s.subspec 'Core' do |sp|
    sp.source_files  = "ConnectSDKDefaultPlatforms.h", "core/**/*.{h,m}"
    sp.exclude_files = (non_arc_files.dup << "core/ConnectSDK*Tests/**/*" << "core/Frameworks/LGCast/**/*.h")
    sp.private_header_files = "core/**/*_Private.h"
    sp.requires_arc = true

    sp.dependency 'MyConnectTVSDK/no-arc'
    sp.ios.vendored_frameworks = 'core/Frameworks/LGCast/LGCast.xcframework', 'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'
    sp.preserve_paths =  'core/Frameworks/LGCast/LGCast.xcframework', 'core/Frameworks/LGCast/GStreamerForLGCast.xcframework'
  end

  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false
    sp.compiler_flags = '-w'
  end

  s.subspec 'GoogleCast' do |sp|
    cast_dir = "modules/google-cast"

    sp.dependency 'MyConnectTVSDK/Core'
    sp.source_files = "#{cast_dir}/**/*.{h,m}"
    sp.exclude_files = "#{cast_dir}/*Tests/**/*"
    sp.private_header_files = "#{cast_dir}/**/*_Private.h"

    cast_version = "2.7.1"
    sp.dependency "google-cast-sdk", cast_version
    sp.framework = "GoogleCast"
    sp.xcconfig = {
      "FRAMEWORK_SEARCH_PATHS" => "$(PODS_ROOT)/google-cast-sdk/GoogleCastSDK-#{cast_version}-Release",
    }
  end
end

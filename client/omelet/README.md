# omelet

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
omelet
├─ .gitignore
├─ .metadata
├─ .vscode
│  └─ launch.json
├─ analysis_options.yaml
├─ android
│  ├─ .gitignore
│  ├─ .gradle
│  │  ├─ 7.5
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ dependencies-accessors
│  │  │  │  ├─ dependencies-accessors.lock
│  │  │  │  └─ gc.properties
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ app
│  │  ├─ build.gradle
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  ├─ com
│  │     │  │  │  └─ omelet
│  │     │  │  │     └─ omelet
│  │     │  │  │        └─ MainActivity.java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  ├─ local.properties
│  └─ settings.gradle
├─ assets
│  ├─ env.webloc
│  ├─ maple.png
│  ├─ nini.png
│  ├─ thomas.png
│  ├─ userOmelet.png
│  └─ xeift.png
├─ Brewfile
├─ fonts
│  └─ CustomIcons.ttf
├─ ios
│  ├─ .gitignore
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ flutter_export_environment 2.sh
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated 2.xcconfig
│  │  ├─ Generated.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Podfile
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-50x50@1x.png
│  │  │  │  ├─ Icon-App-50x50@2x.png
│  │  │  │  ├─ Icon-App-57x57@1x.png
│  │  │  │  ├─ Icon-App-57x57@2x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-72x72@1x.png
│  │  │  │  ├─ Icon-App-72x72@2x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ api
│  │  ├─ debug_reset_prekeybundle_and_unread_msg.dart
│  │  ├─ get
│  │  │  ├─ download_pre_key_bundle_api.dart
│  │  │  ├─ get_available_opk_index_api.dart
│  │  │  ├─ get_device_ids_api.dart
│  │  │  ├─ get_friend_list_api.dart
│  │  │  ├─ get_friend_request_api.dart
│  │  │  ├─ get_self_opk_status_api.dart
│  │  │  ├─ get_self_spk_status_api.dart
│  │  │  ├─ get_unread_msg_api.dart
│  │  │  └─ get_user_public_info_api.dart
│  │  ├─ multi_screen
│  │  │  └─ multi_screen_page.dart
│  │  └─ post
│  │     ├─ get_translated_sentence_api.dart
│  │     ├─ login_api.dart
│  │     ├─ remove_friend_api.dart
│  │     ├─ reply_friend_request_api.dart
│  │     ├─ reset_password_api.dart
│  │     ├─ send_friend_request_api.dart
│  │     ├─ signup_api.dart
│  │     ├─ update_opk_api.dart
│  │     ├─ update_pfp_api.dart
│  │     ├─ update_spk_api.dart
│  │     ├─ upload_img_api.dart
│  │     └─ upload_pre_key_bundle_api.dart
│  ├─ componets
│  │  ├─ alert
│  │  │  └─ alert_msg.dart
│  │  ├─ button
│  │  │  ├─ on_select_image_btn_pressed.dart
│  │  │  ├─ on_send_msg_btn_pressed.dart
│  │  │  └─ on_update_pfp_btn_pressed.dart
│  │  ├─ message
│  │  │  ├─ avatar.dart
│  │  │  ├─ avatar_user.dart
│  │  │  └─ glow_bar.dart
│  │  ├─ Screen
│  │  │  └─ frosted_appbr.dart
│  │  └─ setting
│  │     ├─ avatar_card.dart
│  │     └─ setting_title.dart
│  ├─ developer
│  │  ├─ developer_page.dart
│  │  └─ test_ping_page.dart
│  ├─ main.dart
│  ├─ models
│  │  ├─ message_data.dart
│  │  └─ setting.dart
│  ├─ notify
│  │  └─ notify.dart
│  ├─ pages
│  │  ├─ friends_page
│  │  │  ├─ friends_add_page.dart
│  │  │  └─ friends_list_page.dart
│  │  ├─ login_signup
│  │  │  ├─ forget_page.dart
│  │  │  ├─ forget_validator_page.dart
│  │  │  ├─ loading_page.dart
│  │  │  ├─ login_page.dart
│  │  │  └─ sign_up_page.dart
│  │  ├─ message
│  │  │  ├─ chat_room_page.dart
│  │  │  └─ multi_screen
│  │  │     └─ multi_chat_room.dart
│  │  ├─ message_list_page.dart
│  │  ├─ nav_bar_control_page.dart
│  │  ├─ notification_page
│  │  │  └─ notification_page.dart
│  │  └─ setting
│  │     └─ setting_page.dart
│  ├─ signal_protocol
│  │  ├─ decrypt_msg.dart
│  │  ├─ encrypt_msg.dart
│  │  ├─ encrypt_pre_key_signal_message.dart
│  │  ├─ encrypt_signal_message.dart
│  │  ├─ generate_and_store_key.dart
│  │  ├─ pre_key_bundle_converter.dart
│  │  ├─ safe_identity_store.dart
│  │  ├─ safe_opk_store.dart
│  │  ├─ safe_session_store.dart
│  │  ├─ safe_signal_protocol_store.dart
│  │  └─ safe_spk_store.dart
│  ├─ storage
│  │  ├─ safe_account_store.dart
│  │  ├─ safe_config_store.dart
│  │  ├─ safe_device_id_store.dart
│  │  ├─ safe_msg_store.dart
│  │  ├─ safe_notify_store.dart
│  │  └─ safe_util_store.dart
│  ├─ theme
│  │  ├─ theme_constants.dart
│  │  └─ theme_provider.dart
│  └─ utils
│     ├─ check_device_id.dart
│     ├─ check_opk_status.dart
│     ├─ check_spk_status.dart
│     ├─ check_unread_msg.dart
│     ├─ check_unread_notify.dart
│     ├─ generate_random_filename.dart
│     ├─ get_friends_list.dart
│     ├─ helpers.dart
│     ├─ server_uri.dart
│     └─ timstamp.dart
├─ OmeletIcon.png
├─ pubspec.lock
├─ pubspec.yaml
├─ README.md
├─ test
│  └─ widget_test.dart
├─ web
│  ├─ favicon.png
│  ├─ icons
│  │  ├─ Icon-192.png
│  │  ├─ Icon-512.png
│  │  ├─ Icon-maskable-192.png
│  │  └─ Icon-maskable-512.png
│  └─ manifest.json
└─ windows
   ├─ .gitignore
   ├─ CMakeLists.txt
   ├─ flutter
   │  ├─ CMakeLists.txt
   │  ├─ ephemeral
   │  │  ├─ .plugin_symlinks
   │  │  │  ├─ connectivity_plus
   │  │  │  │  ├─ android
   │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  ├─ gradle.properties
   │  │  │  │  │  ├─ settings.gradle
   │  │  │  │  │  └─ src
   │  │  │  │  │     └─ main
   │  │  │  │  │        ├─ AndroidManifest.xml
   │  │  │  │  │        └─ java
   │  │  │  │  │           └─ dev
   │  │  │  │  │              └─ fluttercommunity
   │  │  │  │  │                 └─ plus
   │  │  │  │  │                    └─ connectivity
   │  │  │  │  │                       ├─ Connectivity.java
   │  │  │  │  │                       ├─ ConnectivityBroadcastReceiver.java
   │  │  │  │  │                       ├─ ConnectivityMethodChannelHandler.java
   │  │  │  │  │                       └─ ConnectivityPlugin.java
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  │  ├─ android
   │  │  │  │  │  │  ├─ app
   │  │  │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  │  │  └─ src
   │  │  │  │  │  │  │     └─ main
   │  │  │  │  │  │  │        ├─ AndroidManifest.xml
   │  │  │  │  │  │  │        ├─ java
   │  │  │  │  │  │  │        │  └─ io
   │  │  │  │  │  │  │        │     └─ flutter
   │  │  │  │  │  │  │        │        └─ plugins
   │  │  │  │  │  │  │        │           └─ connectivityexample
   │  │  │  │  │  │  │        │              └─ FlutterActivityTest.java
   │  │  │  │  │  │  │        └─ res
   │  │  │  │  │  │  │           ├─ mipmap-hdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-mdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-xhdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-xxhdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           └─ mipmap-xxxhdpi
   │  │  │  │  │  │  │              └─ ic_launcher.png
   │  │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  │  ├─ gradle.properties
   │  │  │  │  │  │  └─ settings.gradle
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ connectivity_plus_test.dart
   │  │  │  │  │  ├─ ios
   │  │  │  │  │  │  ├─ Flutter
   │  │  │  │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │  │  │  │  │  │  ├─ Debug.xcconfig
   │  │  │  │  │  │  │  └─ Release.xcconfig
   │  │  │  │  │  │  ├─ Runner
   │  │  │  │  │  │  │  ├─ AppDelegate.swift
   │  │  │  │  │  │  │  ├─ Assets.xcassets
   │  │  │  │  │  │  │  │  ├─ AppIcon.appiconset
   │  │  │  │  │  │  │  │  │  ├─ Contents.json
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │  │  │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │  │  │  │  │  │  │  └─ LaunchImage.imageset
   │  │  │  │  │  │  │  │     ├─ Contents.json
   │  │  │  │  │  │  │  │     ├─ LaunchImage.png
   │  │  │  │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │  │  │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │  │  │  │  │  │  │     └─ README.md
   │  │  │  │  │  │  │  ├─ Base.lproj
   │  │  │  │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │  │  │  │  │  │  │  └─ Main.storyboard
   │  │  │  │  │  │  │  ├─ Info.plist
   │  │  │  │  │  │  │  └─ Runner-Bridging-Header.h
   │  │  │  │  │  │  ├─ Runner.xcodeproj
   │  │  │  │  │  │  │  ├─ project.pbxproj
   │  │  │  │  │  │  │  ├─ project.xcworkspace
   │  │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ xcschemes
   │  │  │  │  │  │  │        └─ Runner.xcscheme
   │  │  │  │  │  │  ├─ Runner.xcworkspace
   │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │  │  │  │  │  └─ RunnerTests
   │  │  │  │  │  │     └─ RunnerTests.swift
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ linux
   │  │  │  │  │  │  ├─ CMakeLists.txt
   │  │  │  │  │  │  ├─ flutter
   │  │  │  │  │  │  │  └─ CMakeLists.txt
   │  │  │  │  │  │  ├─ main.cc
   │  │  │  │  │  │  ├─ my_application.cc
   │  │  │  │  │  │  └─ my_application.h
   │  │  │  │  │  ├─ macos
   │  │  │  │  │  │  ├─ Flutter
   │  │  │  │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │  │  │  │  │  │  └─ Flutter-Release.xcconfig
   │  │  │  │  │  │  ├─ Runner
   │  │  │  │  │  │  │  ├─ AppDelegate.swift
   │  │  │  │  │  │  │  ├─ Assets.xcassets
   │  │  │  │  │  │  │  │  └─ AppIcon.appiconset
   │  │  │  │  │  │  │  │     ├─ app_icon_1024.png
   │  │  │  │  │  │  │  │     ├─ app_icon_128.png
   │  │  │  │  │  │  │  │     ├─ app_icon_16.png
   │  │  │  │  │  │  │  │     ├─ app_icon_256.png
   │  │  │  │  │  │  │  │     ├─ app_icon_32.png
   │  │  │  │  │  │  │  │     ├─ app_icon_512.png
   │  │  │  │  │  │  │  │     ├─ app_icon_64.png
   │  │  │  │  │  │  │  │     └─ Contents.json
   │  │  │  │  │  │  │  ├─ Base.lproj
   │  │  │  │  │  │  │  │  └─ MainMenu.xib
   │  │  │  │  │  │  │  ├─ Configs
   │  │  │  │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │  │  │  │  │  │  │  ├─ Debug.xcconfig
   │  │  │  │  │  │  │  │  ├─ Release.xcconfig
   │  │  │  │  │  │  │  │  └─ Warnings.xcconfig
   │  │  │  │  │  │  │  ├─ DebugProfile.entitlements
   │  │  │  │  │  │  │  ├─ Info.plist
   │  │  │  │  │  │  │  ├─ MainFlutterWindow.swift
   │  │  │  │  │  │  │  └─ Release.entitlements
   │  │  │  │  │  │  ├─ Runner.xcodeproj
   │  │  │  │  │  │  │  ├─ project.pbxproj
   │  │  │  │  │  │  │  ├─ project.xcworkspace
   │  │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ xcschemes
   │  │  │  │  │  │  │        └─ Runner.xcscheme
   │  │  │  │  │  │  ├─ Runner.xcworkspace
   │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  └─ RunnerTests
   │  │  │  │  │  │     └─ RunnerTests.swift
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ pubspec_overrides.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  ├─ web
   │  │  │  │  │  │  ├─ favicon.png
   │  │  │  │  │  │  ├─ icons
   │  │  │  │  │  │  │  ├─ Icon-192.png
   │  │  │  │  │  │  │  ├─ Icon-512.png
   │  │  │  │  │  │  │  ├─ Icon-maskable-192.png
   │  │  │  │  │  │  │  └─ Icon-maskable-512.png
   │  │  │  │  │  │  ├─ index.html
   │  │  │  │  │  │  └─ manifest.json
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  └─ CMakeLists.txt
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ run_loop.cpp
   │  │  │  │  │        ├─ run_loop.h
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ ios
   │  │  │  │  │  ├─ Classes
   │  │  │  │  │  │  ├─ ConnectivityPlusPlugin.h
   │  │  │  │  │  │  ├─ ConnectivityPlusPlugin.m
   │  │  │  │  │  │  ├─ ConnectivityProvider.swift
   │  │  │  │  │  │  ├─ PathMonitorConnectivityProvider.swift
   │  │  │  │  │  │  ├─ ReachabilityConnectivityProvider.swift
   │  │  │  │  │  │  └─ SwiftConnectivityPlusPlugin.swift
   │  │  │  │  │  └─ connectivity_plus.podspec
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ connectivity_plus.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ connectivity_plus_linux.dart
   │  │  │  │  │     ├─ connectivity_plus_web.dart
   │  │  │  │  │     └─ web
   │  │  │  │  │        ├─ dart_html_connectivity_plugin.dart
   │  │  │  │  │        ├─ network_information_api_connectivity_plugin.dart
   │  │  │  │  │        └─ utils
   │  │  │  │  │           └─ connectivity_result.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ macos
   │  │  │  │  │  ├─ Classes
   │  │  │  │  │  │  ├─ ConnectivityPlugin.swift
   │  │  │  │  │  │  ├─ ConnectivityProvider.swift
   │  │  │  │  │  │  ├─ PathMonitorConnectivityProvider.swift
   │  │  │  │  │  │  └─ ReachabilityConnectivityProvider.swift
   │  │  │  │  │  └─ connectivity_plus.podspec
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  ├─ connectivity_plus_linux_test.dart
   │  │  │  │  │  ├─ connectivity_plus_linux_test.mocks.dart
   │  │  │  │  │  └─ connectivity_test.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ connectivity_plus_plugin.cpp
   │  │  │  │     ├─ include
   │  │  │  │     │  └─ connectivity_plus
   │  │  │  │     │     ├─ connectivity_plus_windows_plugin.h
   │  │  │  │     │     └─ network_manager.h
   │  │  │  │     └─ network_manager.cpp
   │  │  │  ├─ file_selector_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  ├─ get_directory_page.dart
   │  │  │  │  │  │  ├─ get_multiple_directories_page.dart
   │  │  │  │  │  │  ├─ home_page.dart
   │  │  │  │  │  │  ├─ main.dart
   │  │  │  │  │  │  ├─ open_image_page.dart
   │  │  │  │  │  │  ├─ open_multiple_images_page.dart
   │  │  │  │  │  │  ├─ open_text_page.dart
   │  │  │  │  │  │  └─ save_text_page.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ file_selector_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     └─ messages.g.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pigeons
   │  │  │  │  │  ├─ copyright.txt
   │  │  │  │  │  └─ messages.dart
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  ├─ file_selector_windows_test.dart
   │  │  │  │  │  ├─ file_selector_windows_test.mocks.dart
   │  │  │  │  │  └─ test_api.g.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ file_dialog_controller.cpp
   │  │  │  │     ├─ file_dialog_controller.h
   │  │  │  │     ├─ file_selector_plugin.cpp
   │  │  │  │     ├─ file_selector_plugin.h
   │  │  │  │     ├─ file_selector_windows.cpp
   │  │  │  │     ├─ include
   │  │  │  │     │  └─ file_selector_windows
   │  │  │  │     │     └─ file_selector_windows.h
   │  │  │  │     ├─ messages.g.cpp
   │  │  │  │     ├─ messages.g.h
   │  │  │  │     ├─ string_utils.cpp
   │  │  │  │     ├─ string_utils.h
   │  │  │  │     └─ test
   │  │  │  │        ├─ file_selector_plugin_test.cpp
   │  │  │  │        ├─ test_file_dialog_controller.cpp
   │  │  │  │        ├─ test_file_dialog_controller.h
   │  │  │  │        ├─ test_main.cpp
   │  │  │  │        ├─ test_utils.cpp
   │  │  │  │        └─ test_utils.h
   │  │  │  ├─ flutter_secure_storage_windows
   │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ app_test.dart
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  ├─ generated_plugins.cmake
   │  │  │  │  │     │  ├─ generated_plugin_registrant.cc
   │  │  │  │  │     │  └─ generated_plugin_registrant.h
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ flutter_secure_storage_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ flutter_secure_storage_windows_ffi.dart
   │  │  │  │  │     └─ flutter_secure_storage_windows_stub.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  └─ unit_test.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ flutter_secure_storage_windows_plugin.cpp
   │  │  │  │     └─ include
   │  │  │  │        └─ flutter_secure_storage_windows
   │  │  │  │           └─ flutter_secure_storage_windows_plugin.h
   │  │  │  ├─ image_picker_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  └─ image_picker_windows.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  └─ test
   │  │  │  │     ├─ image_picker_windows_test.dart
   │  │  │  │     └─ image_picker_windows_test.mocks.dart
   │  │  │  ├─ path_provider_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ path_provider_test.dart
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  ├─ test_driver
   │  │  │  │  │  │  └─ integration_test.dart
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ run_loop.cpp
   │  │  │  │  │        ├─ run_loop.h
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ path_provider_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ folders.dart
   │  │  │  │  │     ├─ folders_stub.dart
   │  │  │  │  │     ├─ path_provider_windows_real.dart
   │  │  │  │  │     └─ path_provider_windows_stub.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  └─ test
   │  │  │  │     └─ path_provider_windows_test.dart
   │  │  │  └─ permission_handler_windows
   │  │  │     ├─ AUTHORS
   │  │  │     ├─ CHANGELOG.md
   │  │  │     ├─ example
   │  │  │     │  ├─ lib
   │  │  │     │  │  └─ main.dart
   │  │  │     │  ├─ pubspec.yaml
   │  │  │     │  ├─ README.md
   │  │  │     │  ├─ res
   │  │  │     │  │  └─ images
   │  │  │     │  │     ├─ baseflow_logo_def_light-02.png
   │  │  │     │  │     ├─ poweredByBaseflowLogoLight.png
   │  │  │     │  │     ├─ poweredByBaseflowLogoLight@2x.png
   │  │  │     │  │     └─ poweredByBaseflowLogoLight@3x.png
   │  │  │     │  └─ windows
   │  │  │     │     ├─ CMakeLists.txt
   │  │  │     │     ├─ flutter
   │  │  │     │     │  ├─ CMakeLists.txt
   │  │  │     │     │  ├─ generated_plugins.cmake
   │  │  │     │     │  ├─ generated_plugin_registrant.cc
   │  │  │     │     │  └─ generated_plugin_registrant.h
   │  │  │     │     └─ runner
   │  │  │     │        ├─ CMakeLists.txt
   │  │  │     │        ├─ flutter_window.cpp
   │  │  │     │        ├─ flutter_window.h
   │  │  │     │        ├─ main.cpp
   │  │  │     │        ├─ resource.h
   │  │  │     │        ├─ resources
   │  │  │     │        │  └─ app_icon.ico
   │  │  │     │        ├─ runner.exe.manifest
   │  │  │     │        ├─ Runner.rc
   │  │  │     │        ├─ utils.cpp
   │  │  │     │        ├─ utils.h
   │  │  │     │        ├─ win32_window.cpp
   │  │  │     │        └─ win32_window.h
   │  │  │     ├─ LICENSE
   │  │  │     ├─ pubspec.yaml
   │  │  │     ├─ README.md
   │  │  │     └─ windows
   │  │  │        ├─ CMakeLists.txt
   │  │  │        ├─ include
   │  │  │        │  └─ permission_handler_windows
   │  │  │        │     └─ permission_handler_windows_plugin.h
   │  │  │        ├─ permission_constants.h
   │  │  │        └─ permission_handler_windows_plugin.cpp
   │  │  ├─ cpp_client_wrapper
   │  │  │  ├─ binary_messenger_impl.h
   │  │  │  ├─ byte_buffer_streams.h
   │  │  │  ├─ core_implementations.cc
   │  │  │  ├─ engine_method_result.cc
   │  │  │  ├─ flutter_engine.cc
   │  │  │  ├─ flutter_view_controller.cc
   │  │  │  ├─ include
   │  │  │  │  └─ flutter
   │  │  │  │     ├─ basic_message_channel.h
   │  │  │  │     ├─ binary_messenger.h
   │  │  │  │     ├─ byte_streams.h
   │  │  │  │     ├─ dart_project.h
   │  │  │  │     ├─ encodable_value.h
   │  │  │  │     ├─ engine_method_result.h
   │  │  │  │     ├─ event_channel.h
   │  │  │  │     ├─ event_sink.h
   │  │  │  │     ├─ event_stream_handler.h
   │  │  │  │     ├─ event_stream_handler_functions.h
   │  │  │  │     ├─ flutter_engine.h
   │  │  │  │     ├─ flutter_view.h
   │  │  │  │     ├─ flutter_view_controller.h
   │  │  │  │     ├─ message_codec.h
   │  │  │  │     ├─ method_call.h
   │  │  │  │     ├─ method_channel.h
   │  │  │  │     ├─ method_codec.h
   │  │  │  │     ├─ method_result.h
   │  │  │  │     ├─ method_result_functions.h
   │  │  │  │     ├─ plugin_registrar.h
   │  │  │  │     ├─ plugin_registrar_windows.h
   │  │  │  │     ├─ plugin_registry.h
   │  │  │  │     ├─ standard_codec_serializer.h
   │  │  │  │     ├─ standard_message_codec.h
   │  │  │  │     ├─ standard_method_codec.h
   │  │  │  │     └─ texture_registrar.h
   │  │  │  ├─ plugin_registrar.cc
   │  │  │  ├─ readme
   │  │  │  ├─ standard_codec.cc
   │  │  │  └─ texture_registrar_impl.h
   │  │  ├─ flutter_export.h
   │  │  ├─ flutter_messenger.h
   │  │  ├─ flutter_plugin_registrar.h
   │  │  ├─ flutter_texture_registrar.h
   │  │  ├─ flutter_windows.dll
   │  │  ├─ flutter_windows.dll.exp
   │  │  ├─ flutter_windows.dll.lib
   │  │  ├─ flutter_windows.dll.pdb
   │  │  ├─ flutter_windows.h
   │  │  ├─ generated_config.cmake
   │  │  └─ icudtl.dat
   │  ├─ generated_plugins.cmake
   │  ├─ generated_plugin_registrant.cc
   │  └─ generated_plugin_registrant.h
   └─ runner
      ├─ CMakeLists.txt
      ├─ flutter_window.cpp
      ├─ flutter_window.h
      ├─ main.cpp
      ├─ resource.h
      ├─ resources
      │  └─ app_icon.ico
      ├─ runner.exe.manifest
      ├─ Runner.rc
      ├─ utils.cpp
      ├─ utils.h
      ├─ win32_window.cpp
      └─ win32_window.h

```
```
omelet
├─ .gitignore
├─ .metadata
├─ .vscode
│  └─ launch.json
├─ analysis_options.yaml
├─ android
│  ├─ .gitignore
│  ├─ .gradle
│  │  ├─ 7.5
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ dependencies-accessors
│  │  │  │  ├─ dependencies-accessors.lock
│  │  │  │  └─ gc.properties
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ app
│  │  ├─ build.gradle
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  ├─ com
│  │     │  │  │  └─ omelet
│  │     │  │  │     └─ omelet
│  │     │  │  │        └─ MainActivity.java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  ├─ local.properties
│  └─ settings.gradle
├─ assets
│  ├─ env.webloc
│  ├─ maple.png
│  ├─ nini.png
│  ├─ thomas.png
│  ├─ userOmelet.png
│  └─ xeift.png
├─ Brewfile
├─ fonts
│  └─ CustomIcons.ttf
├─ ios
│  ├─ .gitignore
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ flutter_export_environment 2.sh
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated 2.xcconfig
│  │  ├─ Generated.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Podfile
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-50x50@1x.png
│  │  │  │  ├─ Icon-App-50x50@2x.png
│  │  │  │  ├─ Icon-App-57x57@1x.png
│  │  │  │  ├─ Icon-App-57x57@2x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-72x72@1x.png
│  │  │  │  ├─ Icon-App-72x72@2x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ api
│  │  ├─ debug_reset_prekeybundle_and_unread_msg.dart
│  │  ├─ get
│  │  │  ├─ download_pre_key_bundle_api.dart
│  │  │  ├─ get_available_opk_index_api.dart
│  │  │  ├─ get_device_ids_api.dart
│  │  │  ├─ get_friend_list_api.dart
│  │  │  ├─ get_friend_request_api.dart
│  │  │  ├─ get_self_opk_status_api.dart
│  │  │  ├─ get_self_spk_status_api.dart
│  │  │  ├─ get_unread_msg_api.dart
│  │  │  └─ get_user_public_info_api.dart
│  │  ├─ multi_screen
│  │  │  └─ multi_screen_page.dart
│  │  └─ post
│  │     ├─ get_translated_sentence_api.dart
│  │     ├─ login_api.dart
│  │     ├─ remove_friend_api.dart
│  │     ├─ reply_friend_request_api.dart
│  │     ├─ reset_password_api.dart
│  │     ├─ send_friend_request_api.dart
│  │     ├─ signup_api.dart
│  │     ├─ update_opk_api.dart
│  │     ├─ update_pfp_api.dart
│  │     ├─ update_spk_api.dart
│  │     ├─ upload_img_api.dart
│  │     └─ upload_pre_key_bundle_api.dart
│  ├─ componets
│  │  ├─ alert
│  │  │  └─ alert_msg.dart
│  │  ├─ button
│  │  │  ├─ on_select_image_btn_pressed.dart
│  │  │  ├─ on_send_msg_btn_pressed.dart
│  │  │  └─ on_update_pfp_btn_pressed.dart
│  │  ├─ message
│  │  │  ├─ avatar.dart
│  │  │  ├─ avatar_user.dart
│  │  │  └─ glow_bar.dart
│  │  ├─ Screen
│  │  │  └─ frosted_appbr.dart
│  │  └─ setting
│  │     ├─ avatar_card.dart
│  │     └─ setting_title.dart
│  ├─ developer
│  │  ├─ developer_page.dart
│  │  └─ test_ping_page.dart
│  ├─ main.dart
│  ├─ models
│  │  ├─ message_data.dart
│  │  └─ setting.dart
│  ├─ notify
│  │  └─ notify.dart
│  ├─ pages
│  │  ├─ friends_page
│  │  │  ├─ friends_add_page.dart
│  │  │  └─ friends_list_page.dart
│  │  ├─ login_signup
│  │  │  ├─ forget_page.dart
│  │  │  ├─ forget_validator_page.dart
│  │  │  ├─ loading_page.dart
│  │  │  ├─ login_page.dart
│  │  │  └─ sign_up_page.dart
│  │  ├─ message
│  │  │  ├─ chat_room_page.dart
│  │  │  └─ multi_screen
│  │  │     └─ multi_chat_room.dart
│  │  ├─ message_list_page.dart
│  │  ├─ nav_bar_control_page.dart
│  │  ├─ notification_page
│  │  │  └─ notification_page.dart
│  │  └─ setting
│  │     └─ setting_page.dart
│  ├─ signal_protocol
│  │  ├─ decrypt_msg.dart
│  │  ├─ encrypt_msg.dart
│  │  ├─ encrypt_pre_key_signal_message.dart
│  │  ├─ encrypt_signal_message.dart
│  │  ├─ generate_and_store_key.dart
│  │  ├─ pre_key_bundle_converter.dart
│  │  ├─ safe_identity_store.dart
│  │  ├─ safe_opk_store.dart
│  │  ├─ safe_session_store.dart
│  │  ├─ safe_signal_protocol_store.dart
│  │  └─ safe_spk_store.dart
│  ├─ storage
│  │  ├─ safe_account_store.dart
│  │  ├─ safe_config_store.dart
│  │  ├─ safe_device_id_store.dart
│  │  ├─ safe_msg_store.dart
│  │  ├─ safe_notify_store.dart
│  │  └─ safe_util_store.dart
│  ├─ theme
│  │  ├─ theme_constants.dart
│  │  └─ theme_provider.dart
│  └─ utils
│     ├─ check_device_id.dart
│     ├─ check_opk_status.dart
│     ├─ check_spk_status.dart
│     ├─ check_unread_msg.dart
│     ├─ check_unread_notify.dart
│     ├─ generate_random_filename.dart
│     ├─ get_friends_list.dart
│     ├─ helpers.dart
│     ├─ server_uri.dart
│     └─ timstamp.dart
├─ OmeletIcon.png
├─ pubspec.lock
├─ pubspec.yaml
├─ README.md
├─ test
│  └─ widget_test.dart
├─ web
│  ├─ favicon.png
│  ├─ icons
│  │  ├─ Icon-192.png
│  │  ├─ Icon-512.png
│  │  ├─ Icon-maskable-192.png
│  │  └─ Icon-maskable-512.png
│  └─ manifest.json
└─ windows
   ├─ .gitignore
   ├─ CMakeLists.txt
   ├─ flutter
   │  ├─ CMakeLists.txt
   │  ├─ ephemeral
   │  │  ├─ .plugin_symlinks
   │  │  │  ├─ connectivity_plus
   │  │  │  │  ├─ android
   │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  ├─ gradle.properties
   │  │  │  │  │  ├─ settings.gradle
   │  │  │  │  │  └─ src
   │  │  │  │  │     └─ main
   │  │  │  │  │        ├─ AndroidManifest.xml
   │  │  │  │  │        └─ java
   │  │  │  │  │           └─ dev
   │  │  │  │  │              └─ fluttercommunity
   │  │  │  │  │                 └─ plus
   │  │  │  │  │                    └─ connectivity
   │  │  │  │  │                       ├─ Connectivity.java
   │  │  │  │  │                       ├─ ConnectivityBroadcastReceiver.java
   │  │  │  │  │                       ├─ ConnectivityMethodChannelHandler.java
   │  │  │  │  │                       └─ ConnectivityPlugin.java
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  │  ├─ android
   │  │  │  │  │  │  ├─ app
   │  │  │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  │  │  └─ src
   │  │  │  │  │  │  │     └─ main
   │  │  │  │  │  │  │        ├─ AndroidManifest.xml
   │  │  │  │  │  │  │        ├─ java
   │  │  │  │  │  │  │        │  └─ io
   │  │  │  │  │  │  │        │     └─ flutter
   │  │  │  │  │  │  │        │        └─ plugins
   │  │  │  │  │  │  │        │           └─ connectivityexample
   │  │  │  │  │  │  │        │              └─ FlutterActivityTest.java
   │  │  │  │  │  │  │        └─ res
   │  │  │  │  │  │  │           ├─ mipmap-hdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-mdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-xhdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-xxhdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           └─ mipmap-xxxhdpi
   │  │  │  │  │  │  │              └─ ic_launcher.png
   │  │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  │  ├─ gradle.properties
   │  │  │  │  │  │  └─ settings.gradle
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ connectivity_plus_test.dart
   │  │  │  │  │  ├─ ios
   │  │  │  │  │  │  ├─ Flutter
   │  │  │  │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │  │  │  │  │  │  ├─ Debug.xcconfig
   │  │  │  │  │  │  │  └─ Release.xcconfig
   │  │  │  │  │  │  ├─ Runner
   │  │  │  │  │  │  │  ├─ AppDelegate.swift
   │  │  │  │  │  │  │  ├─ Assets.xcassets
   │  │  │  │  │  │  │  │  ├─ AppIcon.appiconset
   │  │  │  │  │  │  │  │  │  ├─ Contents.json
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │  │  │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │  │  │  │  │  │  │  └─ LaunchImage.imageset
   │  │  │  │  │  │  │  │     ├─ Contents.json
   │  │  │  │  │  │  │  │     ├─ LaunchImage.png
   │  │  │  │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │  │  │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │  │  │  │  │  │  │     └─ README.md
   │  │  │  │  │  │  │  ├─ Base.lproj
   │  │  │  │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │  │  │  │  │  │  │  └─ Main.storyboard
   │  │  │  │  │  │  │  ├─ Info.plist
   │  │  │  │  │  │  │  └─ Runner-Bridging-Header.h
   │  │  │  │  │  │  ├─ Runner.xcodeproj
   │  │  │  │  │  │  │  ├─ project.pbxproj
   │  │  │  │  │  │  │  ├─ project.xcworkspace
   │  │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ xcschemes
   │  │  │  │  │  │  │        └─ Runner.xcscheme
   │  │  │  │  │  │  ├─ Runner.xcworkspace
   │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │  │  │  │  │  └─ RunnerTests
   │  │  │  │  │  │     └─ RunnerTests.swift
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ linux
   │  │  │  │  │  │  ├─ CMakeLists.txt
   │  │  │  │  │  │  ├─ flutter
   │  │  │  │  │  │  │  └─ CMakeLists.txt
   │  │  │  │  │  │  ├─ main.cc
   │  │  │  │  │  │  ├─ my_application.cc
   │  │  │  │  │  │  └─ my_application.h
   │  │  │  │  │  ├─ macos
   │  │  │  │  │  │  ├─ Flutter
   │  │  │  │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │  │  │  │  │  │  └─ Flutter-Release.xcconfig
   │  │  │  │  │  │  ├─ Runner
   │  │  │  │  │  │  │  ├─ AppDelegate.swift
   │  │  │  │  │  │  │  ├─ Assets.xcassets
   │  │  │  │  │  │  │  │  └─ AppIcon.appiconset
   │  │  │  │  │  │  │  │     ├─ app_icon_1024.png
   │  │  │  │  │  │  │  │     ├─ app_icon_128.png
   │  │  │  │  │  │  │  │     ├─ app_icon_16.png
   │  │  │  │  │  │  │  │     ├─ app_icon_256.png
   │  │  │  │  │  │  │  │     ├─ app_icon_32.png
   │  │  │  │  │  │  │  │     ├─ app_icon_512.png
   │  │  │  │  │  │  │  │     ├─ app_icon_64.png
   │  │  │  │  │  │  │  │     └─ Contents.json
   │  │  │  │  │  │  │  ├─ Base.lproj
   │  │  │  │  │  │  │  │  └─ MainMenu.xib
   │  │  │  │  │  │  │  ├─ Configs
   │  │  │  │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │  │  │  │  │  │  │  ├─ Debug.xcconfig
   │  │  │  │  │  │  │  │  ├─ Release.xcconfig
   │  │  │  │  │  │  │  │  └─ Warnings.xcconfig
   │  │  │  │  │  │  │  ├─ DebugProfile.entitlements
   │  │  │  │  │  │  │  ├─ Info.plist
   │  │  │  │  │  │  │  ├─ MainFlutterWindow.swift
   │  │  │  │  │  │  │  └─ Release.entitlements
   │  │  │  │  │  │  ├─ Runner.xcodeproj
   │  │  │  │  │  │  │  ├─ project.pbxproj
   │  │  │  │  │  │  │  ├─ project.xcworkspace
   │  │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ xcschemes
   │  │  │  │  │  │  │        └─ Runner.xcscheme
   │  │  │  │  │  │  ├─ Runner.xcworkspace
   │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  └─ RunnerTests
   │  │  │  │  │  │     └─ RunnerTests.swift
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ pubspec_overrides.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  ├─ web
   │  │  │  │  │  │  ├─ favicon.png
   │  │  │  │  │  │  ├─ icons
   │  │  │  │  │  │  │  ├─ Icon-192.png
   │  │  │  │  │  │  │  ├─ Icon-512.png
   │  │  │  │  │  │  │  ├─ Icon-maskable-192.png
   │  │  │  │  │  │  │  └─ Icon-maskable-512.png
   │  │  │  │  │  │  ├─ index.html
   │  │  │  │  │  │  └─ manifest.json
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  └─ CMakeLists.txt
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ run_loop.cpp
   │  │  │  │  │        ├─ run_loop.h
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ ios
   │  │  │  │  │  ├─ Classes
   │  │  │  │  │  │  ├─ ConnectivityPlusPlugin.h
   │  │  │  │  │  │  ├─ ConnectivityPlusPlugin.m
   │  │  │  │  │  │  ├─ ConnectivityProvider.swift
   │  │  │  │  │  │  ├─ PathMonitorConnectivityProvider.swift
   │  │  │  │  │  │  ├─ ReachabilityConnectivityProvider.swift
   │  │  │  │  │  │  └─ SwiftConnectivityPlusPlugin.swift
   │  │  │  │  │  └─ connectivity_plus.podspec
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ connectivity_plus.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ connectivity_plus_linux.dart
   │  │  │  │  │     ├─ connectivity_plus_web.dart
   │  │  │  │  │     └─ web
   │  │  │  │  │        ├─ dart_html_connectivity_plugin.dart
   │  │  │  │  │        ├─ network_information_api_connectivity_plugin.dart
   │  │  │  │  │        └─ utils
   │  │  │  │  │           └─ connectivity_result.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ macos
   │  │  │  │  │  ├─ Classes
   │  │  │  │  │  │  ├─ ConnectivityPlugin.swift
   │  │  │  │  │  │  ├─ ConnectivityProvider.swift
   │  │  │  │  │  │  ├─ PathMonitorConnectivityProvider.swift
   │  │  │  │  │  │  └─ ReachabilityConnectivityProvider.swift
   │  │  │  │  │  └─ connectivity_plus.podspec
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  ├─ connectivity_plus_linux_test.dart
   │  │  │  │  │  ├─ connectivity_plus_linux_test.mocks.dart
   │  │  │  │  │  └─ connectivity_test.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ connectivity_plus_plugin.cpp
   │  │  │  │     ├─ include
   │  │  │  │     │  └─ connectivity_plus
   │  │  │  │     │     ├─ connectivity_plus_windows_plugin.h
   │  │  │  │     │     └─ network_manager.h
   │  │  │  │     └─ network_manager.cpp
   │  │  │  ├─ file_selector_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  ├─ get_directory_page.dart
   │  │  │  │  │  │  ├─ get_multiple_directories_page.dart
   │  │  │  │  │  │  ├─ home_page.dart
   │  │  │  │  │  │  ├─ main.dart
   │  │  │  │  │  │  ├─ open_image_page.dart
   │  │  │  │  │  │  ├─ open_multiple_images_page.dart
   │  │  │  │  │  │  ├─ open_text_page.dart
   │  │  │  │  │  │  └─ save_text_page.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ file_selector_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     └─ messages.g.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pigeons
   │  │  │  │  │  ├─ copyright.txt
   │  │  │  │  │  └─ messages.dart
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  ├─ file_selector_windows_test.dart
   │  │  │  │  │  ├─ file_selector_windows_test.mocks.dart
   │  │  │  │  │  └─ test_api.g.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ file_dialog_controller.cpp
   │  │  │  │     ├─ file_dialog_controller.h
   │  │  │  │     ├─ file_selector_plugin.cpp
   │  │  │  │     ├─ file_selector_plugin.h
   │  │  │  │     ├─ file_selector_windows.cpp
   │  │  │  │     ├─ include
   │  │  │  │     │  └─ file_selector_windows
   │  │  │  │     │     └─ file_selector_windows.h
   │  │  │  │     ├─ messages.g.cpp
   │  │  │  │     ├─ messages.g.h
   │  │  │  │     ├─ string_utils.cpp
   │  │  │  │     ├─ string_utils.h
   │  │  │  │     └─ test
   │  │  │  │        ├─ file_selector_plugin_test.cpp
   │  │  │  │        ├─ test_file_dialog_controller.cpp
   │  │  │  │        ├─ test_file_dialog_controller.h
   │  │  │  │        ├─ test_main.cpp
   │  │  │  │        ├─ test_utils.cpp
   │  │  │  │        └─ test_utils.h
   │  │  │  ├─ flutter_secure_storage_windows
   │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ app_test.dart
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  ├─ generated_plugins.cmake
   │  │  │  │  │     │  ├─ generated_plugin_registrant.cc
   │  │  │  │  │     │  └─ generated_plugin_registrant.h
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ flutter_secure_storage_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ flutter_secure_storage_windows_ffi.dart
   │  │  │  │  │     └─ flutter_secure_storage_windows_stub.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  └─ unit_test.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ flutter_secure_storage_windows_plugin.cpp
   │  │  │  │     └─ include
   │  │  │  │        └─ flutter_secure_storage_windows
   │  │  │  │           └─ flutter_secure_storage_windows_plugin.h
   │  │  │  ├─ image_picker_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  └─ image_picker_windows.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  └─ test
   │  │  │  │     ├─ image_picker_windows_test.dart
   │  │  │  │     └─ image_picker_windows_test.mocks.dart
   │  │  │  ├─ path_provider_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ path_provider_test.dart
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  ├─ test_driver
   │  │  │  │  │  │  └─ integration_test.dart
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ run_loop.cpp
   │  │  │  │  │        ├─ run_loop.h
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ path_provider_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ folders.dart
   │  │  │  │  │     ├─ folders_stub.dart
   │  │  │  │  │     ├─ path_provider_windows_real.dart
   │  │  │  │  │     └─ path_provider_windows_stub.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  └─ test
   │  │  │  │     └─ path_provider_windows_test.dart
   │  │  │  └─ permission_handler_windows
   │  │  │     ├─ AUTHORS
   │  │  │     ├─ CHANGELOG.md
   │  │  │     ├─ example
   │  │  │     │  ├─ lib
   │  │  │     │  │  └─ main.dart
   │  │  │     │  ├─ pubspec.yaml
   │  │  │     │  ├─ README.md
   │  │  │     │  ├─ res
   │  │  │     │  │  └─ images
   │  │  │     │  │     ├─ baseflow_logo_def_light-02.png
   │  │  │     │  │     ├─ poweredByBaseflowLogoLight.png
   │  │  │     │  │     ├─ poweredByBaseflowLogoLight@2x.png
   │  │  │     │  │     └─ poweredByBaseflowLogoLight@3x.png
   │  │  │     │  └─ windows
   │  │  │     │     ├─ CMakeLists.txt
   │  │  │     │     ├─ flutter
   │  │  │     │     │  ├─ CMakeLists.txt
   │  │  │     │     │  ├─ generated_plugins.cmake
   │  │  │     │     │  ├─ generated_plugin_registrant.cc
   │  │  │     │     │  └─ generated_plugin_registrant.h
   │  │  │     │     └─ runner
   │  │  │     │        ├─ CMakeLists.txt
   │  │  │     │        ├─ flutter_window.cpp
   │  │  │     │        ├─ flutter_window.h
   │  │  │     │        ├─ main.cpp
   │  │  │     │        ├─ resource.h
   │  │  │     │        ├─ resources
   │  │  │     │        │  └─ app_icon.ico
   │  │  │     │        ├─ runner.exe.manifest
   │  │  │     │        ├─ Runner.rc
   │  │  │     │        ├─ utils.cpp
   │  │  │     │        ├─ utils.h
   │  │  │     │        ├─ win32_window.cpp
   │  │  │     │        └─ win32_window.h
   │  │  │     ├─ LICENSE
   │  │  │     ├─ pubspec.yaml
   │  │  │     ├─ README.md
   │  │  │     └─ windows
   │  │  │        ├─ CMakeLists.txt
   │  │  │        ├─ include
   │  │  │        │  └─ permission_handler_windows
   │  │  │        │     └─ permission_handler_windows_plugin.h
   │  │  │        ├─ permission_constants.h
   │  │  │        └─ permission_handler_windows_plugin.cpp
   │  │  ├─ cpp_client_wrapper
   │  │  │  ├─ binary_messenger_impl.h
   │  │  │  ├─ byte_buffer_streams.h
   │  │  │  ├─ core_implementations.cc
   │  │  │  ├─ engine_method_result.cc
   │  │  │  ├─ flutter_engine.cc
   │  │  │  ├─ flutter_view_controller.cc
   │  │  │  ├─ include
   │  │  │  │  └─ flutter
   │  │  │  │     ├─ basic_message_channel.h
   │  │  │  │     ├─ binary_messenger.h
   │  │  │  │     ├─ byte_streams.h
   │  │  │  │     ├─ dart_project.h
   │  │  │  │     ├─ encodable_value.h
   │  │  │  │     ├─ engine_method_result.h
   │  │  │  │     ├─ event_channel.h
   │  │  │  │     ├─ event_sink.h
   │  │  │  │     ├─ event_stream_handler.h
   │  │  │  │     ├─ event_stream_handler_functions.h
   │  │  │  │     ├─ flutter_engine.h
   │  │  │  │     ├─ flutter_view.h
   │  │  │  │     ├─ flutter_view_controller.h
   │  │  │  │     ├─ message_codec.h
   │  │  │  │     ├─ method_call.h
   │  │  │  │     ├─ method_channel.h
   │  │  │  │     ├─ method_codec.h
   │  │  │  │     ├─ method_result.h
   │  │  │  │     ├─ method_result_functions.h
   │  │  │  │     ├─ plugin_registrar.h
   │  │  │  │     ├─ plugin_registrar_windows.h
   │  │  │  │     ├─ plugin_registry.h
   │  │  │  │     ├─ standard_codec_serializer.h
   │  │  │  │     ├─ standard_message_codec.h
   │  │  │  │     ├─ standard_method_codec.h
   │  │  │  │     └─ texture_registrar.h
   │  │  │  ├─ plugin_registrar.cc
   │  │  │  ├─ readme
   │  │  │  ├─ standard_codec.cc
   │  │  │  └─ texture_registrar_impl.h
   │  │  ├─ flutter_export.h
   │  │  ├─ flutter_messenger.h
   │  │  ├─ flutter_plugin_registrar.h
   │  │  ├─ flutter_texture_registrar.h
   │  │  ├─ flutter_windows.dll
   │  │  ├─ flutter_windows.dll.exp
   │  │  ├─ flutter_windows.dll.lib
   │  │  ├─ flutter_windows.dll.pdb
   │  │  ├─ flutter_windows.h
   │  │  ├─ generated_config.cmake
   │  │  └─ icudtl.dat
   │  ├─ generated_plugins.cmake
   │  ├─ generated_plugin_registrant.cc
   │  └─ generated_plugin_registrant.h
   └─ runner
      ├─ CMakeLists.txt
      ├─ flutter_window.cpp
      ├─ flutter_window.h
      ├─ main.cpp
      ├─ resource.h
      ├─ resources
      │  └─ app_icon.ico
      ├─ runner.exe.manifest
      ├─ Runner.rc
      ├─ utils.cpp
      ├─ utils.h
      ├─ win32_window.cpp
      └─ win32_window.h

```
```
omelet
├─ .gitignore
├─ .metadata
├─ .vscode
│  └─ launch.json
├─ analysis_options.yaml
├─ android
│  ├─ .gitignore
│  ├─ .gradle
│  │  ├─ 7.5
│  │  │  ├─ checksums
│  │  │  │  ├─ checksums.lock
│  │  │  │  ├─ md5-checksums.bin
│  │  │  │  └─ sha1-checksums.bin
│  │  │  ├─ dependencies-accessors
│  │  │  │  ├─ dependencies-accessors.lock
│  │  │  │  └─ gc.properties
│  │  │  ├─ executionHistory
│  │  │  │  ├─ executionHistory.bin
│  │  │  │  └─ executionHistory.lock
│  │  │  ├─ fileChanges
│  │  │  │  └─ last-build.bin
│  │  │  ├─ fileHashes
│  │  │  │  ├─ fileHashes.bin
│  │  │  │  ├─ fileHashes.lock
│  │  │  │  └─ resourceHashesCache.bin
│  │  │  ├─ gc.properties
│  │  │  └─ vcsMetadata
│  │  ├─ buildOutputCleanup
│  │  │  ├─ buildOutputCleanup.lock
│  │  │  ├─ cache.properties
│  │  │  └─ outputFiles.bin
│  │  ├─ file-system.probe
│  │  └─ vcs-1
│  │     └─ gc.properties
│  ├─ app
│  │  ├─ build.gradle
│  │  └─ src
│  │     ├─ debug
│  │     │  └─ AndroidManifest.xml
│  │     ├─ main
│  │     │  ├─ AndroidManifest.xml
│  │     │  ├─ java
│  │     │  │  ├─ com
│  │     │  │  │  └─ omelet
│  │     │  │  │     └─ omelet
│  │     │  │  │        └─ MainActivity.java
│  │     │  │  └─ io
│  │     │  │     └─ flutter
│  │     │  │        └─ plugins
│  │     │  │           └─ GeneratedPluginRegistrant.java
│  │     │  └─ res
│  │     │     ├─ drawable
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ drawable-v21
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launch_background.xml
│  │     │     ├─ mipmap-hdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-mdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ mipmap-xxxhdpi
│  │     │     │  ├─ ic_launcher.png
│  │     │     │  └─ launcher_icon.png
│  │     │     ├─ values
│  │     │     │  └─ styles.xml
│  │     │     └─ values-night
│  │     │        └─ styles.xml
│  │     └─ profile
│  │        └─ AndroidManifest.xml
│  ├─ build.gradle
│  ├─ gradle
│  │  └─ wrapper
│  │     ├─ gradle-wrapper.jar
│  │     └─ gradle-wrapper.properties
│  ├─ gradle.properties
│  ├─ gradlew
│  ├─ gradlew.bat
│  ├─ key.properties
│  ├─ local.properties
│  └─ settings.gradle
├─ assets
│  ├─ env.webloc
│  ├─ maple.png
│  ├─ nini.png
│  ├─ thomas.png
│  ├─ userOmelet.png
│  └─ xeift.png
├─ Brewfile
├─ fonts
│  └─ CustomIcons.ttf
├─ ios
│  ├─ .gitignore
│  ├─ Flutter
│  │  ├─ AppFrameworkInfo.plist
│  │  ├─ Debug.xcconfig
│  │  ├─ flutter_export_environment 2.sh
│  │  ├─ flutter_export_environment.sh
│  │  ├─ Generated 2.xcconfig
│  │  ├─ Generated.xcconfig
│  │  └─ Release.xcconfig
│  ├─ Podfile
│  ├─ Runner
│  │  ├─ AppDelegate.swift
│  │  ├─ Assets.xcassets
│  │  │  ├─ AppIcon.appiconset
│  │  │  │  ├─ Contents.json
│  │  │  │  ├─ Icon-App-1024x1024@1x.png
│  │  │  │  ├─ Icon-App-20x20@1x.png
│  │  │  │  ├─ Icon-App-20x20@2x.png
│  │  │  │  ├─ Icon-App-20x20@3x.png
│  │  │  │  ├─ Icon-App-29x29@1x.png
│  │  │  │  ├─ Icon-App-29x29@2x.png
│  │  │  │  ├─ Icon-App-29x29@3x.png
│  │  │  │  ├─ Icon-App-40x40@1x.png
│  │  │  │  ├─ Icon-App-40x40@2x.png
│  │  │  │  ├─ Icon-App-40x40@3x.png
│  │  │  │  ├─ Icon-App-50x50@1x.png
│  │  │  │  ├─ Icon-App-50x50@2x.png
│  │  │  │  ├─ Icon-App-57x57@1x.png
│  │  │  │  ├─ Icon-App-57x57@2x.png
│  │  │  │  ├─ Icon-App-60x60@2x.png
│  │  │  │  ├─ Icon-App-60x60@3x.png
│  │  │  │  ├─ Icon-App-72x72@1x.png
│  │  │  │  ├─ Icon-App-72x72@2x.png
│  │  │  │  ├─ Icon-App-76x76@1x.png
│  │  │  │  ├─ Icon-App-76x76@2x.png
│  │  │  │  └─ Icon-App-83.5x83.5@2x.png
│  │  │  └─ LaunchImage.imageset
│  │  │     ├─ Contents.json
│  │  │     ├─ LaunchImage.png
│  │  │     ├─ LaunchImage@2x.png
│  │  │     ├─ LaunchImage@3x.png
│  │  │     └─ README.md
│  │  ├─ Base.lproj
│  │  │  ├─ LaunchScreen.storyboard
│  │  │  └─ Main.storyboard
│  │  ├─ GeneratedPluginRegistrant.h
│  │  ├─ GeneratedPluginRegistrant.m
│  │  ├─ Info.plist
│  │  └─ Runner-Bridging-Header.h
│  ├─ Runner.xcodeproj
│  │  ├─ project.pbxproj
│  │  ├─ project.xcworkspace
│  │  │  ├─ contents.xcworkspacedata
│  │  │  └─ xcshareddata
│  │  │     ├─ IDEWorkspaceChecks.plist
│  │  │     └─ WorkspaceSettings.xcsettings
│  │  └─ xcshareddata
│  │     └─ xcschemes
│  │        └─ Runner.xcscheme
│  ├─ Runner.xcworkspace
│  │  ├─ contents.xcworkspacedata
│  │  └─ xcshareddata
│  │     ├─ IDEWorkspaceChecks.plist
│  │     └─ WorkspaceSettings.xcsettings
│  └─ RunnerTests
│     └─ RunnerTests.swift
├─ lib
│  ├─ api
│  │  ├─ debug_reset_prekeybundle_and_unread_msg.dart
│  │  ├─ get
│  │  │  ├─ download_pre_key_bundle_api.dart
│  │  │  ├─ get_available_opk_index_api.dart
│  │  │  ├─ get_device_ids_api.dart
│  │  │  ├─ get_friend_list_api.dart
│  │  │  ├─ get_friend_request_api.dart
│  │  │  ├─ get_self_opk_status_api.dart
│  │  │  ├─ get_self_spk_status_api.dart
│  │  │  ├─ get_unread_msg_api.dart
│  │  │  └─ get_user_public_info_api.dart
│  │  └─ post
│  │     ├─ get_translated_sentence_api.dart
│  │     ├─ login_api.dart
│  │     ├─ remove_friend_api.dart
│  │     ├─ reply_friend_request_api.dart
│  │     ├─ reset_password_api.dart
│  │     ├─ send_friend_request_api.dart
│  │     ├─ signup_api.dart
│  │     ├─ update_opk_api.dart
│  │     ├─ update_pfp_api.dart
│  │     ├─ update_spk_api.dart
│  │     ├─ upload_img_api.dart
│  │     └─ upload_pre_key_bundle_api.dart
│  ├─ components
│  │  ├─ alert
│  │  │  └─ alert_msg.dart
│  │  ├─ button
│  │  │  ├─ on_select_image_btn_pressed.dart
│  │  │  ├─ on_send_msg_btn_pressed.dart
│  │  │  └─ on_update_pfp_btn_pressed.dart
│  │  ├─ message
│  │  │  ├─ avatar.dart
│  │  │  ├─ avatar_user.dart
│  │  │  └─ glow_bar.dart
│  │  ├─ Screen
│  │  │  └─ frosted_appbr.dart
│  │  └─ setting
│  │     ├─ avatar_card.dart
│  │     └─ setting_title.dart
│  ├─ developer
│  │  ├─ developer_page.dart
│  │  └─ test_ping_page.dart
│  ├─ main.dart
│  ├─ models
│  │  ├─ message_data.dart
│  │  └─ setting.dart
│  ├─ notify
│  │  └─ notify.dart
│  ├─ pages
│  │  ├─ friends_page
│  │  │  ├─ friends_add_page.dart
│  │  │  └─ friends_list_page.dart
│  │  ├─ login_signup
│  │  │  ├─ forget_page.dart
│  │  │  ├─ forget_validator_page.dart
│  │  │  ├─ loading_page.dart
│  │  │  ├─ login_page.dart
│  │  │  └─ sign_up_page.dart
│  │  ├─ message
│  │  │  ├─ chat_room_page.dart
│  │  │  └─ multi_screen
│  │  │     └─ multi_chat_room.dart
│  │  ├─ message_list_page.dart
│  │  ├─ nav_bar_control_page.dart
│  │  ├─ notification_page
│  │  │  └─ notification_page.dart
│  │  └─ setting
│  │     └─ setting_page.dart
│  ├─ signal_protocol
│  │  ├─ decrypt_msg.dart
│  │  ├─ encrypt_msg.dart
│  │  ├─ encrypt_pre_key_signal_message.dart
│  │  ├─ encrypt_signal_message.dart
│  │  ├─ generate_and_store_key.dart
│  │  ├─ pre_key_bundle_converter.dart
│  │  ├─ safe_identity_store.dart
│  │  ├─ safe_opk_store.dart
│  │  ├─ safe_session_store.dart
│  │  ├─ safe_signal_protocol_store.dart
│  │  └─ safe_spk_store.dart
│  ├─ storage
│  │  ├─ safe_account_store.dart
│  │  ├─ safe_config_store.dart
│  │  ├─ safe_device_id_store.dart
│  │  ├─ safe_msg_store.dart
│  │  ├─ safe_notify_store.dart
│  │  └─ safe_util_store.dart
│  ├─ theme
│  │  ├─ theme_constants.dart
│  │  └─ theme_provider.dart
│  └─ utils
│     ├─ check_device_id.dart
│     ├─ check_opk_status.dart
│     ├─ check_spk_status.dart
│     ├─ check_unread_msg.dart
│     ├─ check_unread_notify.dart
│     ├─ generate_random_filename.dart
│     ├─ get_friends_list.dart
│     ├─ helpers.dart
│     ├─ server_uri.dart
│     └─ timstamp.dart
├─ OmeletIcon.png
├─ out
│  └─ android
├─ pubspec.lock
├─ pubspec.yaml
├─ README.md
├─ test
│  └─ widget_test.dart
├─ web
│  ├─ favicon.png
│  ├─ icons
│  │  ├─ Icon-192.png
│  │  ├─ Icon-512.png
│  │  ├─ Icon-maskable-192.png
│  │  └─ Icon-maskable-512.png
│  └─ manifest.json
└─ windows
   ├─ .gitignore
   ├─ CMakeLists.txt
   ├─ flutter
   │  ├─ CMakeLists.txt
   │  ├─ ephemeral
   │  │  ├─ .plugin_symlinks
   │  │  │  ├─ connectivity_plus
   │  │  │  │  ├─ android
   │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  ├─ gradle.properties
   │  │  │  │  │  ├─ settings.gradle
   │  │  │  │  │  └─ src
   │  │  │  │  │     └─ main
   │  │  │  │  │        ├─ AndroidManifest.xml
   │  │  │  │  │        └─ java
   │  │  │  │  │           └─ dev
   │  │  │  │  │              └─ fluttercommunity
   │  │  │  │  │                 └─ plus
   │  │  │  │  │                    └─ connectivity
   │  │  │  │  │                       ├─ Connectivity.java
   │  │  │  │  │                       ├─ ConnectivityBroadcastReceiver.java
   │  │  │  │  │                       ├─ ConnectivityMethodChannelHandler.java
   │  │  │  │  │                       └─ ConnectivityPlugin.java
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  │  ├─ android
   │  │  │  │  │  │  ├─ app
   │  │  │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  │  │  └─ src
   │  │  │  │  │  │  │     └─ main
   │  │  │  │  │  │  │        ├─ AndroidManifest.xml
   │  │  │  │  │  │  │        ├─ java
   │  │  │  │  │  │  │        │  └─ io
   │  │  │  │  │  │  │        │     └─ flutter
   │  │  │  │  │  │  │        │        └─ plugins
   │  │  │  │  │  │  │        │           └─ connectivityexample
   │  │  │  │  │  │  │        │              └─ FlutterActivityTest.java
   │  │  │  │  │  │  │        └─ res
   │  │  │  │  │  │  │           ├─ mipmap-hdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-mdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-xhdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           ├─ mipmap-xxhdpi
   │  │  │  │  │  │  │           │  └─ ic_launcher.png
   │  │  │  │  │  │  │           └─ mipmap-xxxhdpi
   │  │  │  │  │  │  │              └─ ic_launcher.png
   │  │  │  │  │  │  ├─ build.gradle
   │  │  │  │  │  │  ├─ gradle
   │  │  │  │  │  │  │  └─ wrapper
   │  │  │  │  │  │  │     └─ gradle-wrapper.properties
   │  │  │  │  │  │  ├─ gradle.properties
   │  │  │  │  │  │  └─ settings.gradle
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ connectivity_plus_test.dart
   │  │  │  │  │  ├─ ios
   │  │  │  │  │  │  ├─ Flutter
   │  │  │  │  │  │  │  ├─ AppFrameworkInfo.plist
   │  │  │  │  │  │  │  ├─ Debug.xcconfig
   │  │  │  │  │  │  │  └─ Release.xcconfig
   │  │  │  │  │  │  ├─ Runner
   │  │  │  │  │  │  │  ├─ AppDelegate.swift
   │  │  │  │  │  │  │  ├─ Assets.xcassets
   │  │  │  │  │  │  │  │  ├─ AppIcon.appiconset
   │  │  │  │  │  │  │  │  │  ├─ Contents.json
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-1024x1024@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-20x20@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-29x29@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-40x40@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-60x60@2x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-60x60@3x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-76x76@1x.png
   │  │  │  │  │  │  │  │  │  ├─ Icon-App-76x76@2x.png
   │  │  │  │  │  │  │  │  │  └─ Icon-App-83.5x83.5@2x.png
   │  │  │  │  │  │  │  │  └─ LaunchImage.imageset
   │  │  │  │  │  │  │  │     ├─ Contents.json
   │  │  │  │  │  │  │  │     ├─ LaunchImage.png
   │  │  │  │  │  │  │  │     ├─ LaunchImage@2x.png
   │  │  │  │  │  │  │  │     ├─ LaunchImage@3x.png
   │  │  │  │  │  │  │  │     └─ README.md
   │  │  │  │  │  │  │  ├─ Base.lproj
   │  │  │  │  │  │  │  │  ├─ LaunchScreen.storyboard
   │  │  │  │  │  │  │  │  └─ Main.storyboard
   │  │  │  │  │  │  │  ├─ Info.plist
   │  │  │  │  │  │  │  └─ Runner-Bridging-Header.h
   │  │  │  │  │  │  ├─ Runner.xcodeproj
   │  │  │  │  │  │  │  ├─ project.pbxproj
   │  │  │  │  │  │  │  ├─ project.xcworkspace
   │  │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ xcschemes
   │  │  │  │  │  │  │        └─ Runner.xcscheme
   │  │  │  │  │  │  ├─ Runner.xcworkspace
   │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     ├─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │     └─ WorkspaceSettings.xcsettings
   │  │  │  │  │  │  └─ RunnerTests
   │  │  │  │  │  │     └─ RunnerTests.swift
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ linux
   │  │  │  │  │  │  ├─ CMakeLists.txt
   │  │  │  │  │  │  ├─ flutter
   │  │  │  │  │  │  │  └─ CMakeLists.txt
   │  │  │  │  │  │  ├─ main.cc
   │  │  │  │  │  │  ├─ my_application.cc
   │  │  │  │  │  │  └─ my_application.h
   │  │  │  │  │  ├─ macos
   │  │  │  │  │  │  ├─ Flutter
   │  │  │  │  │  │  │  ├─ Flutter-Debug.xcconfig
   │  │  │  │  │  │  │  └─ Flutter-Release.xcconfig
   │  │  │  │  │  │  ├─ Runner
   │  │  │  │  │  │  │  ├─ AppDelegate.swift
   │  │  │  │  │  │  │  ├─ Assets.xcassets
   │  │  │  │  │  │  │  │  └─ AppIcon.appiconset
   │  │  │  │  │  │  │  │     ├─ app_icon_1024.png
   │  │  │  │  │  │  │  │     ├─ app_icon_128.png
   │  │  │  │  │  │  │  │     ├─ app_icon_16.png
   │  │  │  │  │  │  │  │     ├─ app_icon_256.png
   │  │  │  │  │  │  │  │     ├─ app_icon_32.png
   │  │  │  │  │  │  │  │     ├─ app_icon_512.png
   │  │  │  │  │  │  │  │     ├─ app_icon_64.png
   │  │  │  │  │  │  │  │     └─ Contents.json
   │  │  │  │  │  │  │  ├─ Base.lproj
   │  │  │  │  │  │  │  │  └─ MainMenu.xib
   │  │  │  │  │  │  │  ├─ Configs
   │  │  │  │  │  │  │  │  ├─ AppInfo.xcconfig
   │  │  │  │  │  │  │  │  ├─ Debug.xcconfig
   │  │  │  │  │  │  │  │  ├─ Release.xcconfig
   │  │  │  │  │  │  │  │  └─ Warnings.xcconfig
   │  │  │  │  │  │  │  ├─ DebugProfile.entitlements
   │  │  │  │  │  │  │  ├─ Info.plist
   │  │  │  │  │  │  │  ├─ MainFlutterWindow.swift
   │  │  │  │  │  │  │  └─ Release.entitlements
   │  │  │  │  │  │  ├─ Runner.xcodeproj
   │  │  │  │  │  │  │  ├─ project.pbxproj
   │  │  │  │  │  │  │  ├─ project.xcworkspace
   │  │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ xcschemes
   │  │  │  │  │  │  │        └─ Runner.xcscheme
   │  │  │  │  │  │  ├─ Runner.xcworkspace
   │  │  │  │  │  │  │  ├─ contents.xcworkspacedata
   │  │  │  │  │  │  │  └─ xcshareddata
   │  │  │  │  │  │  │     └─ IDEWorkspaceChecks.plist
   │  │  │  │  │  │  └─ RunnerTests
   │  │  │  │  │  │     └─ RunnerTests.swift
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ pubspec_overrides.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  ├─ web
   │  │  │  │  │  │  ├─ favicon.png
   │  │  │  │  │  │  ├─ icons
   │  │  │  │  │  │  │  ├─ Icon-192.png
   │  │  │  │  │  │  │  ├─ Icon-512.png
   │  │  │  │  │  │  │  ├─ Icon-maskable-192.png
   │  │  │  │  │  │  │  └─ Icon-maskable-512.png
   │  │  │  │  │  │  ├─ index.html
   │  │  │  │  │  │  └─ manifest.json
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  └─ CMakeLists.txt
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ run_loop.cpp
   │  │  │  │  │        ├─ run_loop.h
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ ios
   │  │  │  │  │  ├─ Classes
   │  │  │  │  │  │  ├─ ConnectivityPlusPlugin.h
   │  │  │  │  │  │  ├─ ConnectivityPlusPlugin.m
   │  │  │  │  │  │  ├─ ConnectivityProvider.swift
   │  │  │  │  │  │  ├─ PathMonitorConnectivityProvider.swift
   │  │  │  │  │  │  ├─ ReachabilityConnectivityProvider.swift
   │  │  │  │  │  │  └─ SwiftConnectivityPlusPlugin.swift
   │  │  │  │  │  └─ connectivity_plus.podspec
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ connectivity_plus.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ connectivity_plus_linux.dart
   │  │  │  │  │     ├─ connectivity_plus_web.dart
   │  │  │  │  │     └─ web
   │  │  │  │  │        ├─ dart_html_connectivity_plugin.dart
   │  │  │  │  │        ├─ network_information_api_connectivity_plugin.dart
   │  │  │  │  │        └─ utils
   │  │  │  │  │           └─ connectivity_result.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ macos
   │  │  │  │  │  ├─ Classes
   │  │  │  │  │  │  ├─ ConnectivityPlugin.swift
   │  │  │  │  │  │  ├─ ConnectivityProvider.swift
   │  │  │  │  │  │  ├─ PathMonitorConnectivityProvider.swift
   │  │  │  │  │  │  └─ ReachabilityConnectivityProvider.swift
   │  │  │  │  │  └─ connectivity_plus.podspec
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  ├─ connectivity_plus_linux_test.dart
   │  │  │  │  │  ├─ connectivity_plus_linux_test.mocks.dart
   │  │  │  │  │  └─ connectivity_test.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ connectivity_plus_plugin.cpp
   │  │  │  │     ├─ include
   │  │  │  │     │  └─ connectivity_plus
   │  │  │  │     │     ├─ connectivity_plus_windows_plugin.h
   │  │  │  │     │     └─ network_manager.h
   │  │  │  │     └─ network_manager.cpp
   │  │  │  ├─ file_selector_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  ├─ get_directory_page.dart
   │  │  │  │  │  │  ├─ get_multiple_directories_page.dart
   │  │  │  │  │  │  ├─ home_page.dart
   │  │  │  │  │  │  ├─ main.dart
   │  │  │  │  │  │  ├─ open_image_page.dart
   │  │  │  │  │  │  ├─ open_multiple_images_page.dart
   │  │  │  │  │  │  ├─ open_text_page.dart
   │  │  │  │  │  │  └─ save_text_page.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ file_selector_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     └─ messages.g.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pigeons
   │  │  │  │  │  ├─ copyright.txt
   │  │  │  │  │  └─ messages.dart
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  ├─ file_selector_windows_test.dart
   │  │  │  │  │  ├─ file_selector_windows_test.mocks.dart
   │  │  │  │  │  └─ test_api.g.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ file_dialog_controller.cpp
   │  │  │  │     ├─ file_dialog_controller.h
   │  │  │  │     ├─ file_selector_plugin.cpp
   │  │  │  │     ├─ file_selector_plugin.h
   │  │  │  │     ├─ file_selector_windows.cpp
   │  │  │  │     ├─ include
   │  │  │  │     │  └─ file_selector_windows
   │  │  │  │     │     └─ file_selector_windows.h
   │  │  │  │     ├─ messages.g.cpp
   │  │  │  │     ├─ messages.g.h
   │  │  │  │     ├─ string_utils.cpp
   │  │  │  │     ├─ string_utils.h
   │  │  │  │     └─ test
   │  │  │  │        ├─ file_selector_plugin_test.cpp
   │  │  │  │        ├─ test_file_dialog_controller.cpp
   │  │  │  │        ├─ test_file_dialog_controller.h
   │  │  │  │        ├─ test_main.cpp
   │  │  │  │        ├─ test_utils.cpp
   │  │  │  │        └─ test_utils.h
   │  │  │  ├─ flutter_secure_storage_windows
   │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ analysis_options.yaml
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ app_test.dart
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  ├─ generated_plugins.cmake
   │  │  │  │  │     │  ├─ generated_plugin_registrant.cc
   │  │  │  │  │     │  └─ generated_plugin_registrant.h
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ flutter_secure_storage_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ flutter_secure_storage_windows_ffi.dart
   │  │  │  │  │     └─ flutter_secure_storage_windows_stub.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  ├─ test
   │  │  │  │  │  └─ unit_test.dart
   │  │  │  │  └─ windows
   │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │     ├─ flutter_secure_storage_windows_plugin.cpp
   │  │  │  │     └─ include
   │  │  │  │        └─ flutter_secure_storage_windows
   │  │  │  │           └─ flutter_secure_storage_windows_plugin.h
   │  │  │  ├─ image_picker_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  └─ image_picker_windows.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  └─ test
   │  │  │  │     ├─ image_picker_windows_test.dart
   │  │  │  │     └─ image_picker_windows_test.mocks.dart
   │  │  │  ├─ path_provider_windows
   │  │  │  │  ├─ AUTHORS
   │  │  │  │  ├─ CHANGELOG.md
   │  │  │  │  ├─ example
   │  │  │  │  │  ├─ integration_test
   │  │  │  │  │  │  └─ path_provider_test.dart
   │  │  │  │  │  ├─ lib
   │  │  │  │  │  │  └─ main.dart
   │  │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  │  ├─ README.md
   │  │  │  │  │  ├─ test_driver
   │  │  │  │  │  │  └─ integration_test.dart
   │  │  │  │  │  └─ windows
   │  │  │  │  │     ├─ CMakeLists.txt
   │  │  │  │  │     ├─ flutter
   │  │  │  │  │     │  ├─ CMakeLists.txt
   │  │  │  │  │     │  └─ generated_plugins.cmake
   │  │  │  │  │     └─ runner
   │  │  │  │  │        ├─ CMakeLists.txt
   │  │  │  │  │        ├─ flutter_window.cpp
   │  │  │  │  │        ├─ flutter_window.h
   │  │  │  │  │        ├─ main.cpp
   │  │  │  │  │        ├─ resource.h
   │  │  │  │  │        ├─ resources
   │  │  │  │  │        │  └─ app_icon.ico
   │  │  │  │  │        ├─ runner.exe.manifest
   │  │  │  │  │        ├─ Runner.rc
   │  │  │  │  │        ├─ run_loop.cpp
   │  │  │  │  │        ├─ run_loop.h
   │  │  │  │  │        ├─ utils.cpp
   │  │  │  │  │        ├─ utils.h
   │  │  │  │  │        ├─ win32_window.cpp
   │  │  │  │  │        └─ win32_window.h
   │  │  │  │  ├─ lib
   │  │  │  │  │  ├─ path_provider_windows.dart
   │  │  │  │  │  └─ src
   │  │  │  │  │     ├─ folders.dart
   │  │  │  │  │     ├─ folders_stub.dart
   │  │  │  │  │     ├─ path_provider_windows_real.dart
   │  │  │  │  │     └─ path_provider_windows_stub.dart
   │  │  │  │  ├─ LICENSE
   │  │  │  │  ├─ pubspec.yaml
   │  │  │  │  ├─ README.md
   │  │  │  │  └─ test
   │  │  │  │     └─ path_provider_windows_test.dart
   │  │  │  └─ permission_handler_windows
   │  │  │     ├─ AUTHORS
   │  │  │     ├─ CHANGELOG.md
   │  │  │     ├─ example
   │  │  │     │  ├─ lib
   │  │  │     │  │  └─ main.dart
   │  │  │     │  ├─ pubspec.yaml
   │  │  │     │  ├─ README.md
   │  │  │     │  ├─ res
   │  │  │     │  │  └─ images
   │  │  │     │  │     ├─ baseflow_logo_def_light-02.png
   │  │  │     │  │     ├─ poweredByBaseflowLogoLight.png
   │  │  │     │  │     ├─ poweredByBaseflowLogoLight@2x.png
   │  │  │     │  │     └─ poweredByBaseflowLogoLight@3x.png
   │  │  │     │  └─ windows
   │  │  │     │     ├─ CMakeLists.txt
   │  │  │     │     ├─ flutter
   │  │  │     │     │  ├─ CMakeLists.txt
   │  │  │     │     │  ├─ generated_plugins.cmake
   │  │  │     │     │  ├─ generated_plugin_registrant.cc
   │  │  │     │     │  └─ generated_plugin_registrant.h
   │  │  │     │     └─ runner
   │  │  │     │        ├─ CMakeLists.txt
   │  │  │     │        ├─ flutter_window.cpp
   │  │  │     │        ├─ flutter_window.h
   │  │  │     │        ├─ main.cpp
   │  │  │     │        ├─ resource.h
   │  │  │     │        ├─ resources
   │  │  │     │        │  └─ app_icon.ico
   │  │  │     │        ├─ runner.exe.manifest
   │  │  │     │        ├─ Runner.rc
   │  │  │     │        ├─ utils.cpp
   │  │  │     │        ├─ utils.h
   │  │  │     │        ├─ win32_window.cpp
   │  │  │     │        └─ win32_window.h
   │  │  │     ├─ LICENSE
   │  │  │     ├─ pubspec.yaml
   │  │  │     ├─ README.md
   │  │  │     └─ windows
   │  │  │        ├─ CMakeLists.txt
   │  │  │        ├─ include
   │  │  │        │  └─ permission_handler_windows
   │  │  │        │     └─ permission_handler_windows_plugin.h
   │  │  │        ├─ permission_constants.h
   │  │  │        └─ permission_handler_windows_plugin.cpp
   │  │  ├─ cpp_client_wrapper
   │  │  │  ├─ binary_messenger_impl.h
   │  │  │  ├─ byte_buffer_streams.h
   │  │  │  ├─ core_implementations.cc
   │  │  │  ├─ engine_method_result.cc
   │  │  │  ├─ flutter_engine.cc
   │  │  │  ├─ flutter_view_controller.cc
   │  │  │  ├─ include
   │  │  │  │  └─ flutter
   │  │  │  │     ├─ basic_message_channel.h
   │  │  │  │     ├─ binary_messenger.h
   │  │  │  │     ├─ byte_streams.h
   │  │  │  │     ├─ dart_project.h
   │  │  │  │     ├─ encodable_value.h
   │  │  │  │     ├─ engine_method_result.h
   │  │  │  │     ├─ event_channel.h
   │  │  │  │     ├─ event_sink.h
   │  │  │  │     ├─ event_stream_handler.h
   │  │  │  │     ├─ event_stream_handler_functions.h
   │  │  │  │     ├─ flutter_engine.h
   │  │  │  │     ├─ flutter_view.h
   │  │  │  │     ├─ flutter_view_controller.h
   │  │  │  │     ├─ message_codec.h
   │  │  │  │     ├─ method_call.h
   │  │  │  │     ├─ method_channel.h
   │  │  │  │     ├─ method_codec.h
   │  │  │  │     ├─ method_result.h
   │  │  │  │     ├─ method_result_functions.h
   │  │  │  │     ├─ plugin_registrar.h
   │  │  │  │     ├─ plugin_registrar_windows.h
   │  │  │  │     ├─ plugin_registry.h
   │  │  │  │     ├─ standard_codec_serializer.h
   │  │  │  │     ├─ standard_message_codec.h
   │  │  │  │     ├─ standard_method_codec.h
   │  │  │  │     └─ texture_registrar.h
   │  │  │  ├─ plugin_registrar.cc
   │  │  │  ├─ readme
   │  │  │  ├─ standard_codec.cc
   │  │  │  └─ texture_registrar_impl.h
   │  │  ├─ flutter_export.h
   │  │  ├─ flutter_messenger.h
   │  │  ├─ flutter_plugin_registrar.h
   │  │  ├─ flutter_texture_registrar.h
   │  │  ├─ flutter_windows.dll
   │  │  ├─ flutter_windows.dll.exp
   │  │  ├─ flutter_windows.dll.lib
   │  │  ├─ flutter_windows.dll.pdb
   │  │  ├─ flutter_windows.h
   │  │  ├─ generated_config.cmake
   │  │  └─ icudtl.dat
   │  ├─ generated_plugins.cmake
   │  ├─ generated_plugin_registrant.cc
   │  └─ generated_plugin_registrant.h
   └─ runner
      ├─ CMakeLists.txt
      ├─ flutter_window.cpp
      ├─ flutter_window.h
      ├─ main.cpp
      ├─ resource.h
      ├─ resources
      │  └─ app_icon.ico
      ├─ runner.exe.manifest
      ├─ Runner.rc
      ├─ utils.cpp
      ├─ utils.h
      ├─ win32_window.cpp
      └─ win32_window.h

```
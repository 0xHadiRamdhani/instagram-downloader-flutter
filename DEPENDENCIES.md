# Instagram Downloader - Dependencies Configuration

## Core Dependencies Configuration

### pubspec.yaml Updates

```yaml
name: instagram_downloader
description: "A powerful Instagram media downloader with auto-detection and background download support"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.9.2

dependencies:
  flutter:
    sdk: flutter

  # UI & Theming
  cupertino_icons: ^1.0.8
  flutter_svg: ^2.0.9
  
  # State Management
  provider: ^6.1.2
  
  # Networking & API
  dio: ^5.4.0
  http: ^1.2.1
  
  # Storage & Permissions
  path_provider: ^2.1.3
  permission_handler: ^11.3.1
  shared_preferences: ^2.2.3
  
  # Download Management
  flutter_downloader: ^1.11.7
  
  # Media Handling
  image_picker: ^1.0.8
  video_player: ^2.8.3
  cached_network_image: ^3.4.1
  
  # Clipboard
  clipboard: ^0.1.3
  
  # Gallery
  photo_gallery: ^2.0.2
  
  # URL Launcher
  url_launcher: ^6.2.5
  
  # JSON Parsing
  json_annotation: ^4.9.0
  
  # Logger
  logger: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  
  # Assets
  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
  
  # Fonts
  fonts:
    - family: InstagramSans
      fonts:
        - asset: fonts/InstagramSans-Regular.ttf
        - asset: fonts/InstagramSans-Bold.ttf
          weight: 700
        - asset: fonts/InstagramSans-Light.ttf
          weight: 300
```

## Android Configuration (android/app/src/main/AndroidManifest.xml)

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.instagram_downloader">

    <!-- Internet Permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <!-- Storage Permissions -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <!-- For Android 13+ -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
    
    <!-- Background Download -->
    <uses-permission android:name="android.permission.DOWNLOAD_WITHOUT_NOTIFICATION" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />

    <application
        android:label="Instagram Downloader"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:requestLegacyExternalStorage="true"
        android:largeHeap="true">
        
        <!-- Download Service -->
        <provider
            android:name="vn.hunghd.flutterdownloader.DownloadedFileProvider"
            android:authorities="${applicationId}.flutter_downloader.provider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/provider_paths"/>
        </provider>
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
                android:name="io.flutter.embedding.android.NormalTheme"
                android:resource="@style/NormalTheme" />
                
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
            
            <!-- Deep Link Support -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data android:scheme="https" android:host="instagram.com" />
                <data android:scheme="https" android:host="www.instagram.com" />
            </intent-filter>
        </activity>
        
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

## iOS Configuration (ios/Runner/Info.plist)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Basic Configuration -->
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>Instagram Downloader</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleName</key>
    <string>instagram_downloader</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    
    <!-- Permissions -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs access to photo library to save downloaded Instagram media</string>
    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>This app needs access to save downloaded Instagram media to your photo library</string>
    
    <!-- Network Configuration -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSAllowsArbitraryLoadsInWebContent</key>
        <true/>
        <key>NSAllowsLocalNetworking</key>
        <true/>
    </dict>
    
    <!-- Background Modes -->
    <key>UIBackgroundModes</key>
    <array>
        <string>fetch</string>
        <string>processing</string>
    </array>
    
    <!-- Supported Interface Orientations -->
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    
    <!-- Minimum OS Version -->
    <key>MinimumOSVersion</key>
    <string>11.0</string>
</dict>
</plist>
```

## Core Services Implementation

### 1. Navigation Service (lib/core/services/navigation_service.dart)

```dart
import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> replaceWith(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    return navigatorKey.currentState!.pop();
  }

  static void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }
}
```

### 2. Storage Service (lib/core/services/storage_service.dart)

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<bool> setObject(String key, dynamic value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  static dynamic getObject(String key) {
    final String? data = _prefs.getString(key);
    return data != null ? jsonDecode(data) : null;
  }

  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }
}
```

### 3. Clipboard Service (lib/shared/services/clipboard_service.dart)

```dart
import 'package:clipboard/clipboard.dart';

class ClipboardService {
  static Future<String> getClipboardText() async {
    return await FlutterClipboard.paste();
  }

  static Future<void> copyToClipboard(String text) async {
    await FlutterClipboard.copy(text);
  }

  static bool isInstagramUrl(String text) {
    final instagramRegex = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?instagram\.com\/(p|reel|tv|stories)\/([a-zA-Z0-9_-]+)',
      caseSensitive: false,
    );
    return instagramRegex.hasMatch(text);
  }

  static String? extractInstagramPostId(String url) {
    final instagramRegex = RegExp(
      r'instagram\.com\/(?:p|reel|tv|stories)\/([a-zA-Z0-9_-]+)',
      caseSensitive: false,
    );
    final match = instagramRegex.firstMatch(url);
    return match?.group(1);
  }
}
```

## Setup Instructions

### 1. Add Dependencies
```bash
flutter pub add cupertino_icons flutter_svg provider dio http path_provider permission_handler shared_preferences flutter_downloader image_picker video_player cached_network_image clipboard photo_gallery url_launcher json_annotation logger
```

### 2. Configure Platforms
- Update AndroidManifest.xml with permissions
- Update Info.plist for iOS permissions
- Configure platform-specific settings

### 3. Initialize Services
Update main.dart to initialize core services:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await StorageService.init();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  
  runApp(MyApp());
}
```

### 4. Create Directory Structure
Run these commands to create the folder structure:
```bash
mkdir -p lib/{core/{constants,themes,utils,services},features/{home,download,gallery,history,settings}/{data/{models,repositories},domain/{entities,usecases},presentation/{providers,screens,widgets}},shared/{widgets,services},assets/{images,icons,animations},fonts}
```

## Next Steps
1. Implement the folder structure
2. Create base models and entities
3. Implement core services
4. Build UI screens
5. Integrate download functionality
6. Add testing
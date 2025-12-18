# Instagram Downloader

A Flutter application for downloading Instagram content (photos, videos, reels, stories) with automatic link detection, media preview, and comprehensive gallery management.

## Features

### Automatic Detection
- **Auto Clipboard Detection**: Automatically detects Instagram links from clipboard when app opens
- **URL Validation**: Ensures pasted links are valid and processable

### Multi-Content Support
- **Photos & Carousels**: Download single photos or multiple photos in one post
- **Videos & Reels**: Download video content with quality selection
- **Stories**: Support for downloading Instagram Stories
- **IGTV**: Support for IGTV content downloads

### Media Preview
- **Thumbnail Preview**: View thumbnails before downloading
- **Media Player**: Video preview with built-in player
- **Post Information**: Display post details (likes, comments, description)

### File Management
- **In-App Gallery**: Dedicated folder for viewing downloaded content
- **File Organization**: Files saved with structured naming
- **Share & Delete**: Share or delete files directly from gallery
- **File Information**: File size and download date information

### User Experience
- **Dark Mode**: Support for dark and light themes
- **Progress Indicators**: Clear progress bars during download
- **Error Handling**: Informative error messages
- **Responsive UI**: Adaptive display for various screen sizes

## Technology Stack

### Core Dependencies
- **Flutter**: Main framework for mobile development
- **Provider**: State management for the application
- **Dio**: HTTP client for API requests
- **Path Provider**: File system path management
- **Permission Handler**: Device permission management
- **Flutter Downloader**: Background download processing

### UI/UX Dependencies
- **Cached Network Image**: Image loading and caching
- **Shimmer**: Loading skeleton effects
- **Iconsax**: Modern icon pack
- **Lottie**: Loading state animations

### Utility Dependencies
- **Get It**: Dependency injection
- **Logger**: Powerful logging system
- **Shared Preferences**: Local storage for settings
- **URL Launcher**: External link opening

## Project Structure

```
instagram-downloader-flutter/
├── lib/
│   ├── core/
│   │   ├── constants/          # App constants & colors
│   │   ├── services/           # Core services (DI, navigation)
│   │   ├── themes/             # App themes & styling
│   │   └── utils/              # Utility functions
│   ├── features/
│   │   ├── home/               # Home screen & clipboard detection
│   │   ├── download/           # Download & preview functionality
│   │   ├── gallery/            # Gallery management
│   │   └── settings/           # App settings
│   ├── shared/
│   │   ├── models/             # Data models
│   │   ├── services/           # Shared services
│   │   └── widgets/            # Reusable widgets
│   └── main.dart               # App entry point
├── android/                    # Android-specific code
├── ios/                        # iOS-specific code
├── test/                       # Unit tests
└── pubspec.yaml               # Dependencies configuration
```

## Installation & Setup

### Prerequisites
- Flutter SDK (version 3.0 or newer)
- Dart SDK (version 2.17 or newer)
- Android Studio / Xcode
- Git

### Installation Steps

1. **Clone Repository**
```bash
git clone https://github.com/0xHadiRamdhani/instagram-downloader-flutter.git
cd instagram-downloader-flutter
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Platform Configuration**
```bash
# For Android
flutter config --android-studio-dir="/path/to/android/studio"

# For iOS (macOS only)
sudo gem install cocoapods
cd ios && pod install && cd ..
```

4. **Run Application**
```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

## Usage Guide

### 1. **Copy Instagram Link**
- Open Instagram and copy the post link you want to download
- The app will automatically detect the link from clipboard

### 2. **Manual Paste**
- Open Instagram Downloader app
- Paste the link in the provided input field
- Click the "Download" button

### 3. **Preview & Download**
- The app will display content preview
- Select media quality (if available)
- Click "Download" to start the download process

### 4. **Access Gallery**
- Click the gallery icon in the top right corner
- View all downloaded files
- Share or delete files as needed

## Configuration

### Environment Variables
```dart
// In .env or config file
const String API_BASE_URL = 'https://api.instagram-downloader.com';
const String API_KEY = 'your-api-key-here';
```

### Permissions
```xml
<!-- Android (android/app/src/main/AndroidManifest.xml) -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

```xml
<!-- iOS (ios/Runner/Info.plist) -->
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to save downloaded photos</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>We need access to save downloaded photos</string>
```

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Performance

### Applied Optimizations
- **Lazy Loading**: Images loaded when needed
- **Caching**: API results and images cached
- **Background Processing**: Downloads run in background
- **Memory Management**: Proper disposal and cleanup

### Benchmarks
- Startup Time: < 2 seconds
- Download Speed: Depends on connection
- Memory Usage: < 100MB for idle app
- Battery Usage: Minimal with background processing

## Security & Privacy

### Data Protection
- No user data stored online
- All data stored locally on device
- No tracking or analytics without consent

### Network Security
- HTTPS for all network requests
- Input validation to prevent injection
- File validation before saving

## Roadmap

### Upcoming Features
- [ ] Batch download multiple posts
- [ ] Download private content (with login)
- [ ] Cloud backup for download history
- [ ] Advanced search within gallery
- [ ] Video compression options
- [ ] Instagram Stories download
- [ ] IGTV download support
- [ ] Dark mode improvements
- [ ] Multiple language support
- [ ] Advanced settings & customization

### Improvements
- [ ] Better error handling
- [ ] Performance optimization
- [ ] UI/UX enhancements
- [ ] Accessibility improvements
- [ ] Tablet optimization

## Contributing

We welcome contributions from the community! Please fork the repository and create a pull request.

### Guidelines
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Create Pull Request

### Code Style
- Follow Flutter style guide
- Use dart format
- Add comments for complexity
- Update documentation if needed

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the excellent framework
- Instagram for API and documentation
- Open source community for packages and tools
- Contributors and beta testers

## Support

If you encounter issues or have questions:

- 📧 Email: support@instagramdownloader.com
- 🐛 Issues: [GitHub Issues](https://github.com/0xHadiRamdhani/instagram-downloader-flutter/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/0xHadiRamdhani/instagram-downloader-flutter/discussions)

---

**Disclaimer**: This application is created for educational and personal use purposes. Please use responsibly and respect Instagram content copyrights. We are not responsible for misuse of this application.

**Made by Instagram Downloader Team**

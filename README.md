# Instagram Downloader 🚀

Aplikasi Flutter untuk mengunduh konten Instagram (foto, video, reels, stories) dengan fitur deteksi link otomatis, preview media, dan manajemen galeri yang powerful.

## 📱 Fitur Utama

### 🔍 Deteksi Otomatis
- **Auto Clipboard Detection**: Mendeteksi link Instagram secara otomatis saat aplikasi dibuka
- **Validasi URL**: Memastikan link yang ditempel valid dan dapat diproses

### 📸 Multi-Content Support
- **Foto & Carousel**: Mengunduh single foto atau multiple foto dalam satu postingan
- **Video & Reels**: Mengunduh video content dengan kualitas pilihan
- **Stories**: Support untuk mengunduh Instagram Stories
- **IGTV**: Support untuk konten IGTV

### 👁️ Preview Media
- **Thumbnail Preview**: Melihat thumbnail sebelum mengunduh
- **Media Player**: Preview video dengan pemutar built-in
- **Informasi Post**: Menampilkan detail postingan (likes, comments, deskripsi)

### 📁 Manajemen File
- **Galeri In-App**: Folder khusus untuk melihat hasil unduhan
- **Organisasi File**: File tersimpan dengan nama yang terstruktur
- **Share & Delete**: Berbagi atau menghapus file langsung dari galeri
- **File Info**: Informasi ukuran file dan tanggal unduhan

### 🎨 User Experience
- **Dark Mode**: Support tema gelap dan terang
- **Progress Indicators**: Progress bar yang jelas saat mengunduh
- **Error Handling**: Pesan error yang informatif
- **Responsive UI**: Tampilan yang adaptif untuk berbagai ukuran layar

## 🛠️ Teknologi yang Digunakan

### Core Dependencies
- **Flutter**: Framework utama untuk mobile development
- **Provider**: State management untuk aplikasi
- **Dio**: HTTP client untuk API requests
- **Path Provider**: Manajemen path file system
- **Permission Handler**: Manajemen izin perangkat
- **Flutter Downloader**: Background download processing

### UI/UX Dependencies
- **Cached Network Image**: Loading dan caching gambar
- **Shimmer**: Loading skeleton effects
- **Iconsax**: Icon pack yang modern
- **Lottie**: Animations untuk loading states

### Utility Dependencies
- **Get It**: Dependency injection
- **Logger**: Logging system yang powerful
- **Shared Preferences**: Local storage untuk settings
- **URL Launcher**: Membuka link eksternal

## 📁 Struktur Proyek

```
instagram_downloader/
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

## 🚀 Instalasi & Setup

### Prasyarat
- Flutter SDK (versi 3.0 atau lebih baru)
- Dart SDK (versi 2.17 atau lebih baru)
- Android Studio / Xcode
- Git

### Langkah Instalasi

1. **Clone Repository**
```bash
git clone https://github.com/yourusername/instagram_downloader.git
cd instagram_downloader
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Konfigurasi Platform**
```bash
# Untuk Android
flutter config --android-studio-dir="/path/to/android/studio"

# Untuk iOS (macOS only)
sudo gem install cocoapods
cd ios && pod install && cd ..
```

4. **Jalankan Aplikasi**
```bash
# Mode debug
flutter run

# Mode release
flutter run --release
```

## 📱 Cara Penggunaan

### 1. **Copy Link Instagram**
- Buka Instagram dan copy link postingan yang ingin diunduh
- Aplikasi akan otomatis mendeteksi link dari clipboard

### 2. **Paste Manual**
- Buka aplikasi Instagram Downloader
- Paste link di kolom input yang tersedia
- Klik tombol "Download"

### 3. **Preview & Download**
- Aplikasi akan menampilkan preview konten
- Pilih kualitas media (jika tersedia)
- Klik "Download" untuk memulai proses unduhan

### 4. **Akses Galeri**
- Klik ikon galeri di pojok kanan atas
- Lihat semua file yang telah diunduh
- Share atau delete file sesuai kebutuhan

## 🔧 Konfigurasi

### Environment Variables
```dart
// Di file .env atau config
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

## 🧪 Testing

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

## 📊 Performance

### Optimasi yang Diterapkan
- **Lazy Loading**: Gambar dimuat saat dibutuhkan
- **Caching**: Hasil API dan gambar di-cache
- **Background Processing**: Download berjalan di background
- **Memory Management**: Proper disposal dan cleanup

### Benchmark
- Startup Time: < 2 detik
- Download Speed: Bergantung pada koneksi
- Memory Usage: < 100MB untuk aplikasi idle
- Battery Usage: Minimal dengan background processing

## 🔒 Security & Privacy

### Data Protection
- Tidak menyimpan data pengguna secara online
- Semua data disimpan lokal di perangkat
- Tidak ada tracking atau analytics tanpa persetujuan

### Network Security
- HTTPS untuk semua network requests
- Input validation untuk mencegah injection
- File validation sebelum menyimpan

## 📋 Roadmap

### Fitur Mendatang
- [ ] Batch download multiple posts
- [ ] Download private content (dengan login)
- [ ] Cloud backup untuk history download
- [ ] Advanced search dalam galeri
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

## 🤝 Contributing

Kami menyambut kontribusi dari komunitas! Silakan fork repository dan buat pull request.

### Guidelines
1. Fork repository
2. Buat branch untuk fitur baru (`git checkout -b feature/amazing-feature`)
3. Commit perubahan (`git commit -m 'Add amazing feature'`)
4. Push ke branch (`git push origin feature/amazing-feature`)
5. Buat Pull Request

### Code Style
- Ikuti Flutter style guide
- Gunakan dart format
- Tambahkan komentar untuk kompleksitas
- Update dokumentasi jika perlu

## 📄 License

Proyek ini dilisensikan di bawah MIT License - lihat file [LICENSE](LICENSE) untuk detail.

## 🙏 Acknowledgments

- Flutter team untuk framework yang luar biasa
- Instagram untuk API dan dokumentasi
- Komunitas open source untuk packages dan tools
- Kontributor dan beta tester

## 📞 Support

Jika Anda menemui masalah atau memiliki pertanyaan:

- 📧 Email: support@instagramdownloader.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/instagram_downloader/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/yourusername/instagram_downloader/discussions)

---

**⚠️ Disclaimer**: Aplikasi ini dibuat untuk keperluan pendidikan dan personal use. Harap gunakan dengan bijak dan hormati hak cipta konten Instagram. Kami tidak bertanggung jawab atas penyalahgunaan aplikasi ini.

**Made with ❤️ by Instagram Downloader Team**

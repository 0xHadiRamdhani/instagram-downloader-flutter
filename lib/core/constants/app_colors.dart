import 'package:flutter/material.dart';

/// App colors following Instagram's design system
class AppColors {
  // Primary Instagram Colors
  static const Color primary = Color(0xFFE4405F); // Instagram Red
  static const Color secondary = Color(0xFF833AB4); // Instagram Purple
  static const Color accent = Color(0xFFF77737); // Instagram Orange
  static const Color tertiary = Color(0xFFFCAF45); // Instagram Yellow

  // Gradient Colors (Instagram Gradient)
  static const List<Color> instagramGradient = [
    Color(0xFFE4405F), // Red
    Color(0xFF833AB4), // Purple
    Color(0xFF405DE6), // Blue
  ];

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color darkBackground = Color(0xFF121212);
  static const Color surface = Colors.white;
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color card = Colors.white;
  static const Color darkCard = Color(0xFF2C2C2C);

  // Text Colors
  static const Color textPrimary = Color(0xFF262626);
  static const Color textSecondary = Color(0xFF8E8E8E);
  static const Color textTertiary = Color(0xFFC7C7C7);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkTextTertiary = Color(0xFF6B6B6B);

  // UI Colors
  static const Color border = Color(0xFFDBDBDB);
  static const Color darkBorder = Color(0xFF363636);
  static const Color divider = Color(0xFFEFEFEF);
  static const Color darkDivider = Color(0xFF363636);
  static const Color shadow = Color(0x1F000000);
  static const Color darkShadow = Color(0x3F000000);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Social Colors
  static const Color like = Color(0xFFED4956);
  static const Color comment = Color(0xFF0095F6);
  static const Color share = Color(0xFF8E8E8E);
  static const Color save = Color(0xFF8E8E8E);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF0095F6);
  static const Color buttonSecondary = Color(0xFFEFEFEF);
  static const Color buttonText = Colors.white;
  static const Color buttonTextSecondary = Color(0xFF262626);

  // Input Colors
  static const Color inputBackground = Color(0xFFFAFAFA);
  static const Color inputBorder = Color(0xFFDBDBDB);
  static const Color inputText = Color(0xFF262626);
  static const Color inputHint = Color(0xFF8E8E8E);

  // Story Colors
  static const Color storyBorder = Color(0xFF833AB4);
  static const Color storySeen = Color(0xFF8E8E8E);

  // Navigation Colors
  static const Color appBar = Colors.white;
  static const Color darkAppBar = Color(0xFF121212);
  static const Color bottomNav = Colors.white;
  static const Color darkBottomNav = Color(0xFF121212);

  // Overlay Colors
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);

  // Loading Colors
  static const Color loadingBackground = Color(0xFFF8F9FA);
  static const Color loadingIndicator = primary;

  // Notification Colors
  static const Color notificationBackground = Colors.white;
  static const Color notificationText = textPrimary;
  static const Color notificationTime = textSecondary;

  // Chat Colors
  static const Color chatSent = buttonPrimary;
  static const Color chatReceived = Color(0xFFEFEFEF);
  static const Color chatTextSent = Colors.white;
  static const Color chatTextReceived = textPrimary;

  // Highlight Colors
  static const Color highlight = Color(0xFF0095F6);
  static const Color highlightText = Colors.white;

  // Disabled Colors
  static const Color disabled = Color(0xFFDBDBDB);
  static const Color disabledText = Color(0xFF8E8E8E);

  // Transparent
  static const Color transparent = Colors.transparent;

  // White and Black
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  // Method to get color based on theme
  static Color getAdaptiveColor(
    BuildContext context,
    Color lightColor,
    Color darkColor,
  ) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkColor
        : lightColor;
  }

  // Method to get text color based on theme
  static Color getAdaptiveTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : textPrimary;
  }

  // Method to get background color based on theme
  static Color getAdaptiveBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : background;
  }

  // Method to get card color based on theme
  static Color getAdaptiveCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? darkCard : card;
  }
}

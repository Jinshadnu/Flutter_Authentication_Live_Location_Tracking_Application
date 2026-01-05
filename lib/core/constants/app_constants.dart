class AppConstants {
  // App
  static const String appName = 'MediTrack';

  // Assets
  static const String logoPath = 'assets/images/logo.png';
  static const String splashAnimation =
      'assets/animations/splash_animation.json';

  // Collections
  static const String usersCollection = 'users';
  static const String locationsCollection = 'locations';

  // Storage Keys
  static const String isLoggedIn = 'is_logged_in';
  static const String userEmail = 'user_email';

  // Messages
  static const String locationPermissionDenied =
      'Location permissions are denied';
  static const String locationPermissionDeniedForever =
      'Location permissions are permanently denied';
  static const String locationServiceDisabled =
      'Location services are disabled';
  static const String locationPermissionNeeded =
      'Location permissions are needed to show your current location';

  // Map
  static const double defaultLatitude =
      10.8505; // Default coordinates (Kochi, India)
  static const double defaultLongitude = 76.2711;
  static const double defaultZoom = 15.0;
}

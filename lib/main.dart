import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'screens/home.dart';
import 'screens/explore_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/add_trip_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/hotel_detail_screen.dart';
import 'screens/hotel_booking_screen.dart';
import 'screens/resort_details_screen.dart';
import 'auth_wrapper.dart';

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global error handling for synchronous Dart errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('FLUTTER ERROR: ${details.exception}');
    }
  };

  // Check if Firebase is already initialized to prevent duplicate app error
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: kIsWeb ? DefaultFirebaseOptions.currentPlatform : null,
      );
    }
  } catch (e) {
    if (kDebugMode) {
      print('FIREBASE INITIALIZATION ERROR: $e');
    }
    // Continue execution to see if the app can still render basic UI
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Agency',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        // Custom dark theme for date picker
        datePickerTheme: const DatePickerThemeData(
          backgroundColor: Color(0xFF1A2642),
          headerBackgroundColor: Color(0xFF0A1628),
          headerForegroundColor: Colors.white,
          dayForegroundColor: WidgetStatePropertyAll(Colors.white),
          yearForegroundColor: WidgetStatePropertyAll(Colors.white),
        ),
      ),
      home: const AuthWrapper(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/explore': (context) => const ExploreScreen(),
        '/saved': (context) => const SavedScreen(),
        '/add-trip': (context) => const AddTripScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/hotel-detail': (context) => const HotelDetailScreen(
          hotelName: 'Star Pacific Sylhet',
          location: 'Sylhet, Bangladesh',
          rating: 4.8,
          reviews: 156,
        ),
        '/hotel-booking': (context) => const HotelBookingScreen(),
        '/resort-details': (context) => const ResortDetailsScreen(
          resortName: 'Cox\'s Bazar Beach',
          location: 'Bangladesh',
          imageUrl:
              'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800',
          rating: 4.8,
        ),
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
    );
  }
}

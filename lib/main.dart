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

void main() {
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
      home: const SplashScreen(),
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
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
    );
  }
}

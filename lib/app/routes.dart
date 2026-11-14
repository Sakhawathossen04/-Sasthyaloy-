import 'package:flutter/material.dart';
import '../features/onboarding/presentation/screens/splash_screen.dart';
import '../features/onboarding/presentation/screens/language_selection_screen.dart';
import '../features/onboarding/presentation/screens/location_permission_screen.dart';
import '../features/onboarding/presentation/screens/onboarding_carousel_screen.dart';
import '../features/navigation/presentation/screens/main_shell_screen.dart';
import '../features/doctors/presentation/screens/speciality_search_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String language = '/language';
  static const String location = '/location';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String specialitySearch = '/speciality-search';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case language:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case location:
        return MaterialPageRoute(builder: (_) => const LocationPermissionScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingCarouselScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const MainShellScreen());
      case specialitySearch:
        return MaterialPageRoute(builder: (_) => const SpecialitySearchScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}

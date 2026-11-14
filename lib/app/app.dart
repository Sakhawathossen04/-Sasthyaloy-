import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/constants/app_strings.dart';
import '../core/localization/app_locale_controller.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';

class SasthyaloyApp extends StatefulWidget {
  const SasthyaloyApp({super.key});

  @override
  State<SasthyaloyApp> createState() => _SasthyaloyAppState();
}

class _SasthyaloyAppState extends State<SasthyaloyApp> {
  @override
  void initState() {
    super.initState();
    AppLocaleController.instance.addListener(_onLocaleChanged);
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AppLocaleController.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = AppLocaleController.instance.locale;

    return MaterialApp(
      title: AppStrings.appNameBn,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: currentLocale,
      supportedLocales: const [
        Locale('bn', 'BD'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}

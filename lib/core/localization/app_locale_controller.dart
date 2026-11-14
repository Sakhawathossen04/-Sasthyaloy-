import 'package:flutter/material.dart';

class AppLocaleController extends ChangeNotifier {
  static final AppLocaleController instance = AppLocaleController._internal();
  AppLocaleController._internal();

  Locale _locale = const Locale('bn');

  Locale get locale => _locale;
  bool get isBangla => _locale.languageCode == 'bn';

  void setLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    if (isBangla) {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('bn'));
    }
  }
}

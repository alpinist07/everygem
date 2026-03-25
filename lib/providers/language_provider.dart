import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _langKey = 'app_language';
  String _locale = 'ko'; // 기본값: 한국어

  LanguageProvider() {
    _loadLanguage();
  }

  String get locale => _locale;
  bool get isKorean => _locale == 'ko';
  bool get isEnglish => _locale == 'en';

  AppLocalizations get l10n => AppLocalizations(_locale);

  /// 번역 문자열 가져오기
  String tr(String key) => l10n.get(key);

  /// 템플릿 문자열 가져오기 (변수 치환)
  String trWith(String key, Map<String, String> params) {
    var result = l10n.get(key);
    params.forEach((k, v) {
      result = result.replaceAll('{$k}', v);
    });
    return result;
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _locale = prefs.getString(_langKey) ?? 'ko';
    notifyListeners();
  }

  Future<void> setLanguage(String locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, locale);
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    await setLanguage(_locale == 'ko' ? 'en' : 'ko');
  }
}

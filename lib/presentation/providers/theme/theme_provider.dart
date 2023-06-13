import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fullfit_app/config/config.dart';

//provider de tipo AppTheme
final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void updateTheme(AppTheme theme) {
    state = theme;
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}

import 'package:flutter/material.dart';

/// Provider para gerenciar o tema da aplicação
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark; // Inicia em dark mode

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Alterna entre dark e light mode
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    // TODO: Persistir preferência
  }

  /// Define o tema diretamente
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    // TODO: Persistir preferência
  }

  /// Define dark mode
  void setDarkMode(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    // TODO: Persistir preferência
  }
}

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  Color _color;

  ThemeProvider(this._themeData, this._color);

  ThemeData get themeData => _themeData;
  Color get color => _color;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void setColor(Color color) {
    _color = color;
    notifyListeners();
  }
}

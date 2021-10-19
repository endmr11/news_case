import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class ThemeColorData with ChangeNotifier {
  static SharedPreferences? _sharedPrefObj;

  /*ThemeData light = ThemeData(
    colorScheme: const ColorScheme(
        primary: Colors.blue,
        primaryVariant: Colors.red,
        secondary: Colors.yellow,
        secondaryVariant: Colors.black,
        surface: Colors.blue,
        background: Colors.purple,
        error: Colors.pink,
        onPrimary: Colors.white,
        onSecondary: Colors.blueGrey,
        onSurface: Colors.lightBlue,
        onBackground: Colors.green,
        onError: Colors.teal,
        brightness: Brightness.light),
  );

  ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.deepPurple,
    primaryColorLight: Colors.white,
    hintColor: Colors.white,
    primaryColorDark: Colors.white,
  );*/

  ThemeData light = FlexColorScheme.light(scheme: FlexScheme.mandyRed).toTheme;
  ThemeData dark = FlexColorScheme.dark(scheme: FlexScheme.mandyRed).toTheme;
  bool _isThemeLight = true;

//GETTER
  bool get isLight => _isThemeLight;
//GETTER
  ThemeData get getThemeColor {
    return _isThemeLight ? light : dark;
  }

//SETTER
  void changeTheme() {
    _isThemeLight = !_isThemeLight;
    saveThemeSharedPref(_isThemeLight);
    notifyListeners();
  }

  Future<void> createSharedPrefObj() async {
    _sharedPrefObj = await SharedPreferences.getInstance();
  }

  void saveThemeSharedPref(bool val) {
    _sharedPrefObj?.setBool('themeColorData', val);
  }

  Future<void> loadThemeSharedPref() async {
    //await createSharedPrefObject();
    _isThemeLight = _sharedPrefObj?.getBool('themeColorData') ?? true;
  }
}

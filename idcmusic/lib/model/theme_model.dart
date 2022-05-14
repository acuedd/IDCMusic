import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/ui/helper/theme_helper.dart';
import 'package:church_of_christ/config/storage_manager.dart';

class ThemeModel with ChangeNotifier{
  static const kThemeColorIndex = 'kThemeColorIndex';
  static const kThemeUserDarkMode = 'kThemeUserDarkMode';
  static const kFontIndex = 'kFontIndex';

  static const fontValueList = ['system', 'kuaile'];

  bool _userDarkMode;

  MaterialColor _themeColor;

  int _fontIndex;

  ThemeModel(){
    _userDarkMode = StorageManager.sharedPreferences.getBool(kThemeUserDarkMode) ?? false;

    _themeColor = Colors.primaries[
      StorageManager.sharedPreferences.getInt(kThemeColorIndex) ?? 5
    ];

    _fontIndex = StorageManager.sharedPreferences.getInt(kFontIndex) ?? 0;
  }

  int get fontIndex => _fontIndex;

  void switchTheme({ bool useDarkMode, MaterialColor color}){
    _userDarkMode = useDarkMode ?? _userDarkMode;
    _themeColor = color ?? _themeColor;
    debugPrint('color --> ${_themeColor}');
    notifyListeners();
    saveTheme2Storage(_userDarkMode, _themeColor);
  }

  void switchRandomTheme({ Brightness brightness }){
    int colorIndex = Random().nextInt(Colors.primaries.length -1);
    switchTheme(
      useDarkMode: Random().nextBool(),
      color: Colors.primaries[colorIndex],
    );
  }

  switchFont(int index){
    _fontIndex = index;
    switchTheme();
    saveFontIndex(index);
  }

  saveTheme2Storage(bool userDarkMode, MaterialColor themeColor) async {
    var index = Colors.primaries.indexOf(themeColor);
    await Future.wait([
      StorageManager.sharedPreferences.setBool(kThemeUserDarkMode, userDarkMode), 
      StorageManager.sharedPreferences.setInt(kThemeColorIndex, index),
    ]);
  }

  static String fontName(index, context){
    switch(index){
      case 0: 
        return "auto";
      case 1:
        return "ZCOOL KuaiLe";
      default:
        return '';
    }
  }

  static saveFontIndex(int index) async{
    await StorageManager.sharedPreferences.setInt(kFontIndex, index);
  }

  themeData({bool platformDarkMode: false}){
    var isDark = platformDarkMode || _userDarkMode;
    Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    var themeColor = _themeColor;
    var accentColor = isDark ? themeColor[600] : _themeColor;
    debugPrint("COLOR");
    print(accentColor);
    var scaffoldBackgroundColor = isDark ? Color(0xFF373331) : Colors.white;
    final ThemeData theme = ThemeData();
    final ColorScheme colorSchemeLight = ColorScheme(
      primary: themeColor,
      secondary: accentColor,      
      surface: scaffoldBackgroundColor,
      background: scaffoldBackgroundColor,
      brightness: (isDark)?Brightness.dark:Brightness.light,
      error: Colors.red,
      onBackground: scaffoldBackgroundColor,
      onError: Colors.white,
      onPrimary: themeColor,
      onSecondary: accentColor,
      onSurface:scaffoldBackgroundColor,
      primaryContainer: themeColor,
      secondaryContainer: themeColor,
    );
    var themeData = ThemeData(
      //brightness: brightness,       
      colorScheme: colorSchemeLight,
      scaffoldBackgroundColor: scaffoldBackgroundColor, 
      fontFamily: fontValueList[fontIndex],
    );

    themeData = themeData.copyWith(
      brightness: brightness, 
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: themeColor, 
        brightness: brightness,
      ), 
      appBarTheme : themeData.appBarTheme.copyWith(elevation: 0), 
      splashColor: themeColor.withAlpha(50), 
      hintColor: themeData.hintColor.withAlpha(90), 
      errorColor: Colors.red, 
      textTheme: themeData.textTheme.copyWith(
        subtitle1: themeData.textTheme.subtitle1.copyWith(textBaseline: TextBaseline.alphabetic)
      ), 
      toggleableActiveColor: accentColor, 
      chipTheme: themeData.chipTheme.copyWith(
        pressElevation: 0, 
        padding: EdgeInsets.symmetric(horizontal: 10), 
        labelStyle: themeData.textTheme.caption, 
        backgroundColor: themeData.chipTheme.backgroundColor, 
      ), 
      inputDecorationTheme: ThemeHelper.inputDecorationTheme(themeData), 
      colorScheme: themeData.colorScheme.copyWith(secondary: accentColor),
    );

    return themeData;
  
  }
}
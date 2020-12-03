
import 'package:church_of_christ/bloc/repository/idc_api.dart';
import 'package:church_of_christ/generals/features/theme_change_event.dart';
import 'package:church_of_christ/generals/features/theme_change_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:church_of_christ/utils/theme.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class ThemeBloc extends Bloc<ThemeEvent, ThState> {
  final IDCRepository repository;
  
  ThemeBloc({@required this.repository }) : assert(repository != null), super(ThemeStateInitial());

  @override
  ThemeState get initialState =>      
      ThemeState(themeData: appThemeData[AppTheme.lightTheme]);

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if(event is ThemeGet){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String strTheme = prefs.getString("theme");
        String accentColor = prefs.getString("accentColor");
        if(strTheme != null && strTheme.isNotEmpty){
            int value = int.parse(accentColor, radix: 16);
            Color otherColor = new Color(value);
            if(strTheme == "light"){
              ThemeData customThemeData = buildLightTheme(otherColor);
              yield ThemeState(themeData: customThemeData);
            }
            else{
              ThemeData customThemeData = buildDarkTheme(otherColor);
              yield ThemeState(themeData: customThemeData);        
            }
        }
        else{
          yield ThemeState(themeData: appThemeData[AppTheme.darkTheme]);
        }      
    }
    if (event is ThemeChanged) {
      if(event.theme == AppTheme.lightTheme){      
        await repository.setThemePreferences("light", event.color);
        ThemeData customThemeData = buildLightTheme(event.color);
        yield ThemeState(themeData: customThemeData);
      }
      else{
        await repository.setThemePreferences("dark", event.color);
        ThemeData customThemeData = buildDarkTheme(event.color);
        yield ThemeState(themeData: customThemeData);        
      }      
    }
  }
}
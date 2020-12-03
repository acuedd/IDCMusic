import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:church_of_christ/utils/theme.dart';


@immutable
abstract class ThemeEvent extends Equatable { }

class ThemeChanged extends ThemeEvent {
  final AppTheme theme;
  final Color color;

  ThemeChanged({
    @required this.theme,
    this.color,
  });

  @override
  List<Object> get props => [theme, color];
}

class ThemeGet extends ThemeEvent{
  ThemeGet();

  @override
  List<Object> get props => [];  
}
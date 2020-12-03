import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


abstract class ThState extends Equatable{
  const ThState();

  @override
  List<Object> get props => [];
}

class ThemeState extends ThState {
  final ThemeData themeData;

  ThemeState({
    @required this.themeData,
  });

  @override  
  List<Object> get props => [themeData];
}

class ThemeStateInitial extends ThState{ }
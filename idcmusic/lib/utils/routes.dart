import 'package:church_of_christ/generals/ui/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/generals/ui/screens/tab/settings_screen.dart';
import 'package:church_of_christ/generals/ui/screens/about.dart';
import 'package:church_of_christ/generals/ui/screens/changelog.dart';

class RouteIDC {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/settings': 
        return MaterialPageRoute(builder: (_) => SettingsScreen()); 
      case '/about': 
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case '/changelog':
        return MaterialPageRoute(builder: (_) => ChangelogList());
      default:
        return _errorRoute();
    }
    return null;
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
            flexibleSpace: Image(
              image: AssetImage('assets/images/title.png'),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Text('Error, ruta no encontrada'),
          ));
    });
  }
}

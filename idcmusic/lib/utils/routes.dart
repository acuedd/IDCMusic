import 'package:church_of_christ/generals/ui/screens/main_screen.dart';
import 'package:church_of_christ/generals/ui/screens/splash_page.dart';
import 'package:church_of_christ/player/ui/screens/collections_carousel.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/generals/ui/screens/tab/settings_screen.dart';
import 'package:church_of_christ/generals/ui/screens/about.dart';
import 'package:church_of_christ/generals/ui/screens/changelog.dart';

class RouteName{
  static const String splash = 'splash';
  static const String tab = '/';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String changelog = '/changelog';
  static const String allCollections = "allCollections";
}


class RouteIDC {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case RouteName.tab:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case RouteName.splash:
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.settings: 
        return MaterialPageRoute(builder: (_) => SettingsScreen()); 
      case RouteName.about: 
        return MaterialPageRoute(builder: (_) => AboutScreen());
      case RouteName.changelog:
        return MaterialPageRoute(builder: (_) => ChangelogList());
      case RouteName.allCollections: 
        return MaterialPageRoute(builder: (_) => CarouselCollection());
      default:
        return _errorRoute();
    }
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

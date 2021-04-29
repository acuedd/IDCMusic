import 'package:church_of_christ/ui/page/about.dart';
import 'package:church_of_christ/ui/page/after_fist_layout.dart';
import 'package:church_of_christ/ui/page/album_full_page.dart';
import 'package:church_of_christ/ui/page/changelog.dart';
import 'package:church_of_christ/ui/page/songs_all_page.dart';
import 'package:church_of_christ/ui/page/splash_page.dart';
import 'package:church_of_christ/ui/page/tab/tab_navigator.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:flutter/material.dart';


class RouteName{
  static const String splash = 'splash';
  static const String tab = '/';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String changelog = '/changelog';
  static const String allCollections = "allCollections";
  static const String allSongs = "allSongs";
  static const String afterFistLayout = "afterFist";
}

//return MaterialPageRoute(builder: (_) => MainScreen());
class RouteIDC {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    switch (settings.name) {      
      case RouteName.tab:
        return NoAnimRouteBuilder(Tabnavigator());
      case RouteName.splash:      
        return NoAnimRouteBuilder(SplashPage());
      case RouteName.about: 
        return SlideLeftRouteBuilder(AboutScreen());
      case RouteName.changelog: 
        return SlideLeftRouteBuilder(ChangelogList());
      case RouteName.allCollections: 
        return SlideBottomRouteBuilder(AlbumGridCarousel());
      case RouteName.allSongs: 
        return SlideBottomRouteBuilder(SongsAllCarousel());
      case RouteName.afterFistLayout: 
        return NoAnimRouteBuilder(AfterFist());
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

class PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:church_of_christ/generals/ui/screens/about.dart';
import 'package:church_of_christ/generals/ui/screens/tab/settings_screen.dart';
import 'package:church_of_christ/player/ui/screens/tab/download_page.dart';
import 'package:church_of_christ/player/ui/screens/tab/favorite_page.dart';
import 'package:church_of_christ/player/ui/screens/tab/principal_screen.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';

class TabNavigator extends StatefulWidget{
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  var _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> pages = <Widget>[
    PrinciapalScreen(), MusicPage(), FavoritePage(),SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light));
            

    return Scaffold(
      body: PageView.builder(
        itemBuilder: (ctx, index) => pages[index],
        itemCount: pages.length,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
      ), 
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor, 
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), 
            topRight: Radius.circular(30.0),
          ),
        ),
        child: BubbleBottomBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.transparent,
          onTap: (int index){
            _pageController.jumpToPage(index);
          },
          opacity: 1,
          elevation: 0,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem( 
              backgroundColor: Theme.of(context).primaryColorDark, 
              icon: Icon(
                Icons.music_note,
                size: 25.0,
              ), 
              activeIcon: Icon(
                Icons.music_note,
                size: 25.0,
                color: Colors.white,
              ), 
              title: Text(
                "Buscar",
                style: TextStyle(color: Colors.white),
              ),
            ),
            BubbleBottomBarItem(
              backgroundColor: Theme.of(context).primaryColorDark,
              icon: Icon(
                Icons.file_download,
                size: 25.0,
              ),
              activeIcon: Icon(
                Icons.music_note,
                size: 25.0,
                color: Colors.white,
              ),
              title: Text(
                "Descargas",
                style: TextStyle(color: Colors.white),
              )
            ),
            BubbleBottomBarItem(
              backgroundColor: Theme.of(context).primaryColorDark,
              icon: Icon(
                Icons.favorite,
                size: 25.0,
              ),
              activeIcon: Icon(
                Icons.favorite,
                size: 25.0,
                color: Colors.white,
              ),
              title: Text(
                "Favoritas",
                style: TextStyle(color: Colors.white),
              ),
            ),
            BubbleBottomBarItem(
              backgroundColor: Theme.of(context).primaryColorDark, 
              icon: Icon(
                Icons.settings, 
                size: 25.0,
              ), 
              activeIcon: Icon(
                Icons.settings, 
                size: 25.0,
                color: Colors.white,
              ), 
              title: Text(
                "General", 
                style: TextStyle(color: Colors.white),
              )
            ),
          ],
        ),
      ),
    );
  }
}
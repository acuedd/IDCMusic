import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:church_of_christ/model/download_model.dart';
import 'package:church_of_christ/model/favorite_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/ui/page/tab/favorite_page.dart';
import 'package:church_of_christ/ui/page/tab/settings_page.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Tabnavigator extends StatefulWidget{
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<Tabnavigator>{
  var _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> pages = <Widget>[ 
    FavoritePage(), 
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle( 
      statusBarColor: Colors.transparent, 
      statusBarBrightness: Theme.of(context).brightness == Brightness.dark 
        ? Brightness.dark 
        : Brightness.light
    ));

    FavoriteModel favoriteModel = Provider.of(context);
    DownloadModel downloadModel = Provider.of(context);
    
    return Scaffold(
      body: ProviderWidget2<FavoriteListModel, DownloadListModel>( 
        onModelReady: (favoriteListModel, downloadListModel) async {
            await favoriteListModel.initData();
            await downloadListModel.initData();
          },
        model1: FavoriteListModel(favoriteModel: favoriteModel),
        model2: DownloadListModel(downloadModel: downloadModel),
        builder: (context, model1, model2, child) {
            return PageView.builder(
              itemBuilder: (ctx, index) => pages[index],
              itemCount: pages.length,
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            );
          }),
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
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Theme.of(context).primaryColorDark, 
              icon: Icon( 
                Icons.search, 
                size: 25.0,
              ), 
              activeIcon: Icon( 
                Icons.search, 
                size: 25.0,
                color: Colors.white,
              ), 
              title: Text( 
                "Musica", 
                style: TextStyle(color: Colors.white),
              ),
            ),
            BubbleBottomBarItem(
              backgroundColor: Theme.of(context).primaryColorDark, 
              icon: Icon(  
                Icons.search, 
                size: 25.0,
              ), 
              activeIcon: Icon( 
                Icons.search, 
                size: 25.0,
                color: Colors.white,
              ), 
              title: Text( 
                "Configuraciones", 
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          opacity: 1,
          elevation: 0,
        ),
      ),
    );
  }
}
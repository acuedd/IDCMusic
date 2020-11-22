import 'package:flutter/material.dart';
import 'package:church_of_christ/generals/ui/screens/tab/settings_screen.dart';
import 'package:church_of_christ/player/ui/screens/tab/principal_screen.dart';

class MenuScreen extends StatefulWidget{
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    PrinciapalScreen(),SettingsScreen(),
  ];

  void _onPageChanged(int index){
    setState(()=> _currentIndex = index);
  }

  void _onItemTapped(int selectedIndex){
    print(selectedIndex);      
    _pageController.jumpToPage(selectedIndex);
  }

 
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(    
      body: SafeArea(child: PageView( 
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(fontFamily: 'Lato'),
        unselectedLabelStyle: TextStyle(fontFamily: 'Lato'),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text("Musica"), 
            icon: Icon(Icons.library_music),
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            title: Text("General"), 
            icon: Icon(Icons.settings),
            backgroundColor: Colors.green,
          ),
        ],      
      ),      
    );
  }
}
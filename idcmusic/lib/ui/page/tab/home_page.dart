
import 'dart:io';
import 'dart:math';

import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/model/collections_model.dart';
import 'package:church_of_christ/model/home_model.dart';
import 'package:church_of_christ/model/song_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/provider/view_state_widget.dart';
import 'package:church_of_christ/service/base_repository.dart';
import 'package:church_of_christ/ui/page/player_page.dart';
import 'package:church_of_christ/ui/page/search_page.dart';
import 'package:church_of_christ/ui/page/welcome_page.dart';
import 'package:church_of_christ/ui/widgets/albums_carousel.dart';
import 'package:church_of_christ/ui/widgets/artists_carousel.dart';
import 'package:church_of_christ/ui/widgets/dailymix_widget.dart';
import 'package:church_of_christ/ui/widgets/dialog_presentation.dart';
import 'package:church_of_christ/ui/widgets/for_you_carousel.dart';
import 'package:church_of_christ/ui/widgets/player_widget.dart';
import 'package:church_of_christ/ui/widgets/recently_songs.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:launch_review/launch_review.dart'; 

class HomePage extends StatefulWidget{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin{

  AnimationController controllerRecord; 
  Animation<double> animationRecord; 
  final _inputController = TextEditingController(); 
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0); 

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
     super.initState();
     controllerRecord = new AnimationController(
       duration: const Duration(milliseconds: 15000), vsync: this);
     animationRecord = new CurvedAnimation(parent: controllerRecord, curve: Curves.linear);
     animationRecord.addStatusListener((status) {
       if(status == AnimationStatus.completed){
         controllerRecord.repeat();
       }
       else if(status == AnimationStatus.dismissed ){
         controllerRecord.forward();
       }
     });
    
    
    Future.delayed(Duration.zero, () async {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      String version = packageInfo.version;
      String packageName = packageInfo.packageName;
      String appName = packageInfo.appName;
      String os = Platform.operatingSystem;
      // Show the Register page
      final SharedPreferences prefs = await SharedPreferences.getInstance();  
      // First time app boots
      if (prefs.getBool('register_seen') == null)
        prefs.setBool('register_seen', false);
      if (prefs.getString('register_date') == null)
        prefs.setString(
          'register_date',
          DateTime.now().toIso8601String(),
        );

      BaseRepository.getLastVersionApp(os, packageName, version: version).then((value){
                
        if(value["valido"] != null && value["valido"] == 1){
          if(version != value["version"]){
            final datecheck = DateTime.parse(prefs.getString('register_date'));
            final difference = DateTime.now().difference(datecheck).inDays;
            if (difference >= 7) {
              showDialog(
                context: context,
                builder: (context) => PresentationDialog.goStore(context, () => LaunchReview.launch(
                      androidAppId: packageName, 
                      iOSAppId: Url.appStoreID
                    ), "Actualizar",appName, false)
              );
            }            
          }
        }
        else{
          showDialog(
            context: context,
            builder: (context) => PresentationDialog.goStore(context, () => LaunchReview.launch(
                  androidAppId: packageName, 
                  iOSAppId: Url.appStoreID
                ), "Actualizar",appName, false)
          );
        }
      });
    });

  }
  
  @override
  void dispose() {
    super.dispose();
    _inputController.dispose();
    controllerRecord.dispose();    
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    SongModel songModel = Provider.of(context);
    if(songModel.isPlaying){
      controllerRecord.forward();
    }
    else {
      controllerRecord.stop(canceled: false);
    }

    return Scaffold(
      body: GestureDetector( 
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());          
        },
        child: SafeArea( 
          child: ProviderWidget<HomeModel>( 
            onModelReady: (homeModel) async{
              await homeModel.initData();
            },
            model: HomeModel(),
            autoDispose: false,
            builder: (context, homeModel, child){
              if(homeModel.busy){
                return ViewStateBusyWidget();
              }
              else if(homeModel.error && homeModel.list.isEmpty){
                return ViewStateErrorWidget(
                  error: homeModel.viewStateError, 
                  onPressed: homeModel.initData
                );
              }

              CollectionModel albums = homeModel?.albums ?? CollectionModel();
              CollectionModel albums2 = homeModel?.albums2 ?? CollectionModel();
              AuthorModel artists = homeModel?.authors ?? AuthorModel();
              List<Song> foryou = homeModel?.forYou ?? [];
              List<Song> songsRecently = homeModel?.songsRecently ?? [];
              List<Song> dailyMix0 = homeModel?.dailyMix0 ?? [];
              List<Song> dailyMix1 = homeModel?.dailyMix1 ?? [];
              List<Song> dailyMix2 = homeModel?.dailyMix2 ?? [];
              List listDailyMix = [dailyMix0, dailyMix1, dailyMix2];

              return Column(children: <Widget>[
                Padding( 
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row( 
                    children: <Widget>[
                      Expanded( 
                        child: Container( 
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration( 
                            color: Theme.of(context).colorScheme.secondary.withAlpha(50), 
                            borderRadius: BorderRadius.circular(30.0),                            
                          ),
                          child: TextField( 
                            style: TextStyle( 
                              fontSize: 15.0, 
                              color: Colors.grey,
                            ),
                            controller: _inputController,
                            onChanged: (value){},
                            onSubmitted: (value){
                              if(value.isNotEmpty == true){
                                Navigator.push(context, 
                                  MaterialPageRoute(
                                    builder: (_) => SearchPage( 
                                      input: value,
                                    ),
                                  ),
                                );
                              }
                            },
                            decoration: InputDecoration( 
                              border: InputBorder.none, 
                              enabledBorder: InputBorder.none, 
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon( 
                                Icons.search, 
                                color: Colors.grey,
                              ), 
                              hintText: songModel.songs != null
                                ? songModel.currentSong.title
                                : "Track,album,artist,podcast"
                            ),
                          ),
                        ),
                      ),
                      Padding( 
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton( 
                          icon: Icon(Icons.device_unknown),
                          color: Theme.of(context).colorScheme.secondary,
                          iconSize: 30.0,
                          onPressed: (){
                            Navigator.push(
                              context, 
                              SlideTopRouteBuilder(WelcomeScreen(popRoute: true,)),
                            );                            
                          },
                        ),
                      ),
                      /*Padding( 
                        padding: const EdgeInsets.only(right: 20.0),
                        child: RotateRecord(
                          animation: _commonTween.animate(controllerRecord),
                        ),
                      )*/
                    ],
                  ),
                ),
                Expanded( 
                  child: SmartRefresher( 
                    header: WaterDropHeader(),
                    controller: homeModel.refreshController,
                    onRefresh: () async{
                      await homeModel.refresh();
                      homeModel.showErrorMessage(context);
                    },
                    child: ListView(children: <Widget>[    
                      SizedBox(height: 8,),
                      DailyMixes(mixes: listDailyMix,),
                      SizedBox(height: 10,),
                      ForYouCarousel(foryou),
                      (songsRecently.length >0)
                        ? RecentlySongs(songsRecently)
                        : SizedBox.shrink(),
                      SizedBox(height: 10,),
                      ArtistsCarousel(artists.authors),
                      SizedBox(height: 10,),
                      AlbumsCarousel(albums.collections),                      
                    ]),
                  ),
                ),
              ]);

            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar( 
        child: PlayerWidget(songModel),
      ),
    );
  }

}
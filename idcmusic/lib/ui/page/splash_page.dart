import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/config/routes.dart';

class SplashPage extends StatefulWidget{
  static const String image = 'ic_splash.png';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin{
  AnimationController _countdownController;

  @override
  void initState() {
    _countdownController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _countdownController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _countdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope( 
        onWillPop: () => Future.value(false),
        child: Stack(fit: StackFit.expand, children: <Widget>[
          Container( 
            padding: EdgeInsets.all(40),
            child: Column( 
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Música acapella', style: GetTextStyle.XL(context),),
                Text('de la Iglesia de Cristo', style: GetTextStyle.XL(context),),
                SizedBox(height: 50,), 
                Center( 
                  child: Image.asset( 
                    Utils.wrapAssets(SplashPage.image), 
                  ),
                ),
              ],
            ),
          ), 
          Align( 
            alignment: Alignment.bottomRight,
            child: SafeArea( 
              child: InkWell( 
                onTap: (){
                  nextPage(context);
                },  
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin: EdgeInsets.only(right: 40, bottom: 20),
                  decoration: BoxDecoration( 
                    borderRadius: BorderRadius.circular(15), 
                    border: Border.all(color: Colors.black12, width: 1), 
                  ),
                  child: AnimatedCountdown( 
                    context: context,
                    animation: StepTween( begin: 2, end: 0).animate(_countdownController),
                  ),
                ),
              ),
            ),
          ),
        ],),
      ),
    );
  }
}

class AnimatedCountdown extends AnimatedWidget{
  final Animation<int> animation;

  AnimatedCountdown({key, this.animation, context})
    : super(key: key, listenable: animation){
      this.animation.addStatusListener((status) {
        if(status == AnimationStatus.completed){
          nextPage(context);
        }
      });
    }

    @override
  Widget build(BuildContext context) {
    return Text('Skip');
  }
}

void nextPage(context){
  Navigator.of(context).pushReplacementNamed(RouteName.tab);
}
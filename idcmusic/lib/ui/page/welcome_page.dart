import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

List items = [
  {
    "header": "Usar el app",
    "description":
        "En esta aplicación es completamente gratuita y podrás escuchar las canciones acapella de la Iglesia de Cristo, es probable que no estén algunas por lo que apoyanos contactándonos.",
    "image": "assets/images/1.png"
  },
  {
    "header": "Contenido",
    "description":
        "Puedes bucar tu contenido por álbum, ver todas las canciones o por nombre en la barra de búsqueda.",
    "image": "assets/images/screen1acamusic.png"
  },
  {
    "header": "Reproducción",
    "description":
        "Puedes descargar, agregar a favoritas o ver tu listado de reproducción.",
    "image": "assets/images/screen2acamusic.png"
  },
  {
    "header": "Sin conexión",
    "description":
        "Puedes disfrutar de tu música favorita cuando te quedes sin conexión, solo asegurate de tener descargadas tus canciones favoritas.",
    "image": "assets/images/screen3acamusic.png"
  },
  {
    "header": "Comparte",
    "description":
        "Comparte con tus amigos esta aplicación para que otros puedan ser bendecios a través de la música. ",
    "image": "assets/images/3.png"
  }
];

class WelcomeScreen extends StatefulWidget{
  final bool popRoute;
  WelcomeScreen({this.popRoute = false});
  
  @override
  _WelcomeScreen createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen>{
  double currentPage = 0.0;
  final _pageViewController = new PageController();

  List<Widget> slides = items
      .map((item) => Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column( 
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Image.asset(
                item['image'],
                fit: BoxFit.fitWidth,
                width: 300.0,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container( 
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column( 
                  children: <Widget>[
                    Text(item["header"], 
                      style: TextStyle(  
                        fontSize: 45.0, 
                        fontWeight: FontWeight.w300, 
                        height: 2.0
                      ),
                    ), 
                    Center(
                      child: Text(item["description"], 
                        style: TextStyle(  
                          color: Colors.grey, 
                          letterSpacing: 1.2, 
                          fontSize: 16.0, 
                          height: 1.3
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
    slides.length, 
    (index) => Container(  
      margin: EdgeInsets.symmetric(horizontal: 3.0),
      height: 10.0,
      width: 10.0,
      decoration: BoxDecoration(  
        color: currentPage.round() == index 
          ? Color(0XFF256075)
          : Color(0XFF256075).withOpacity(0.2), 
        borderRadius: BorderRadius.circular(10.0)
      ),
    )
  );

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Container(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  controller: _pageViewController,
                  itemCount: slides.length,
                  itemBuilder: (BuildContext context, int index) {
                    _pageViewController.addListener(() {
                      setState(() {
                        currentPage = _pageViewController.page;
                      });
                    });
                    return slides[index];
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 70.0),
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator(),
                    ),
                  ),                   //  ),
                ), 
                Align( 
                  alignment: Alignment.bottomRight,
                  child: SafeArea( 
                    child: InkWell( 
                      onTap: (){
                        if(widget.popRoute){
                          Navigator.pop(context);
                        }
                        else{
                          goToIndex(context);
                        }                        
                      },  
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        margin: EdgeInsets.only(right: 40, bottom: 20),
                        decoration: BoxDecoration( 
                          borderRadius: BorderRadius.circular(15), 
                          border: Border.all(color: Colors.black12, width: 1), 
                        ),
                        child: Text("Skip"),
                      ),
                    ),
                  ),
                ),                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


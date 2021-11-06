import 'dart:io';

import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

List itemsAndroid = [
  {
    "header": "Disclaimer",
    "description":
        "Esta app es completamente gratuita y no lucramos con el contenido. Para las canciones se ha solicitado el permiso para compartir a cada coro o artista. si alguna canción infringe en derechos de autor o no tiene los permisos para compartir, por favor reportala para hacer las gestiones pertinentes.",
    "image": "assets/images/1.png"
  },
  {
    "header": "Usar el app",
    "description":
        "Podrás escuchar las canciones acapella de las Iglesias de Cristo." +
        "Si conoces a algún coro que desee compartir su música mediante el app, ¡ayúdanos a contactarlo!. En el apartado de información del app puedes contactar con nosotros.",
    "image": "assets/images/1.png"
  },
  {
    "header": "Contenido",
    "description":
        "Puedes bucar tu contenido por álbum, ver todas las canciones o busccar por palabra, album o nombre en la barra de búsqueda",
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
    "header": "Con estilo",
    "description":
        "Puedes usar tus colores favoritos y crea tu propio estilo.",
    "image": "assets/images/screen4acamusic.png"
  },
  {
    "header": "Comparte",
    "description":
        "Comparte con tus amigos ésta aplicación para que otros puedan ser bendecidos a través de la música. ",
    "image": "assets/images/3.png"
  }
];

List itemsIOS = [
  {
    "header": "Disclaimer",
    "description":
        "Esta app es completamente gratuita y no lucramos con el contenido. Para las canciones se ha solicitado el permiso para compartir a cada coro o artista. si alguna canción infringe en derechos de autor o no tiene los permisos para compartir, por favor reportala para hacer las gestiones pertinentes.",
    "image": "assets/images/1.png"
  },
  {
    "header": "Usar el app",
    "description":
        "Podrás escuchar las canciones acapella de las Iglesias de Cristo." +
        "Si conoces a algún coro que desee compartir su música mediante el app, ¡ayúdanos a contactarlo!. En el apartado de información del app puedes contactar con nosotros.",
    "image": "assets/images/1.png"
  },
  {
    "header": "Contenido",
    "description":
        "Puedes bucar tu contenido por álbum, ver todas las canciones o busccar por palabra, album o nombre en la barra de búsqueda",
    "image": "assets/images/screen1acamusic.png"
  },
  {
    "header": "Reproducción",
    "description":
        "Puedes descargar, agregar a favoritas o ver tu listado de reproducción.",
    "image": "assets/images/screenshootiOS2.png"
  },
  {
    "header": "Con estilo",
    "description":
        "Puedes usar tus colores favoritos y crea tu propio estilo.",
    "image": "assets/images/screen4acamusic.png"
  },
  {
    "header": "Comparte",
    "description":
        "Comparte con tus amigos ésta aplicación para que otros puedan ser bendecidos a través de la música. ",
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

  

  List<Widget> indicator(int len) => List<Widget>.generate(
    len, 
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
  Widget build(BuildContext context) {
    List slides = [];
    if(!Platform.isIOS){
      slides = itemsAndroid;
    }
    else{
      slides = itemsIOS;
    }

    double screenHeight = MediaQuery.of(context).size.height;
    double screenAspectRatio = 300.0;
    double textSizeHeader = 45.0;
    if(screenHeight>800){
      screenAspectRatio = 300.0;
      textSizeHeader = 40.0;
    }
    else if(screenHeight>=600 && screenHeight <= 800){
      screenAspectRatio = 260.0;
      textSizeHeader = 30.0;
    }
    else if(screenHeight <= 600){
      screenAspectRatio = 210.0;
      textSizeHeader = 25.0;
    }

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
                    
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column( 
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            child: Image.asset(
                              slides[index]['image'],
                              fit: BoxFit.fitWidth,
                              width: screenAspectRatio,
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
                                  Text(slides[index]["header"], 
                                    style: TextStyle(  
                                      fontSize: textSizeHeader, 
                                      fontWeight: FontWeight.w300, 
                                      height: 2.0
                                    ),
                                  ), 
                                  Center(
                                    child: Text(slides[index]["description"], 
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
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 70.0),
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: indicator(slides.length),
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
                        child: Text("Saltar"),
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


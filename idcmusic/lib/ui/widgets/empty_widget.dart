

import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget{
  final String title; 
  final String description; 
  

  EmptyWidget({this.title = "", this.description = "",});
  
  @override
  Widget build(BuildContext context) {
    String path_image = "assets/images/no_data.png";  
    double screenHeight = MediaQuery.of(context).size.height;
    double screenAspectRatio = 300.0;
    if(screenHeight>800){
      screenAspectRatio = 280.0;
    }
    else if(screenHeight>=600 && screenHeight <= 800){
      screenAspectRatio = 240.0;
    }
    else if(screenHeight <= 600){
      screenAspectRatio = 180.0;
    }

    Widget item =  Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column( 
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Image.asset(
                path_image,
                fit: BoxFit.fitWidth,
                width: screenAspectRatio,
                alignment: Alignment.bottomCenter,
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container( 
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column( 
                  children: <Widget>[
                    Text(title, 
                      textAlign: TextAlign.center,
                      style: TextStyle(  
                        fontSize: 30.0, 
                        fontWeight: FontWeight.w300, 
                        height: 1.5,
                        letterSpacing: 0.5,
                        
                      ),
                    ),
                    SizedBox(height: 35,),
                    Center(
                      child: Text(description, 
                        textAlign: TextAlign.center,
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

    return item;
  }
}
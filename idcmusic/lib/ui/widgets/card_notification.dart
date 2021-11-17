import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class CardNotification extends StatelessWidget{
  final double height;
  final double width;
  final String tTitle;
  final String tContent;

  CardNotification({  
    this.tTitle,
    this.tContent,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Stack( 
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          padding: EdgeInsets.only(
            top: 10.0, 
            left: 10.0, 
            right: 20.0, 
            bottom: 10.0,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            shape: BoxShape.rectangle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5.0,
                offset: Offset(2.0, 1.0)
              )
            ]
          ),
          child: Row(
            children: <Widget>[
              Container(
                height: 35,
                width: 35,
                margin: EdgeInsets.only(
                  right: 10.0,
                ),
                child: Icon(
                  AntDesign.notification,
                  color: Colors.grey[700],
                  size: 30,
                ),
                
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        tTitle,
                        style: TextStyle(
                          color: Color(0xFFD50000),
                          fontFamily: "Lato",
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(tContent,
                        style: TextStyle(
                          color: Color(0xFF969696),
                          fontFamily: "Lato",
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),        
      ]
    );
  }
}
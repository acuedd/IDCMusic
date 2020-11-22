import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);
var mm = '🎵';
var flume = 'https://i.scdn.co/image/8d84f7b313ca9bafcefcf37d4e59a8265c7d3fff';
var martinGarrix =
    'https://c1.staticflickr.com/2/1841/44200429922_d0cbbf22ba_b.jpg';
var rosieLowe =
    'https://i.scdn.co/image/db8382f6c33134111a26d4bf5a482a1caa5f151c';


class playerScreen extends StatelessWidget{
  final title;
  final artist;
  final image;

  playerScreen(this.title, this.artist, this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: Column(
        children: <Widget>[
          Container(
            height: 500.0,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(image),fit: BoxFit.cover
                    )
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [blueColor.withOpacity(0.4), blueColor],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 52.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                            ),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text("IDC Music",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                              Text("Best Music",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.cloud_download,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Spacer(),
                      Text(title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 32.0
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        artist,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 18.0
                        ),
                      ),
                      SizedBox(height: 16.0,),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 42.0,),
          Slider(
            onChanged: (double value){

            },
            value: 0.2,
            activeColor: pinkColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "2:10",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                ),
                Text(
                  "-03:56",
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                )
              ],
            ),
          ),
          Spacer(),
          _getControlsPlay(),
          Spacer(),
          _getControlShuffle(),
          SizedBox(height: 58.0,),
        ],
      ),
    );
  }

  Widget _getControlsPlay(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.fast_rewind,
          color: Colors.white54,
          size: 42.0,
        ),
        SizedBox(width: 32.0,),
        Container(
          decoration: BoxDecoration(
            color: pinkColor,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.play_arrow,
              size: 58.0,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 32.0,),
        Icon(
          Icons.fast_forward,
          color: Colors.white54,
          size: 42.0,
        )
      ],
    );
  }

  Widget _getControlShuffle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.bookmark_border,
          color: pinkColor,
        ),
        Icon(
          Icons.shuffle,
          color: pinkColor,
        ),
        Icon(
          Icons.repeat,
          color: pinkColor,
        )
      ],
    );
  }
}
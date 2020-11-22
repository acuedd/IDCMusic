import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/player/ui/widgets/songItem.dart';
import 'package:flutter/material.dart';

class ForYouCarousel extends StatefulWidget {
  final List<Song> forYou;

  ForYouCarousel(this.forYou);
  @override
  _ForYouCarouselState createState() => _ForYouCarouselState();
}

class _ForYouCarouselState extends State<ForYouCarousel> {


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Para ti",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 12
              ),
            ),
            GestureDetector(
              onTap: ()=>{
                print("view all songs"),
              },
              child: Text("Ver todos",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      ListView.builder(
        shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget.forYou.length,
          itemBuilder: (BuildContext context, int index){
            Song data = widget.forYou[index];
            return songItem(data);
          }
      ),
    ]);
  }
}

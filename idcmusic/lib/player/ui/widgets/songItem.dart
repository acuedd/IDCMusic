import 'package:church_of_christ/player/models/songs_model.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class songItem extends StatelessWidget{
  final Song song;

  songItem(this.song );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 50.0,
                  width: 50.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      song.path_image, 
                      fit: BoxFit.cover,
                    ),                    
                  ),
                ), 
                Container(
                  height: 50.0,
                  width: 50.0,
                  child: Icon(
                    Icons.play_circle_filled, 
                    color: Colors.white.withOpacity(0.7),
                    size: 42.0,
                  ),
                ), 
              ],              
            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title_resource,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    )
                  ),
                  SizedBox(height: 8.0,),
                  Text(
                    song.fullname,
                    style: GetTextStyle.getThirdHeading(context),
                  )
                ],
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () => print("press favorite"),
              icon: Icon(
                Icons.favorite_border,
                color: Theme.of(context).textTheme.caption.color.withOpacity(0.3),
                size: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
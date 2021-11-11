
import 'package:church_of_christ/model/artist_model.dart';
import 'package:church_of_christ/ui/page/artist_page.dart';
import 'package:church_of_christ/utils/anims/page_route_anim.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class itemAuthor extends StatelessWidget{
  final Author author;
  final int index;
  final int length;

  const itemAuthor({Key key, @required this.author, this.index, this.length}): super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenAspectRatio = 0;
    if(screenHeight>800){
      screenAspectRatio = 150.0;
    }
    else if(screenHeight>=600 && screenHeight <= 800){
      screenAspectRatio = 145.0;
    }
    else if(screenHeight <= 600){
      screenAspectRatio = 140.0;
    }

    final image = Utils.image(author.path_image, width: screenAspectRatio, height: screenAspectRatio, fit: BoxFit.cover);  
    return InkWell(
      onTap: () =>{
        Navigator.push(context, SlideLeftRouteBuilder(ArtistPage(author, image:image,)))
      },
      child: Container( 
        width: 140,
        margin: index == length -1
          ? EdgeInsets.only(right: 20.0)
          : EdgeInsets.only(right: 0.0),
        child: Padding(  
          padding: const EdgeInsets.only(left: 5.0),
          child: Column( 
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: image,
              ),
              SizedBox(height: 3,),
              Text(
                author.fullname,
                textAlign: TextAlign.center,
                style: GetTextStyle.M(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),                
            ],
          ),
        ),
      ),
    );
  }
}

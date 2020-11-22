import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'colors.dart';
import "dart:math";

enum Themes { light, dark, black, monokai, system }

class Utils {
  static Color convertIntColor(String color) {
    return Color(int.parse(color.replaceAll('#', ''), radix: 16))
        .withOpacity(1.0);
  }

  static Image image(String src, {height, width, fit}) {
    try{
      if(src != '') {
        if (src.startsWith('http')) {
          return Image(image: CachedNetworkImageProvider(src),
              height: height,
              width: width,
              fit: fit);
        }
        else{
          return Image.asset(src, height: height, width: width, fit: fit);
        }
      }else{
        return new Image.asset('assets/images/place_holder.jpg');
      }

    }catch(e){
      return new Image.asset('assets/images/place_holder.jpg');
    }
  }

  static String wrapAssets(String url) {
    return "assets/images/" + url;
  }

  static Widget placeHolder({double width, double height}) {
    return SizedBox(
        width: width,
        height: height,
        child: CupertinoActivityIndicator(radius: min(10.0, width / 3)));
  }

  static Widget error({double width, double height, double size}) {
    return SizedBox(
        width: width,
        height: height,
        child: Icon(
          Icons.error_outline,
          size: size,
        ));
  }

  static String randomUrl(
      {int width = 100, int height = 100, Object key = ''}) {
    return 'http://placeimg.com/$width/$height/${key.hashCode.toString() + key.toString()}';
  }
}

class GetTextStyle{
  static getSubHeaderTextStyle(BuildContext context){
    return TextStyle(
      fontSize: 18,
      //color: firstColor,
      color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
      fontWeight: FontWeight.w700,
      fontFamily: "Lato",
    );
  }

  static getThirdHeading(BuildContext context){
    return TextStyle(
      fontSize: 14,
      color: firstColor,
      //color: (Provider.of<AppModel>(context).theme == Themes.black || Provider.of<AppModel>(context).theme == Themes.dark)? firstColor: Theme.of(context).textTheme.caption.color,
      //color: Theme.of(context).textTheme.caption.color,
      fontWeight: FontWeight.w700,
      fontFamily: "Lato",
    );
  }

  static getHeadingOneTextStyle(BuildContext context){
    return TextStyle(
      fontSize: 20,
      //color: Colors.black,
      color: Theme.of(context).textTheme.caption.color,
      fontFamily: "Lato",
      fontWeight: FontWeight.bold,
    );
  }

  static getHeadingMusic(BuildContext context){
    return TextStyle(
      //color: Colors.white,
        color: Theme.of(context).textTheme.caption.color,
        fontFamily: "Lato",
        fontWeight: FontWeight.bold,
        fontSize: 38.0
    );
  }
}


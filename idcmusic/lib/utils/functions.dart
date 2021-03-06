import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/config/routes.dart';
import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import "dart:math";

Widget loadingIndicator() => Loader();

void goToIndex(context){
  Navigator.of(context).pushReplacementNamed(RouteName.afterFistLayout);
}

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
    //return 'http://placeimg.com/$width/$height/${key.hashCode.toString() + key.toString()}';
    return "https://idcrom.homelandplanet.com/var/configuration/theme/geniusAdminLTE/images/9792b824b81b23c8aa886df403278593c31ff90741e71e3403a38e42b56a3704.png";
  }
}

class GetTextStyle{
  static SS( BuildContext context){
    return TextStyle(
      fontSize: 10, 
      color: Colors.grey,
      fontWeight: FontWeight.w700,
      fontFamily: "Lato",      
    );    
  }

  static S( BuildContext context){
    return TextStyle(
      fontSize: 11, 
      color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
      fontWeight: FontWeight.w700,
      fontFamily: "Lato",
    );    
  }

  static SM( BuildContext context){
    return TextStyle(
      fontSize: 12, 
      //color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
      fontWeight: FontWeight.w600,
      fontFamily: "Lato",
    );    
  }

  static M(BuildContext context){
    return TextStyle(
      fontSize: 14, 
      //color: Theme.of(context).textTheme.,
      fontWeight: FontWeight.w700,
      fontFamily: "Lato",
    );    
  }

  static L(BuildContext context){
    return TextStyle(
      fontSize: 18, 
      //color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
      fontWeight: FontWeight.w700,
      fontFamily: "Lato",
    );    
  }

  static XL(BuildContext context){
    return TextStyle(
      fontSize: 22,     
      fontWeight: FontWeight.bold,
      fontFamily: "Lato",
      letterSpacing: 1.2,
    );    
  }

  static LXL(BuildContext context){
    return TextStyle(
      fontSize: 25,     
      fontWeight: FontWeight.bold,
      fontFamily: "Lato",
      letterSpacing: 1.2,
    );    
  }

  static XXL(BuildContext context){
    return TextStyle(
      fontSize: 38,     
      fontWeight: FontWeight.bold,
      fontFamily: "Lato",
      letterSpacing: 1.2,
    );    
  }
 
  static TITLE(BuildContext context){
    return TextStyle(
      fontSize: 50, 
      fontWeight: FontWeight.w300,
      height: 2.0,
      fontFamily: "Lato",
    );
  }

  static subtitle1(BuildContext context){
    return Theme.of(context).textTheme.subtitle1.copyWith(
      color: Theme.of(context).textTheme.caption.color,
    );
  }

  static headline6(BuildContext context){
    return Theme.of(context).textTheme.headline6.copyWith(
      color: Theme.of(context).textTheme.caption.color,
    );
  }

  static APPBAR(BuildContext context){
    return TextStyle(
      fontSize: 22,     
      fontWeight: FontWeight.bold,
      fontFamily: "Lato",
      letterSpacing: 1.2,
      color: Colors.black,
    );    
  } 
}

class IconFonts {
  IconFonts._();

  /// iconfont:flutter base
  static const String fontFamily = 'iconfont';

  static const pageEmpty = Icons.error_outline; //IconData(0xe63c, fontFamily: fontFamily);
  static const pageError = Icons.phonelink_erase_rounded; //IconData(0xe600, fontFamily: fontFamily);
  static const pageNetworkError = Icons.perm_scan_wifi;//IconData(0xe65f, fontFamily: fontFamily);
  static const pageUnAuth = Icons.person_add_disabled;//IconData(0xe65f, fontFamily: fontFamily);
}
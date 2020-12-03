import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class AppBarCarrousel extends StatelessWidget{
  final String title;
  const AppBarCarrousel({Key key, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
            child: Text(this.title,
              textAlign: TextAlign.left,
              style: GetTextStyle.XL(context),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.more_vert,
              size: 25.0,
              color: Colors.grey,
            ),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }
}
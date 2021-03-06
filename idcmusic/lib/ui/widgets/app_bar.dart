import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class AppBarCarrousel extends StatelessWidget{
  final String title;
  final bool iconBottom;
  const AppBarCarrousel({Key key, this.title, this.iconBottom = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(
              (this.iconBottom == true)
                ? Icons.arrow_drop_down
                : Icons.arrow_back_ios,
              size: (this.iconBottom == true)?50.0:25.0,
              color: Colors.grey,
            ),
            onPressed: () => {
              FocusScope.of(context).unfocus(),
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
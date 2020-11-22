import 'package:church_of_christ/player/models/collections_model.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';

class itemCollection extends StatelessWidget{
  final Collection collection;
  
  const itemCollection({Key key, @required this.collection}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Utils.image(collection.path_image, height: 140.0, width: 180.0, fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 20,
            right: 20,
            child: InkWell(
              onTap: null,
              child: Material(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Text(
                    collection.name_collection, 
                    textAlign: TextAlign.center,
                    style: GetTextStyle.getThirdHeading(context),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
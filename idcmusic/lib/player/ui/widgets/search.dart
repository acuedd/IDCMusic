import 'package:flutter/material.dart';

class SearchSong extends StatelessWidget {
  String textHint = "app.search";
  final TextEditingController editingController = new TextEditingController();
  BuildContext _context;
  final VoidCallback Function(String) onSubmited;
  final VoidCallback Function(String) onChanged;

  SearchSong({
    Key key,
    @required this.textHint,
    this.onSubmited,
    this.onChanged,
  });

  Widget build(BuildContext context) {
    _context = context;

    return new Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      margin: const EdgeInsets.only(),
      child: new Material(
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
        elevation: 2.0,
        child: new Container(
          height: 45.0,
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    maxLines: 1,
                    decoration: new InputDecoration(
                      icon: Icon(Icons.search, color: Theme.of(context).accentColor,),
                      hintText: textHint,
                      border: InputBorder.none,
                    ),
                    onSubmitted: onSubmitted,
                    controller: editingController,
                    //onChanged: onChangged,
                  )
              )
            ],
          ),
        ),
      ),
    );
  }

  onSubmitted(query){
    print("from search wid");
    print(query);
    onSubmited(query);
  }

  onChangged(query){
    print("from search wid change");
    print(query);
    //onChanged(query);
  }
}
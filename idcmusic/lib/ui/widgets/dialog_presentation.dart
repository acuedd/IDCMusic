import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

const List<String> _patreons = [
  'Edward Acu',
  'Nelson Matul',
];

class PresentationDialog extends StatelessWidget{
  final String title;
  final Widget body;
  final VoidCallback onPressed;
  final String textButton;
  final bool showPatreon;
  const PresentationDialog({
    @required this.body,
    this.onPressed,
    this.textButton,
    this.showPatreon = true,
    this.title = "",
  });
  


  factory PresentationDialog.goStore(BuildContext context, VoidCallback onPressed, String textButton, String title, bool showPatreon){
    return PresentationDialog(
      onPressed: onPressed,
      textButton: textButton,
      title: title,
      showPatreon: showPatreon,
      body: RowLayout(
        padding: EdgeInsets.symmetric(horizontal: 24),
        children: <Widget>[
          Text("¡Existe una nueva actualización! \n\nPara que tengas una mejor experiencia actualiza tu app",
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.caption.color,
            ),),
      ]),
    );
  }

  factory PresentationDialog.home(BuildContext context, VoidCallback onPressed, String textButton){
    return PresentationDialog(
      onPressed: onPressed,
      textButton: textButton,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            Icons.cake,
            size: 50,
            color: Theme.of(context).textTheme.caption.color,
          ),
          Icon(
            Icons.arrow_forward,
            size: 30,
            color: Theme.of(context).textTheme.caption.color,
          ),
          Icon(
            Icons.sentiment_satisfied,
            size: 50,
            color: Theme.of(context).textTheme.caption.color,
          ),
        ],
      ),
    );
  }

  factory PresentationDialog.about(BuildContext context, VoidCallback onPressed, String textButton) {
    return PresentationDialog(
      onPressed: onPressed,
      textButton: textButton,
      body: RowLayout(children: <Widget>[
        Text("También reporta fallos o solicita nuevas funciones",
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.caption.color,
        ),),
        Text("Agradecemos a nuestros patrocinadores del proyecto",
          style: Theme.of(context).textTheme.headline6.copyWith(
            fontWeight: FontWeight.normal,
            color: Theme.of(context).textTheme.caption.color,
          ),),
        for (String patreon in _patreons)
          Text(
            patreon,
            style: Theme.of(context).textTheme.headline6.copyWith(
              fontWeight: FontWeight.normal,
              color: Theme.of(context).textTheme.caption.color,
            ),
          ),
      ]),
    );
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool screenAspectRatio = true;    
    if(screenWidth <= 350){
      screenAspectRatio = false;
    }

    if(showPatreon)
      return RoundDialog(
        title: "Seamos comunidad",
        children: <Widget>[
          RowLayout(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: <Widget>[
              Text(
                Url.patreon,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Theme.of(context).textTheme.caption.color,
                ),
              ),
              body, 
              Align(
                alignment: Alignment.centerLeft,
                child: 
                  (screenAspectRatio) ?
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      child: Text(
                        "MÁS TARDE",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      onPressed: ()=> Navigator.pop(context,false),
                    ),
                    OutlineButton(
                      highlightedBorderColor: Theme.of(context).colorScheme.secondary,
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      child: Text(textButton),
                      onPressed: onPressed,
                    )
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[                    
                    OutlineButton(
                      highlightedBorderColor: Theme.of(context).colorScheme.secondary,
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      child: Text(textButton),
                      onPressed: onPressed,
                    ),
                    FlatButton(
                      child: Text(
                        "MÁS TARDE",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      onPressed: ()=> Navigator.pop(context,false),
                    ),
                  ],
                )
              ),
            ],
          ),
        ],
      );
    else 
      return RoundDialog(
      title: title,
      children: <Widget>[        
        RowLayout(
          padding: EdgeInsets.symmetric(horizontal: 5),
          children: <Widget>[
            body,             
              Align(
                alignment: Alignment.centerRight,
                child:
                  (screenAspectRatio) ?
                  Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FlatButton(
                      child: Text(
                        "MÁS TARDE",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      onPressed: ()=> Navigator.pop(context,false),
                    ),
                    OutlineButton(
                      highlightedBorderColor: Theme.of(context).colorScheme.secondary,
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      child: Text(textButton),
                      onPressed: onPressed,
                    )
                  ],
                )
                : Column(children: [
                    FlatButton(
                      child: Text(
                        "MÁS TARDE",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      onPressed: ()=> Navigator.pop(context,false),
                    ),
                    OutlineButton(
                      highlightedBorderColor: Theme.of(context).colorScheme.secondary,
                      borderSide: BorderSide(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      child: Text(textButton),
                      onPressed: onPressed,
                    )
                ]),
              ),
          ] 
        )   
      ]);
  }

}
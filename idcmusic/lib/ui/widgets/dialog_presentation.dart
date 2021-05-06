import 'package:church_of_christ/ui/widgets/dialog_round.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:flutter/material.dart';
import 'package:row_collection/row_collection.dart';

const List<String> _patreons = [
  'Edward Acu',
  'Nelson Matul',
];

class PresentationDialog extends StatelessWidget{

  final Widget body;
  final VoidCallback onPressed;
  final String textButton;
  const PresentationDialog({
    @required this.body,
    this.onPressed,
    this.textButton,
  });

  
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
    return RoundDialog(
      title: "Bendice a otros con tus aportes",
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
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "MÁS TARDE",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onPressed: ()=> Navigator.pop(context,false),
                  ),
                  OutlineButton(
                    highlightedBorderColor: Theme.of(context).accentColor,
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.headline6.color,
                    ),
                    child: Text(textButton),
                    onPressed: onPressed,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:church_of_christ/utils/functions.dart';

class HeaderText extends StatelessWidget{
  final String text;

  const HeaderText({
    Key key,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 16),
      child: Text(
        text,
        style: GetTextStyle.XL(context),
      ),
    );
  }
}
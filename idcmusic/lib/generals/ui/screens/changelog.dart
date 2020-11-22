import 'package:church_of_christ/bloc/bloc/idc_bloc.dart';
import 'package:church_of_christ/generals/features/generalRequestEvent.dart';
import 'package:church_of_christ/generals/features/generalRequestStatus.dart';
import 'package:church_of_christ/utils/widgets/custom_page.dart';
import 'package:church_of_christ/utils/url.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


/// This screen loads the [CHANGELOG.md] file from GitHub,
/// and displays its content, using the Markdown plugin.

class ChangelogList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangelogListState();
  }
}

class _ChangelogListState extends State<ChangelogList>{

  final List<dynamic> items = List();
  IDCBloc myBLoC;

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {    
    myBLoC = BlocProvider.of<IDCBloc>(context);      

    return BlanckPage(
      title: "Lista de cambios",
      body: BlocBuilder<IDCBloc, RequestState>(
        builder: (context, state){
          if(state is RequestEmpty){
            BlocProvider.of<IDCBloc>(context).add(FetchChangeLog());
          }
          if(state is RequestError){
            return _fatal(context);
          }
          if(state is RequestLoadedDio){
            return Markdown(
                data: state.response,
                onTapLink: (url) async => await FlutterWebBrowser.openWebPage(
                  url: url,
                  androidToolbarColor: Theme.of(context).primaryColor,
                ),
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  blockSpacing: 12,
                  h2: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.headline6.color,
                    fontFamily: 'ProductSans',
                  ),
                  p: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.caption.color,
                  ),
                ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _fatal(BuildContext context){
    double maxWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Container(
          child: Center( 
            child: Text("Ocurrió un error", 
              style: GetTextStyle.getSubHeaderTextStyle(context),
            ),
          ),          
        ),
        Positioned( 
          bottom: 0,
          child: Container(
            height: 50,
            width: maxWidth,
            color: Color(0xFF303D8D),
          ),
        ),
      ],
    );
  }
}
import 'package:church_of_christ/model/changelog_model.dart';
import 'package:church_of_christ/provider/provider_widget.dart';
import 'package:church_of_christ/provider/view_state_widget.dart';
import 'package:church_of_christ/ui/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

/// This screen loads the [CHANGELOG.md] file from GitHub,
/// and displays its content, using the Markdown plugin.

class ChangelogList extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {    
    return Scaffold( 
      body: SafeArea( 
        child: Column(children: <Widget>[
          AppBarCarrousel(title: "Lista de cambios"),                    
          Expanded( 
            child:ProviderWidget<ChangelogModel>(            
              onModelReady: (model) async{
                await model.initData();
              },
              model: ChangelogModel(),
              builder: (context, model,child){
                if (model.busy) {
                  return ViewStateBusyWidget();
                } 
                else if (model.error && model.list.isEmpty) {
                  return ViewStateErrorWidget(
                      error: model.viewStateError,
                      onPressed: model.initData);
                }
                else if(model.idle){
                  return RefreshIndicator(                    
                    onRefresh: () async{
                      await model.refresh();
                      model.showErrorMessage(context);
                    },
                    child: Markdown( 
                      data: model.list["data"], 
                      onTapLink: (url) async => await FlutterWebBrowser.openWebPage( 
                        url:url, 
                        androidToolbarColor: Theme.of(context).primaryColor,
                      ),
                      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith( 
                        blockSpacing: 12, 
                        h2: TextStyle( 
                          fontSize: 17, 
                          fontWeight: FontWeight.bold, 
                          color: Theme.of(context).textTheme.headline6.color, 
                          fontFamily: "ProductSans", 
                        ), 
                        p: TextStyle( 
                          fontSize: 15, 
                          color: Theme.of(context).textTheme.caption.color,
                        )
                      ),
                    ),
                  );                                    
                }
                else{
                  return ViewStateBusyWidget();
                }                
              },             
            ),
          ),
        ]),        
      ),
    );
  }
}

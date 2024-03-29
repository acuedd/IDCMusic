
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_of_christ/service/authenticate.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserLibrary extends StatefulWidget{
  
  final bool login; 

   UserLibrary({this.login});

  @override
  _UserLibraryState createState() => _UserLibraryState();
}

class _UserLibraryState extends State<UserLibrary> {

  @override
  void initState() {
  
  }

  @override
  Widget build(BuildContext context) {

    if(widget.login){
      return userProfile();
    }
    else{
      return loginButton();
    }
  
  }

  Widget loginButton(){
  final user = Provider.of<Authentication>(context);

  return Container(
          child: Center(
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                user.signOut();
                if (await user.signInWithGoogle()){
                  //print("fuck im here");
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/images/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
}
  
  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }

  Widget userProfile(){
    final myUser = Provider.of<Authentication>(context);
    final keyTooltip = GlobalKey<State<Tooltip>>();
    final String strMessage = "Guarda en línea tus canciones favoritas.";

    return  Card(
      color: (Theme.of(context).brightness == Brightness.dark)? Colors.grey[600] : Colors.grey[300],
      elevation: 8.0,
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        height: 100,
        alignment: Alignment.centerLeft,
        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Tooltip(
                  message: strMessage, 
                  child: CircleAvatar( 
                      radius: 40,
                      backgroundImage: Utils.image(myUser.user.photoURL, justprovide:true),
                  ),
                ),                             
                const SizedBox( width: 10,),
                Tooltip(
                  key: keyTooltip,
                  message: strMessage, 
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTap(keyTooltip),
                    child:   Column(
                      crossAxisAlignment: CrossAxisAlignment.end,              
                      children: [
                        Container(
                          child: Text(
                            "Hola ",
                            style: GetTextStyle.LXL(context),
                          ),
                        ),                    
                        Text(
                          "${myUser.user.displayName}" ,
                          style: GetTextStyle.LXL(context),
                        ),
                      ]
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => myUser.signOut(),                   
                  icon: Icon( 
                    Icons.logout
                  )
                ),
              ],
            ),            
          ],
        ),
      ),
    );    
  }
}

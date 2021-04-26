import 'package:church_of_christ/ui/widgets/loader.dart';
import 'package:church_of_christ/utils/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:church_of_christ/provider/view_state.dart';

class ViewStateBusyWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 50.0,),
        Center(child: Text("Cargando..."),),
        Loader(),
      ],
    );
  }
}

class ViewStateWidget extends StatelessWidget{
  final String title;
  final String message;
  final Widget image; 
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  ViewStateWidget({
    Key key, 
    this.image, 
    this.title, 
    this.message, 
    this.buttonText, 
    @required this.onPressed, 
    this.buttonTextData
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.headline6.copyWith(color: Colors.grey);
    var messageStyle = titleStyle.copyWith(color: titleStyle.color.withOpacity(0.7), fontSize: 14);

    return Center(
      child: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image ?? Icon(IconFonts.pageError, size: 80, color: Colors.grey[500]), 
          Padding( 
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column( 
              mainAxisSize: MainAxisSize.max, 
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text( 
                  title ?? 'Load Failed', 
                  style: titleStyle,                
                ), 
                SizedBox(height: 20),
                ConstrainedBox( 
                  constraints: BoxConstraints(maxHeight: 200, minHeight: 150),
                  child: SingleChildScrollView(  
                    child: Text( message ?? '', style: messageStyle),
                  ),
                ), 
              ],
            ),
          ),
          Center(
            child: ViewStateButton(
              child: buttonText,
              textData: buttonTextData,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class ViewStateErrorWidget extends StatelessWidget {
  final ViewStateError error;
  final String title;
  final String message;
  final Widget image;
  final Widget buttonText;
  final String buttonTextData;
  final VoidCallback onPressed;

  const ViewStateErrorWidget({
    Key key,
    @required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var defaultImage;
    var defaultTitle;
    var errorMessage = error.message;
    String defaultTextData = 'Retry';
    switch (error.errorType) {
      case ErrorType.networkError:
        defaultImage = Transform.translate(
          offset: Offset(-50, 0),
          child: const Icon(IconFonts.pageNetworkError,
              size: 100, color: Colors.grey),
        );
        defaultTitle = "Load Failed,Check network ";
        errorMessage = '';
        break;
      case ErrorType.defaultError:
        defaultImage =
            const Icon(IconFonts.pageError, size: 100, color: Colors.grey);
        defaultTitle = "Load Failed";
        break;
    }

    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

class ViewStateEmptyWidget extends StatelessWidget {
  final String message;
  final Widget image;
  final Widget buttonText;
  final VoidCallback onPressed;

  const ViewStateEmptyWidget(
      {Key key,
      this.image,
      this.message,
      this.buttonText,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: this.onPressed,
      image: image ??
          const Icon(IconFonts.pageEmpty, size: 100, color: Colors.grey),
      title: message ?? "Nothing Found",
      buttonText: buttonText,
      buttonTextData: "Refresh",
    );
  }
}

class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final String textData;

  const ViewStateButton({@required this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            textData ?? "Retry",
            style: TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}

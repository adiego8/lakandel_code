import 'package:flutter/material.dart';

class TextFormButton extends StatefulWidget {

  final String labelText;
  final String buttonText;
  final TextEditingController controller;
  final Function buttonAction;

  TextFormButton({Key key, this.labelText, this.buttonText, this.controller, this.buttonAction}) : super(key: key);
  @override
  _TextFormButtonState createState() => _TextFormButtonState();
}

class _TextFormButtonState extends State<TextFormButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.labelText,style: Theme.of(context).textTheme.headline2,),           
        Center(
          child: TextFormField(
            maxLines: null,
            controller: widget.controller,            
          ),
        ),
        FlatButton(
          child: Text(widget.buttonText,style: TextStyle(color: Colors.white,fontSize: 16),),
          color: Colors.grey[850],
          onPressed: widget.buttonAction,
        )
      ],
    );
  }
}
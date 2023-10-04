import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uni_ya/constants/texts.dart';

class DeleteAlert extends StatelessWidget {
   DeleteAlert({required this.actionTitle,required this.title,required this.description,required this.actionColor,Key? key}) : super(key: key);
  String actionTitle,title,description;
  Color actionColor;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: Text(actionTitle,style: TextStyle(color: actionColor)),
          onPressed: () => Navigator.pop(context,true),
        ),
        TextButton(
          child: Text(TextKeys.cancel.tr()),
          onPressed: () => Navigator.pop(context,false),
        ),
      ],
    );
  }
}

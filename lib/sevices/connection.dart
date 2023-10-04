import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uni_ya/constants/texts.dart';


Future<bool> checkConnection(BuildContext context)async{

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;   }

  }  catch (_) {
showDialog(context: context, builder: (context)=>const NoConnectionDialog());
  }
  return false;
}

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(TextKeys.noConnection.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/illustrations/no_connection.svg'),
          SizedBox(height: 8),
          Text(TextKeys.pleaseCheckNetwork.tr()),
        ],
      ),
      actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text(TextKeys.ok.tr()))],
    );
  }
}


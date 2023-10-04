import 'package:flutter/material.dart';
import 'package:uni_ya/features/meals/models/group.dart';
import 'package:uni_ya/ui/widgets/backgruond.dart';

import 'group_body.dart';


class GroupScreen extends StatelessWidget {
   GroupScreen( this.group,{Key? key}) : super(key: key);
Group group;
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      isBlur: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(

          child: GroupBody(group),
        ),
      ),
    );
  }
}

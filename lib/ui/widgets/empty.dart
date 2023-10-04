import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class EmptyScreen extends StatelessWidget {
  const EmptyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //SvgPicture.asset('assets/illustrations/empty_page.svg'),

        ],
      ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: SpinKitCubeGrid(
          itemBuilder: (BuildContext context, int index) {
            Color color=Theme.of(context).secondaryHeaderColor;
            return DecoratedBox(
              decoration: BoxDecoration(
                color
                    : [2].contains(index) ? color
                    : [1,5].contains(index) ? color.withOpacity(0.8)
                    : [0, 4, 8].contains(index) ? color.withOpacity(0.6)
                    : [3, 7].contains(index) ? color.withOpacity(0.4)
                    : color.withOpacity(0.2),
              ),
            );
          },
          // color: Colors.white,
          size: MediaQuery.of(context).size.width * 0.3,
        ));
  }
}

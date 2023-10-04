import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MyDrawerCubit extends Cubit<bool> {
  MyDrawerCubit() : super(false);
  final ZoomDrawerController controller = ZoomDrawerController();

  toggle() {
    controller.toggle!.call();
    emit(!state);
  }
}

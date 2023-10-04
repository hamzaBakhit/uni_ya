import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/sevices/local/local_service.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState(isLight: true, isNotification: true,isIntroFinished: false)) {
    _getStoredSettings();
    getIsIntroFinished();
    on<ChangeSettingsIsLight>(_changeIsLight);
    on<ChangeSettingsNotification>(_changeNotification);
    on<FinishIntro>(_finishIntro);
  }

  _getStoredSettings()async {
    Map<String,dynamic> map=await LocalService.get.getSettings();
    emit(SettingsState(isLight: map['isLight'], isNotification: map['isNotification'],isIntroFinished: state.isIntroFinished));
  }
  Future<bool> getIsIntroFinished()async {
    bool isDone=await LocalService.get.getLocalData('isIntroFinished')??false;
    if(isDone==true){
      emit(SettingsState(isLight: state.isLight, isNotification: state.isNotification,isIntroFinished:true));
    }
    return isDone;
  }

  _changeIsLight(ChangeSettingsIsLight event, Emitter<SettingsState> emit) {
    LocalService.get.setLocalData({
      'isLight':event.isLight
    });
    emit(SettingsState(
        isLight: event.isLight, isNotification: state.isNotification,isIntroFinished: state.isIntroFinished));
  }

  _changeNotification(
      ChangeSettingsNotification event, Emitter<SettingsState> emit) {
    LocalService.get.setLocalData({
      'isNotification':event.isWork
    });
    emit(SettingsState(isLight: state.isLight, isNotification: event.isWork,isIntroFinished: state.isIntroFinished));
  }
  _finishIntro(
      FinishIntro event, Emitter<SettingsState> emit) {
    LocalService.get.setLocalData({
      'isIntroFinished':true
    });
    emit(SettingsState(isLight: state.isLight, isNotification: state.isNotification,isIntroFinished: true));
  }
}

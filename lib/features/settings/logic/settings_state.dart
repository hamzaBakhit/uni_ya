part of'settings_bloc.dart';

 class SettingsState extends Equatable{
  bool isLight;
  bool isNotification;
  bool isIntroFinished;

  SettingsState({required this.isLight,required this.isNotification,required this.isIntroFinished});

  @override
  List<Object?> get props => [isLight,isNotification,isIntroFinished];
}


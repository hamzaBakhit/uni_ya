part of'settings_bloc.dart';

abstract class SettingsEvent {
  }
  class ChangeSettingsIsLight extends SettingsEvent{
  bool isLight;
  ChangeSettingsIsLight(this.isLight);
}
class ChangeSettingsNotification extends SettingsEvent{
  bool isWork;
  ChangeSettingsNotification(this.isWork);
}class FinishIntro extends SettingsEvent{

}

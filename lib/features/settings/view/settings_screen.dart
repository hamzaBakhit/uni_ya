import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uni_ya/constants/texts.dart';
import 'package:uni_ya/features/settings/logic/settings_bloc.dart';
import 'package:uni_ya/ui/widgets/backgruond.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(TextKeys.settings.tr()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                      value: state.isLight,
                      title: Text(TextKeys.lightTheme.tr()),
                      onChanged: (value) => context
                          .read<SettingsBloc>()
                          .add(ChangeSettingsIsLight(value))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SwitchListTile(
                      value: state.isNotification,
                      title: Text(TextKeys.notification.tr()),
                      onChanged: (value) => context
                          .read<SettingsBloc>()
                          .add(ChangeSettingsNotification(value))),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

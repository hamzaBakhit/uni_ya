import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'material_config.dart';


class LocalizationConfig extends StatelessWidget {
  const LocalizationConfig({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      saveLocale: true,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en')],
      path: 'assets/translations',
      child: const MaterialConfig(),
    );
  }
}

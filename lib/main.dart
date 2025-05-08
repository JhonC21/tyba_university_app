import 'package:flutter/material.dart';
import 'package:tyba_university_app/core/router/router.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with RouterMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
      // title: 'Pideky Seller Center',
      routerConfig: router,
      locale: const Locale('es'),
    );
  }
}

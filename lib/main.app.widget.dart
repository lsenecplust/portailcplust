import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:portail_canalplustelecom_mobile/class/theme.config.dart';
import 'package:portail_canalplustelecom_mobile/rootcontainer.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:portail_canalplustelecom_mobile/widgets/somethingwentwrong.dart';

import 'auth.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return MaterialApp(
      title: 'Portail C+T',
      debugShowCheckedModeBanner: false,
      supportedLocales: const <Locale>[
        Locale('fr'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      theme: CustomTheme.light.theme,
      home: SplashScreen.navigate(
        fit: BoxFit.contain,
        name: 'assets/rives/logo.riv',
        next: (context) => const Auth(
          errorWidget: SomethingWenWrong(msg: "Erreur Auth"),
          child: RootContainer(),
        ),
        isLoading: true,
        backgroundColor: Colors.white,
        startAnimation: "Splash",
      ),
    );
  }
}

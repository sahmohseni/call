import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shomare_yab/di.dart';

import 'package:shomare_yab/home.dart';
import 'package:shomare_yab/true_caller_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  appInjector();
  FlutterForegroundTask.initCommunicationPort();

  runApp(const MyApp());
}

@pragma("vm:entry-point")
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  appInjector();
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: TrueCallerOverlay()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('fa', 'IR')],
      home: HomeScreen(),
    );
  }
}

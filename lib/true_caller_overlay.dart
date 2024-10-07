import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shomare_yab/storage.dart';
import 'package:shomare_yab/text_styles.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({Key? key}) : super(key: key);

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  StreamSubscription? _sub;
  bool isGold = true;
  String mobileNumber = "";
  final _goldColors = const [
    Color(0xFFa2790d),
    Color(0xFFebd197),
    Color(0xFFa2790d),
  ];

  final _silverColors = const [
    Color(0xFFAEB2B8),
    Color(0xFFC7C9CB),
    Color.fromARGB(255, 53, 53, 56),
    Color(0xFFAEB2B8),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        child: Container(
            margin: const EdgeInsets.only(right: 24.0, left: 24.0),
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 9, 85, 146),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "شماره تلفن کاربر",
                        style: AppTextStyles.title,
                      ),
                      Text(
                        mobileNumber,
                        style: AppTextStyles.title,
                      ),
                      ValueListenableBuilder(
                        valueListenable:
                            LocalDataBase.incomingMobileNumberNotifier,
                        builder: (context, value, child) {
                          return Text(value);
                        },
                      )
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

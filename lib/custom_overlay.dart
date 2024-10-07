import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shomare_yab/text_styles.dart';
import 'package:system_alert_window/system_alert_window.dart';

class CustomOverlay extends StatefulWidget {
  @override
  State<CustomOverlay> createState() => _CustomOverlayState();
}

class _CustomOverlayState extends State<CustomOverlay> {
  static const String _mainAppPort = 'MainApp';
  SendPort? mainAppPort;
  bool update = false;
  String mobileNumber = "000";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemAlertWindow.overlayListener.listen((event) {
      log("$event in overlay");
      if (event is bool) {
        setState(() {
          update = event;
        });
      } else if (event is String) {
        setState(() {
          mobileNumber = event;
        });
      }
    });
  }

  void callBackFunction(String tag) {
    print("Got tag " + tag);
    mainAppPort ??= IsolateNameServer.lookupPortByName(
      _mainAppPort,
    );
    mainAppPort?.send('Date: ${DateTime.now()}');
    mainAppPort?.send(tag);
  }

  Widget overlay() {
    return Container(
      margin: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), color: Colors.blue),
      child: Material(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.phone,
                color: Colors.white,
                size: 42.0,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    mobileNumber,
                    style: AppTextStyles.title,
                  )
                ],
              ),
              Text(
                "تماس ورودی",
                style: AppTextStyles.title,
              ),
              SizedBox(
                height: 16.0,
              ),
              Divider(
                color: Colors.white,
              ),
              TextButton(
                  onPressed: () {
                    callBackFunction("Close");
                    SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
                  },
                  child: Text(
                    "بستن",
                    style: AppTextStyles.title,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  @override
  Widget build(BuildContext context) {
    return overlay();
    // return Scaffold(
    //   body: overlay(),
    // );
  }
}

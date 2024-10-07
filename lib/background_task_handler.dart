import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:phone_state/phone_state.dart';
import 'package:shomare_yab/di.dart';
import 'package:shomare_yab/storage.dart';

class PhoneStateTaskHandler extends TaskHandler {
  @override
  Future<void> onDestroy(DateTime timestamp) {
    // TODO: implement onDestroy
    throw UnimplementedError();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // TODO: implement onRepeatEvent
  }

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    appInjector();
    setStream();
  }
}

void setStream() {
  PhoneState.stream.listen((event) async {
    if (event.number != null && event.status.name == "CALL_INCOMING") {
      await getIt<LocalDataBase>().savingIncominMobileNumber(event.number!);
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        overlayTitle: "X-SLAYER",
        overlayContent: 'Overlay Enabled',
        flag: OverlayFlag.defaultFlag,
        positionGravity: PositionGravity.auto,
        height: 300,
      );
    }
  });
}

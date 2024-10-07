import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:phone_state/phone_state.dart';

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
    setStream();
  }
}

void setStream() {
  PhoneState.stream.listen((event) async {
    print(event);
    if (event.number != null) {
      await FlutterOverlayWindow.shareData(event.number);
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        overlayTitle: "X-SLAYER",
        overlayContent: 'Overlay Enabled',
        flag: OverlayFlag.defaultFlag,
        positionGravity: PositionGravity.auto,
        height: 300,
        width: WindowSize.matchParent,
        startPosition: const OverlayPosition(0, -259),
      );
    }
  });
}

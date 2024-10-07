import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shomare_yab/background_task_handler.dart';

@pragma('vm:entry-point')
void startCallBack() {
  FlutterForegroundTask.setTaskHandler(PhoneStateTaskHandler());
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

Future<ServiceRequestResult> _startService() async {
  if (await FlutterForegroundTask.isRunningService) {
    return FlutterForegroundTask.restartService();
  } else {
    return FlutterForegroundTask.startService(
      serviceId: 256,
      notificationTitle: 'Foreground Service is running',
      notificationText: 'Tap to return to the app',
      notificationIcon: null,
      notificationButtons: [
        const NotificationButton(id: 'btn_hello', text: 'hello'),
      ],
      callback: startCallBack,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  bool isPhonePermissionGranted = false;

  Future<void> checkPermissions() async {
    PermissionStatus phonePermissionStatus = await Permission.phone.status;
    PermissionStatus notifPermissionStatus =
        await Permission.notification.status;
    PermissionStatus alertWindowPermissionStatus =
        await Permission.notification.status;

    if (phonePermissionStatus.isGranted) {
      if (notifPermissionStatus.isGranted) {
        if (await FlutterForegroundTask.canDrawOverlays == true) {
          _initService();
          setState(() {
            isPhonePermissionGranted = phonePermissionStatus.isGranted;
          });
        } else {
          await FlutterForegroundTask.openSystemAlertWindowSettings();
        }
      }
      {
        _requestNotifPermission();
      }
    } else {
      _requestPhonePermission();
    }
  }

  Future _requestPhonePermission() async {
    await Permission.phone.request();
  }

  Future _requestNotifPermission() async {
    await Permission.notification.request();
  }

  Future _requestAlertWindowPermission() async {
    await Permission.systemAlertWindow.request();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    checkPermissions();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _initService() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        showWhen: false,
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("دسترسی مدیریت تماس"),
                Text(isPhonePermissionGranted ? "فعال" : "غیر فعال")
              ],
            ),
            SizedBox(
              height: 24,
            ),
            ElevatedButton(onPressed: _startService, child: Text("start"))
          ],
        ),
      ),
    ));
  }
}

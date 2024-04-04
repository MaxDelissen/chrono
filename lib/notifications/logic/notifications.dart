import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:clock_app/notifications/data/notification_channel.dart';

Future<void> initializeNotifications() async {
  AwesomeNotifications().isNotificationAllowed().then((allowed) {
    if (!allowed) {
      AwesomeNotifications().requestPermissionToSendNotifications(
        permissions: [
          // NotificationPermission.Sound,
          NotificationPermission.Alert,
          NotificationPermission.FullScreenIntent,
        ],
      );
    }
  });

  await AwesomeNotifications().initialize(
    null, // use default app icon
    [
      alarmNotificationChannel,
      reminderNotificationChannel,
      stopwatchNotificationChannel,
      timerNotificationChannel
    ],
    // channelGroups: [alarmNotificationChannelGroup],
    debug: false,
  );
}

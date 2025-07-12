import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> scheduleWarrantyNotification({
    required int id,
    required String deviceName,
    required DateTime warrantyEndDate,
  }) async {
    final scheduledDate = warrantyEndDate.subtract(const Duration(days: 7));
    if (scheduledDate.isBefore(DateTime.now())) return;
    await _notificationsPlugin.zonedSchedule(
      id,
      'Garanti Bitiş Uyarısı',
      '$deviceName cihazınızın garantisi 7 gün sonra bitiyor!',
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'warranty_channel',
          'Garanti Bildirimleri',
          channelDescription: 'Garanti bitişine yakın bildirimler',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}

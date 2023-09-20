

import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'models/event.dart';

class NotificationScheduler {

  NotificationScheduler._privateConstructor();

  static final NotificationScheduler _instance = NotificationScheduler._privateConstructor();

  static NotificationScheduler get instance => _instance;

  final Duration reminderBeforeEvent = const Duration(minutes: 30);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  Future<void> addReminderForEvent(Event event) async {
    final DateTime reminderTime = event.startTime.subtract(reminderBeforeEvent);

    if(DateTime.now().isBefore(reminderTime) ){
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
          'SocsChatMessageReceived',
          'Event Notification',
          importance: Importance.max,
          priority: Priority.high,
          color:Colors.black
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: null,
      );


      final location = tz.getLocation("Europe/London");

      await flutterLocalNotificationsPlugin.zonedSchedule(
        event.id.hashCode, // Notification ID (can be any unique number)
        event.title,
        'Reminder: Event is starting in 30 minutes',
        tz.TZDateTime.from(reminderTime, location), // Schedule time
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
  void removeReminderForEvent(Event event) => flutterLocalNotificationsPlugin.cancel(event.id.hashCode);




}


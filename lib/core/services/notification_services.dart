import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_app/models/task.dart';
import 'package:intl/intl.dart';

import 'package:to_do_app/view/pages/notification_screen.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotifyHelper {
  late AndroidInitializationSettings androidSettings;
  late DarwinInitializationSettings iosSettins;
  late AndroidNotificationDetails androidNotificationDetails;
  late DarwinNotificationDetails iosNotificationDetails;
  late NotificationDetails notificationDetails;

  void initialize() async {
    // android initialization settings
    androidSettings = AndroidInitializationSettings('drawable/appicon');

    // ios initialization settins
    iosSettins = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    //time zone for schedule notification
    tz.initializeTimeZones();
    final timeZone = DateTime.now().timeZoneName.toString();
    tz.setLocalLocation(tz.getLocation(timeZone));

    // initialization settings
    InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettins);

    bool? initialize = await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  // request permissions for ios platform
  requestPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(sound: true, badge: true, alert: true);
  }

  // call this funcation for older ios version
  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text(body!));
  }

  // call this when notification response
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    await Get.to(
      NotificationScreen(
        task: Task(
          title: payload!.split('|')[0],
          endDate: payload.split('|')[1],
          note: payload.split('|')[2],
          isCompleted: int.parse(
            payload.split('|')[3],
          ),
        ),
        fromNotify: true,
      ),
    );
  }

  // display notification
  void showNotification(Task task) async {
    // android notificatin details init
    androidNotificationDetails = AndroidNotificationDetails(
        'todo-remind', 'Todo',
        priority: Priority.max, importance: Importance.max);

    // ios notification details init
    iosNotificationDetails = DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    // notification details init
    notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // display normal notification
    await flutterLocalNotificationsPlugin.show(
      task.getId!,
      task.getTitle,
      task.getNote,
      notificationDetails,
      payload:
          '${task.getTitle}|${task.getEndDate}|${task.getNote}|${task.getNote}',
    );
  }

  cancelNotificatin(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.getId!);
  }

  cancelAllNotificatin() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // display schedule notification
  void showScheduleNotification(Task task) async {
    // android notification details init
    androidNotificationDetails = AndroidNotificationDetails(
        'todo-remind', 'Todo',
        priority: Priority.max, importance: Importance.max);

    // ios notification details init
    iosNotificationDetails = DarwinNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);

    // notification details init
    notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // display notification with schedule
    await flutterLocalNotificationsPlugin.zonedSchedule(task.getId!,
        task.getTitle, task.getNote, dateConfig(task), notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload:
            '${task.getTitle}|${task.getEndDate}|${task.getNote}|${task.getIsCompleted}');
  }

  dateConfig(Task task) {
    tz.TZDateTime date = tz.TZDateTime.from(
        DateFormat('yyyy-MM-dd hh:mm a').parse(task.getEndDate), tz.local);
    log('scheduleDate: $date');

    if (date.isBefore(tz.TZDateTime.now(tz.local))) {
      log('isbefore: $date');
      if (task.getRepeat == Repeat.Daily) {
        date = date = tz.TZDateTime(tz.local, date.year, date.month,
            (date.day) + 1, date.hour, date.minute, date.second);
        log('daily: $date');
      } else if (task.getRepeat == Repeat.Weekly) {
        date = date = tz.TZDateTime(tz.local, date.year, date.month,
            (date.day) + 7, date.hour, date.minute, date.second);
        log('weekly: $date');
      } else if (task.getRepeat == Repeat.Monthly) {
        date = date = tz.TZDateTime(tz.local, date.year, (date.month) + 1,
            date.day, date.hour, date.minute, date.second);
        log('monthly: $date');
      }
    }
    log('fd scheduleDate: $date');
    date = date.subtract(Duration(minutes: task.getRemind));
    log('after subtract: $date');

    cancelNotificatin(task);

    return date;
  }
}

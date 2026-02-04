import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:efood_multivendor/controller/auth_controller.dart';
import 'package:efood_multivendor/controller/chat_controller.dart';
import 'package:efood_multivendor/controller/notification_controller.dart';
import 'package:efood_multivendor/controller/order_controller.dart';
import 'package:efood_multivendor/data/model/body/notification_body.dart';
import 'package:efood_multivendor/helper/route_helper.dart';
import 'package:efood_multivendor/helper/user_type.dart';
import 'package:efood_multivendor/util/app_constants.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('notification_icon');
    const iosInit = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    // Request notification permission (Android 13+)
    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }

    // iOS permission
    await FirebaseMessaging.instance.requestPermission();

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        _handleNotificationTap(response.payload);
      },
    );

    // Handle when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message, flutterLocalNotificationsPlugin, false);
    });

    // Handle when app is opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(jsonEncode(message.data));
    });

    // For terminated state
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(jsonEncode(initialMessage.data));
    }
  }

  static void _handleNotificationTap(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      try {
        final NotificationBody body = NotificationBody.fromJson(jsonDecode(payload));
        if (body.notificationType == NotificationType.order) {
          Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(body.orderId.toString())));
        } else if (body.notificationType == NotificationType.general) {
          Get.toNamed(RouteHelper.getNotificationRoute(fromNotification: true));
        } else {
          Get.toNamed(RouteHelper.getChatRoute(notificationBody: body, conversationID: body.conversationId!));
        }
      } catch (_) {}
    }
  }

  static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
    String? title = data ? message.data['title'] : message.notification?.title;
    String? body = data ? message.data['body'] : message.notification?.body;
    String? orderId = message.data['order_id'] ?? message.notification?.titleLocKey;
    String? image;
    NotificationBody notifBody = convertNotification(message.data);

    if (!data) {
      final androidImage = message.notification?.android?.imageUrl;
      final iosImage = message.notification?.apple?.imageUrl;
      image = androidImage ?? iosImage;
    } else {
      image = message.data['image'];
    }

    if (image != null && image.isNotEmpty) {
      if (!image.startsWith('http')) {
        image = '${AppConstants.BASE_URL}/storage/app/public/notification/$image';
      }
      try {
        await showBigPictureNotificationHiddenLargeIcon(title!, body!, orderId!, notifBody, image, fln);
      } catch (_) {
        await showBigTextNotification(title!, body!, orderId!, notifBody, fln);
      }
    } else {
      await showBigTextNotification(title!, body!, orderId!, notifBody, fln);
    }
  }

  static Future<void> showBigTextNotification(String title, String body, String orderId, NotificationBody notifBody, FlutterLocalNotificationsPlugin fln) async {
    final androidDetails = AndroidNotificationDetails(
      'stackfood', 'stackfood',
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: BigTextStyleInformation(body),
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    final details = NotificationDetails(android: androidDetails);
    await fln.show(0, title, body, details, payload: jsonEncode(notifBody.toJson()));
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(String title, String body, String orderId, NotificationBody notifBody, String imageUrl, FlutterLocalNotificationsPlugin fln) async {
    final largeIconPath = await _downloadAndSaveFile(imageUrl, 'largeIcon');
    final bigPicturePath = await _downloadAndSaveFile(imageUrl, 'bigPicture');

    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      contentTitle: title,
      summaryText: body,
      hideExpandedLargeIcon: true,
    );

    final androidDetails = AndroidNotificationDetails(
      'stackfood', 'stackfood',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      styleInformation: styleInformation,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    final details = NotificationDetails(android: androidDetails);
    await fln.show(0, title, body, details, payload: jsonEncode(notifBody.toJson()));
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  static NotificationBody convertNotification(Map<String, dynamic> data) {
    if (data['type'] == 'general') {
      return NotificationBody(notificationType: NotificationType.general);
    } else if (data['type'] == 'order_status') {
      return NotificationBody(notificationType: NotificationType.order, orderId: int.parse(data['order_id']));
    } else {
      return NotificationBody(
        notificationType: NotificationType.message,
        conversationId: int.parse(data['conversation_id']),
        deliverymanId: data['sender_type'] == 'delivery_man' ? 0 : null,
        adminId: data['sender_type'] == 'admin' ? 0 : null,
        restaurantId: data['sender_type'] == 'vendor' ? 0 : null,
      );
    }
  }
}

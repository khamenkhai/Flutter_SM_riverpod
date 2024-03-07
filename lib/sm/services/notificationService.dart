import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sm_project/sm/utils/consts.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/post/viewPostScreen.dart';

final notiServiceController = Provider((ref) => NotificationsService());

const channel = AndroidNotificationChannel(
    'high_importance_channel', 'Hign Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

class NotificationsService {
  static const key =
      'AAAAFGnTYf0:APA91bGWG6iz5tAl4dfvIzRptQRSXk5SEwV5Ffd6OZDYiuXOvlFCmXnt6ubM5CDGLyobKZiIo7aCpwI49i_QZ05zX3CqDEhtzAJBZiDzvo0y-RiQk_N67bUKoV8RugI9pCimQwJWtONG';

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void _initLocalNotification() {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
//       onDidReceiveNotificationResponse: (response) {
//         debugPrint("_______________________________________________" +
//             response.payload.toString()+"_______________________");
//       },
//       onDidReceiveBackgroundNotificationResponse: (response){
// debugPrint("=====================================" +
//             response.payload.toString()+"=====================================");
//       }
    );
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final styleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title,
      htmlFormatTitle: true,
    );
    final androidDetails = AndroidNotificationDetails(
      'com.example.chat_app.urgent',
      'mychannelid',
      importance: Importance.max,
      styleInformation: styleInformation,
      priority: Priority.max,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
        message.notification!.body, notificationDetails,
        payload: message.data['body']);
  }

  Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  Future<void> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    _saveToken(token!);
  }

  Future<void> _saveToken(String token) async =>
      await FirebaseFirestore.instance
          .collection(Constants.usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'deviceToken': token});

  String receiverToken = '';

  // Future<void> getReceiverToken(String? receiverId) async {
  //   final getToken = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(receiverId)
  //       .get();

  //   receiverToken = await getToken.data()!['token'];
  // }

  Future<void> firebaseNotification(context) async{
    _initLocalNotification();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("on message opened app${message.notification!.title}\n");

       final Map<String, dynamic> data = message.data;
      if (data.containsKey('postId')) {
       final String postId = data['postId'];
          print('Received postId: $postId');
          await navigatorPush(context, ViewPostScreen(postId: postId));
      }
      // await Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (_) => Scaffold(
      //             appBar: AppBar(
      //               title: Text("testing"),
      //             ),
      //           )),
      // );
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print(
          "on message - ${message.notification!.title},message body :  ${message.notification!.body}\n");

      await _showLocalNotification(message);
    });
  }

  Future<void> sendNotification(
      {required String body,
      required String senderId,
      required String receiverTokenId,
      required String postId}) async {
    try {
      print("trying to send noti");
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$key',
        },
        body: jsonEncode(<String, dynamic>{
          "to": receiverTokenId,
          'priority': 'high',
          'notification': <String, dynamic>{
            'body': body,
            'title': 'New Message !',
          },
          'data': <String, String>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done',
            'senderId': senderId,
            'postId': postId,
          }
        }),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

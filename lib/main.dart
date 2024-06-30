import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/firebase_options.dart';
import 'package:sm_project/services/notificationService.dart';
import 'package:easy_localization/easy_localization.dart';

///this code is for initializing firebase messaging
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', ''), Locale('my', '')],
      path: 'assets/translations',
      startLocale: Locale('en'),
      fallbackLocale: Locale('en'),
      child: ProviderScope(child: SMapp())));
}

//*******************************************/
class SMapp extends ConsumerStatefulWidget {
  const SMapp({super.key});

  @override
  ConsumerState<SMapp> createState() => _SMappState();
}

class _SMappState extends ConsumerState<SMapp> {
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      //theme: ref.watch(themeControllerProvider),
      theme: ThemeData(useMaterial3: false),
      home: Home(),
      // home: ref.watch(authStateProvider).when(data: (data) {

      //   if (data != null) {
      //     currentUserId = data.uid;
      //     ref.read(userControllerProvider.notifier).getCurrentUser();
      //     return MainScreen();
      //   } else {
      //     return LoginScreen();
      //   }
      // }, error: (error, s) {
      //   return errorWidget(error.toString() + "error");
      // }, loading: () {
      //   return loadingWidget();
      // }),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NotificationsService notificationsService = NotificationsService();
  
  TextEditingController _titleController = TextEditingController();
  
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    notificationsService.getToken();
    notificationsService.requestPermission();
    notificationsService.firebaseNotification(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Test"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Title"
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Message"
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    String token = await notificationsService.getToken();
                    print("token key : ${token}");
                    await notificationsService.sendNotification(
                      body: "Hello world",
                      title: _titleController.text,
                      receivertoken: token,
                      message: _messageController.text,
                    );
                  },
                  child: Text("Test Noti")),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

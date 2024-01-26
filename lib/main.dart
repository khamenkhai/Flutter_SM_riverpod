import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/authController.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/firebase_options.dart';
import 'package:sm_project/sm/services/notificationService.dart';
import 'package:sm_project/sm/utils/theme.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/mainScreen.dart';
import 'sm/view/authScreens/loginScreen.dart';
import 'package:easy_localization/easy_localization.dart';

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
    Future.delayed(Duration.zero, () {
      initThemeData();
    });
    super.initState();
  }

  initThemeData() {
    ref.watch(themeControllerProvider.notifier).getCurrentTheme();
  }

  NotificationsService notificationsService = NotificationsService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ref.watch(themeControllerProvider),
      home: ref.watch(authStateProvider).when(data: (data) {
        if (data != null) {
          
          currentUserId = data.uid;
          ref.read(userControllerProvider.notifier).getCurrentUser();
          return MainScreen();
        } else {
          return LoginScreen();
        }
      }, error: (error, s) {
        return errorWidget(error.toString() + "error");
      }, loading: () {
        return loadingWidget();
      }),
    );
  }
}

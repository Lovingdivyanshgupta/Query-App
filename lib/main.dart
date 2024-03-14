import 'package:code_query_app/preferences/my_shared_preferences.dart';
import 'package:code_query_app/screens/category_screen.dart';
import 'package:code_query_app/screens/login_screen.dart';
import 'package:code_query_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:code_query_app/modal/global_modal.dart' as globals;
import 'modal/color_modal.dart';
import 'notification/fcm_notification.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    '@high_importance_channel', // id
    '@ High Importance Notifications', // title
    description: '@ This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      sound: true, badge: true, alert: true);
  await FirebaseMessaging.instance
      .requestPermission(sound: true, badge: true, alert: true);

  await MyFcmNotification.getToken();
  // await SharedPreferences.getInstance();
  var userLogin = await MySharedPreferences.getUserDefault('userLogin');
  globals.isLogin = false;
  try {
    globals.isLogin = userLogin!;
    // print('---------- globals.isLogin : ${globals.isLogin}');
  } catch (e) {
    // print('null globals.isLogin');
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String? profileName ;
  @override
  void initState() {
    super.initState();
    // MyNotificationListen().getNotificationListenData(navigatorKey.currentState?.context ?? context);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: MyColorsModal.kThemeColor,
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: MyColorsModal.kThemeColor,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreenRepo.id,
      routes: {
        SplashScreenRepo.id: (context) => const SplashScreenRepo(),
        CategoryScreen.id: (context) => const CategoryScreen(),
        LoginPage.id: (context) => const LoginPage(),
      },
      // home: (globals.isLogin) ? const CategoryScreen() : const LoginPage(),
    );
  }
}
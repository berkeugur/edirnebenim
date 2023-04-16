import 'package:edirnebenim/Authentication/auth_service.dart';
import 'package:edirnebenim/FirebaseMessaging/messaging.dart';
import 'package:edirnebenim/Notification/notification_pagination.dart';

import 'package:edirnebenim/Trade/trade_setup.dart';
import 'package:edirnebenim/locator.dart';

import 'package:edirnebenim/utilities/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  AuthService.user = FirebaseAuth.instance.currentUser;

  setupLocator();

  await tradeSetuo();
  await NotificationPaginationService().getInitialTrades();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthService().handleAuth(),
    );
  }
}

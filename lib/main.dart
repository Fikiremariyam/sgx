import 'package:flutter/material.dart';
import 'package:sgx/services/ThemeData.dart';
import 'package:provider/provider.dart';
import 'package:sgx/myapp.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // Get the token
    String? token = await messaging.getToken();
    print("FCM Token: $token");

  runApp(
    
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

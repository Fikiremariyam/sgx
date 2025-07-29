import 'package:flutter/material.dart';
import 'package:sgx/Auth/loginPage.dart';
import 'package:sgx/pages/onboarding.dart';
import 'package:sgx/pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgx/services/ThemeData.dart';
import 'package:provider/provider.dart';
import 'package:sgx/Auth/auth_functions.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = "/Onboarding";

  Future<void> _checkFirstSeenAndHandle() async {
    bool checkbool = await checkFirstSeen();

    if (checkbool == true) {
      setState(() {
        initialRoute = "/login";
      });
    } else {
      // Do something else if it's not the first time
    }
  }

  Future<bool> checkFirstSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('seen') ?? false;
    return !isFirstTime;
  }

  @override
  void initState() {
    super.initState();
    _checkFirstSeenAndHandle();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      routes: {
        '/Onboarding': (context) => onboardingFutureBuilder,
        '/login': (context) {
          return FutureBuilder<String?>(
            //future builder to check if user is logged in else to log in
            future: getUserId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                SharedPreferences.getInstance().then((prefs) {
                  print(prefs.getKeys().fold<Map<String, dynamic>>({},
                      (map, key) {
                    map[key] = prefs.get(key);
                    return map;
                  }));
                });
                return MyHomePage(title: 'SGX WALLET');
              } else {
                return Loginpage();
              }
            },
          );
        },
      },
    );
  }
}

// Assign the FutureBuilder to a variable
final Widget onboardingFutureBuilder = FutureBuilder<bool>(
  future: SharedPreferences.getInstance().then((prefs) {
    final isFirstTime = prefs.getBool('seen') ?? false;
    return !isFirstTime;
  }),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.data == true) {
        return OnboardingScreen();
      } else {
        // Not first time, navigate to login page
        Future.microtask(() {
          Navigator.of(context).pushReplacementNamed('/login');
        });
        return const SizedBox.shrink();
      }
    }
    return const Center(child: CircularProgressIndicator());
  },
);

import 'package:flutter/material.dart';
import 'package:sgx/Auth/auth_functions.dart';

import 'package:provider/provider.dart';
import 'package:sgx/services/ThemeData.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  // authntication logic

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Switch(
              value: isDark,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center the "Welcome back!" text
                Center(
                  child: Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  decoration: InputDecoration(
                    labelText: 'user name',
                    labelStyle: TextStyle(color: Colors.green),
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green
                        width: 3,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(2, 13, 208, 10),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.green),
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      borderSide: BorderSide(
                        color: Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withAlpha(150),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => logUserIn(
                      context,
                      emailController.text.trim(),
                      passwordController.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor ??
                            const Color.fromARGB(0, 255, 0, 0), // green,
                    minimumSize: Size(double.infinity, 50),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: Text('Login',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

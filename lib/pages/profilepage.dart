import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sgx/pages/profiledetails.dart';
import 'package:sgx/services/ThemeData.dart';
import 'package:sgx/Auth/auth_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgx/pages/paymentHistory.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var role = TextEditingController();
  var phonenumber = TextEditingController();
  final name = TextEditingController();

  @override
  void initState() {
    super.initState();
    setuserInfo();
  }

  void setuserInfo() async {
    final prefs = await SharedPreferences.getInstance();

    // Loop through each key and print the value
    print("=========Data from shared preferences profile details  87=========");
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      final value = prefs.get(key);
      print('$key: $value');
    }
    print(keys.length);
    setState(() {
      name.text = prefs.getString('FirstName') ?? 'Woldeab Tesfamariam';
      role.text = prefs.getString('user_id') ?? 'no email';
      phonenumber.text = prefs.getString('phonenumber') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //--------------------------------------

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          /*
          IconButton(
            icon:  Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {},
          ),*/
        ],
      ),
      //------------------------------
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(93, 196, 188, 188),
                    child: Icon(Icons.person_outline,
                        color: Theme.of(context).colorScheme.onSecondary,
                        size: 40),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.text,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              role.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'General',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            //----------------account information
            _buildMenuItem(
                icon: Icons.person_outline,
                iconColor: Colors.blue,
                title: 'Account Information',
                subtitle: 'Change your account information',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountDetailsPage()));
                }),
           /*
            // ----------Book marks -----
            _buildMenuItem(
              icon: Icons.bookmark_outline,
              iconColor: Colors.red,
              title: 'Bookmarks',
              subtitle: 'Your bookmarked article and product',
            ),


            //---------order and payment history
            _buildMenuItem(
                icon: Icons.payment_outlined,
                iconColor: Colors.purple,
                title: 'Order & Payment History',
                subtitle: 'See your  payment info',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountInformationCenter()));
                }),
            */
            // -------account setings
            _buildMenuItem(
                icon: Icons.help_outline,
                iconColor: Colors.blue[900]!,
                title: 'Help',
                subtitle: 'Get 24/7 support',
                onTap: () {}),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: isDark,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 52, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    logUserOut(context);
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // getting profile pic

  void setUsercred() async {}
  // to get user data

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ));
  }
}

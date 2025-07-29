import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgx/Models/Transactions.dart';

Future<void> logUserIn(
    BuildContext context, String username, String password) async {
  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all fields')),
    );
    return;
  }
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );

  final response = await http.post(
    Uri.parse('https://payments.sgxmobility.com/api/associate/login.php'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {'api_key': 'dh8kd263j253ahd5', 'auser': username, 'apass': password},
  );

  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        await saveLoginData(data['auser'], data['login_key'] ?? '');
        await getUserInfo(context);

        Navigator.pushNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid credentials'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error parsing response')),
      );
      return;
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('please check your internet connection')),
    );
  }
  return;
}

Future<void> saveLoginData(String userId, String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', userId);
  await prefs.setString('token', token);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();

  return prefs.getString('user_id');
}

Future<void> logUserOut(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  //log out logic to the back end
  final response = await http.post(
    Uri.parse('https://payments.sgxmobility.com/api/associate/logout.php'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'api_key': 'dh8kd263j253ahd5',
      'login_key': prefs.getString('token')
    },
  );

  await prefs.remove('user_id');
  await prefs.remove('token');
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}

Future<void> get_balance(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  //log out logic to the back end
  final response = await http.post(
    Uri.parse('https://payments.sgxmobility.com/api/associate/balance.php'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'api_key': 'dh8kd263j253ahd5',
      'login_key': prefs.getString('token'),
      'request_page': 'balance'
    },
  );

  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);
      if (data['status'] == 'success' && data['acc_balance'] != null) {
        await prefs.setString('acc_balance', data['acc_balance'].toString());
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('cannot parse response ')));
    }
  }
}

Future<List<Transaction>> getTransactions() async {
  final prefs = await SharedPreferences.getInstance();

  final transactionresponse = await http.post(
    Uri.parse(
        'https://payments.sgxmobility.com/api/associate/transactions.php'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'api_key': 'dh8kd263j253ahd5',
      'login_key': prefs.getString('token'),
      'request_page': 'transactions',
    },
  );

  if (transactionresponse.statusCode == 200) {
    var data = json.decode(transactionresponse.body);

    if (data['status'] == 'success') {
      List<dynamic> transactionsJson = data['transactions'] ?? [];
      List<Transaction> transactions = transactionsJson
          .map((jsonItem) => Transaction.fromJson(jsonItem))
          .toList();
      return transactions;
    }
  }

  return [];
}

Future<void> getUserInfo(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  // Get all keys

  final response = await http.post(
    Uri.parse('https://payments.sgxmobility.com/api/associate/userinfo.php'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'api_key': 'dh8kd263j253ahd5',
      'login_key': prefs.getString('token'),
      'request_page': 'userinfo'
    },
  );
  print("=========Data from shared preferences auth function 171");
  print(response.body);
  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);

      if (data['status'] == 'success') {
        await prefs.setString('FirstName', data['fname'].toString());
        await prefs.setString('userId', data['user_id'].toString());
        await prefs.setString('LastName', data['lname'].toString());
        await prefs.setString('gender', data['gender'].toString());
        await prefs.setString('phone', data['phone'].toString());
        await prefs.setString('email', data['email'].toString());
        await prefs.setString('address', data['address'].toString());
      }
    } catch (e, stacktrace) {
      print("Error decoding response: $e");
      print(stacktrace);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cannot parse user information response')));
    }
  } else {
    print("could not get user info");
  }
}


Future<Map<String, dynamic>> getDailySummaryData(DateTime date) async {
    final Map<String, dynamic> DialyData = {
         'NetEarning': 0.00,
    'feesPerAgreement': {
      'bolt': 0.00,
      'sgx': 0.00,
      'driverCash': 0.00,
    },
    'collectedBy': {
      'bolt': 0.00,
      'sgx': 0.00,
      'driverCash': 0.00,
    },
    'balanceDue': {
      
      'sgx': 0.00,
      
    },
    'hours': {
      'targetHours': 0.00,
      'actualHours': 0.00,
    },
    'trips': {
      'targetTrips': 0.00,
      'actualTrips': 0.00,
    }
        };
    return DialyData;
  final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse('https://payments.sgxmobility.com/api/associate/daily_summary.php'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'api_key': 'dh8kd263j253ahd5',
      'login_key': prefs.getString('token'),
      'date': date.toIso8601String(),
    },
  );

  if (response.statusCode == 200) {
    try {
      var data = json.decode(response.body);
      if (data['status'] == 'success') {
        
    
        return DialyData;
      } else {
        return DialyData;
      }
    } catch (e) {
      return DialyData;
    }
  } else {
    return DialyData;
  }
}
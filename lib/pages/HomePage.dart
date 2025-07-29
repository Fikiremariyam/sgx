import 'package:flutter/material.dart';
import 'package:sgx/pages/profilepage.dart';
import 'package:sgx/pages/adevertizementBanner.dart';
import 'package:sgx/Models/Transactions.dart';
import 'package:sgx/widgts/transactionitem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sgx/Auth/auth_functions.dart';
import 'package:sgx/pages/NotficationPage.dart';
import 'package:sgx/pages/paymentHistory.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Daily';
  String Balance = '';

  @override
  void initState() {
    super.initState();
    getUserBalance(context);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: widget.title == 'SGX WALLET'
              ? IconButton(
                  color: Theme.of(context).colorScheme.onPrimary,
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                )
              : IconButton(
                  color: Theme.of(context).colorScheme.onPrimary,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
          actions: [
            
          IconButton(
            icon:  Icon(Icons.notifications_none, color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationPage()),
                    );
            
            },
          ),
          ],
        ),

        // Wrap body in a Container with a dark background color
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Advertisement Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Column(
                    children: [
                      AdvertisementBanner(
                        advertisements: AdBannerSamples.getSampleAds(),
                        height: 140,
                        autoSlideInterval: Duration(seconds: 5),
                        onAdTap: (ad) {
                          print('Ad tapped: ${ad.title}');
                        },
                      ),
                      Column(
                        children: [
                          Text(
                            'Current Balance',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // balance section'

                                IconButton(
                                    icon: Icon(Icons.refresh,
                                        color: Colors.white, size: 30),
                                    onPressed: () {
                                      getUserBalance(context);
                                    }),
                                SizedBox(width: 8),

                                Text(
                                  '₦' + Balance,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                     
                    ],
                  ),
                ),
              ),
/*
              // Filter Tabs
                   Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
            ],
          ),
          child:  TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFF757575),
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            onTap: (index) {
              setState(() {
                _selectedFilter = ['Daily', 'Weekly', 'Monthly'][index];
              });
            },
            tabs: [
              Tab(text: 'Daily'),
              Tab(text: 'Weekly'),
              Tab(text: 'Monthly'),
            ],
          ),
        ),
*/
    SizedBox(height: 20),

      Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children: [
            SizedBox(
              width: 30,
            ),
           Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor, // 🌿 Background color
                borderRadius: BorderRadius.circular(12), // 🎯 Curvy corners
              ),
              child: Text(
                "Transactions",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary, // 🌿 Text color
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            ,
            SizedBox(width: 30,),

            ElevatedButton.icon(
                onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountInformationCenter()));
                },
                icon: Icon(Icons.calendar_today), // 📅 You can change the icon
                label: Text('Daily Summary'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // 🌿 Button background
                  foregroundColor: Colors.white, // 🖋 Text and icon color
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), //
                  ),
                ),
              ),

          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
    


       SizedBox(
        height: 400, // or MediaQuery.of(context).size.height * 0.5
        child: Column(
          children: [
            
            Padding(
            padding: EdgeInsets.only(right: 16), // 6 pixels bottom padding
            child: SizedBox(
              height: 25,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '1 - 10',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),



            SizedBox(height: 20),
            Daily(),
          ],
        ),),
                
        
           ],
          ),
        ));
        }
 
  Widget Daily(){
    return        Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       
                        FutureBuilder<List<Transaction>>(
                          future:
                              _getFilteredTransactions(), // your async method
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Color(
                                    0xFF4CAF50), // Primary color for the progress indicator
                              ));
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No transactions found.'));
                            }

                            final transactions = snapshot.data!;

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                return buildTransactionItem(
                                    context, transaction);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
        
  }

  Future<List<Transaction>> _getFilteredTransactions() async {
    List<Transaction> mockTransactions = await getTransactions();

    return mockTransactions;
  }

void getUserBalance(BuildContext context) async {
    get_balance(context);

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      Balance = prefs.getString('acc_balance') ?? '0.1234';
    });
  }
}

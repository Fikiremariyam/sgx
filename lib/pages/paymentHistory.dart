import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sgx/Auth/auth_functions.dart';

class AccountInformationCenter extends StatefulWidget {
  @override
  _AccountInformationCenterState createState() =>
      _AccountInformationCenterState();
}

class _AccountInformationCenterState extends State<AccountInformationCenter> {
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormatter = DateFormat('MMM dd, yyyy');

  // Sample transaction data
   Map<String, dynamic> transactionData = {  };
   
   void fetchdialySummary() async{
     final FetechedData = await  getDailySummaryData(selectedDate);
     print(FetechedData);
    setState(()  {
      transactionData = FetechedData;
    });
    

  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(String label, dynamic amount, String message ,
      {bool isTotal = false}) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize:  18,
                    fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                    color: isTotal ? Colors.black : Colors.grey[700],
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(
                    fontSize:  12,
                    fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                    color:  const Color.fromARGB(255, 117, 115, 115),
                  ),
                )
              ],
            ),
          ),
          Text(
          '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: TextStyle(
              fontSize:  18 ,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isTotal ? Colors.black : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleTransactionRow(String label, Map<String, dynamic> amounts) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: amounts.entries.map((entry) {
                String displayName = entry.key == 'driverCash'
                    ? 'Driver (Cash)'
                    : entry.key.toUpperCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$displayName -',
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color.fromARGB(255, 2, 1, 1),
                        ),
                      ),
                      Text
                      ( 
                         '${entry.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, {bool isTarget = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color.fromARGB(255, 12, 12, 12),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isTarget ? Colors.blue[600] : Colors.green[600],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchdialySummary();
      
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Daily  Summary',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Selection Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(dateFormatter.format(selectedDate)),
                      style: ElevatedButton.styleFrom(
                      backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Transaction Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.date_range,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Date: ${dateFormatter.format(selectedDate)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Gross Earning
                    _buildTransactionRow(   'Net Earning ',  transactionData['NetEarning']  ,"Excludes campaign earning ", isTotal: true),
                  
                    const Divider(height: 24),

                    // Fees Per Agreement
                    _buildMultipleTransactionRow('Fees Per Agreement',
                        transactionData['feesPerAgreement']),

                    const Divider(height: 24),

                    // Collected By
                    _buildMultipleTransactionRow(
                        'Collected By', transactionData['collectedBy']),

                    const Divider(height: 24),

                    // Balance Due
                    _buildMultipleTransactionRow(
                        'Balance Due', transactionData['balanceDue']), 
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Performance Metrics Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.analytics,
                            color: Colors.green[600], size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Performance Metrics',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Hours Section
                    _buildSectionHeader('Working Hours'),
                    _buildMetricRow(
                      'On App Hours (Target)',
                      '${transactionData['hours']['targetHours']}',
                      isTarget: true,
                    ),
                    _buildMetricRow(
                      'Actual Hours Today',
                      '${transactionData['hours']['actualHours']}',
                    ),

                    const SizedBox(height: 12),

                    // Trips Section
                    _buildSectionHeader('Trip Statistics'),
                    _buildMetricRow(
                      'Target No. of Finished Trips',
                      '${transactionData['trips']['targetTrips']}',
                      isTarget: true,
                    ),
                    _buildMetricRow(
                      'Actual No. of Finished Trips',
                      '${transactionData['trips']['actualTrips']}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Card( 
              color: Theme.of(context).appBarTheme.backgroundColor!.withAlpha(75),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),

              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Note: This is a sample daily summary. Actual data may vary based on your transactions and performance.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )),
                ),
            
          ],
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:sgx/Models/Transactions.dart';
import 'package:sgx/pages/paymentDetail.dart';

// Enhanced Action Button with better styling
Widget buildActionButton({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.25),
            Colors.white.withOpacity(0.15),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

// Enhanced Transaction Item with better color scheme and design
Widget buildTransactionItem(BuildContext context, Transaction transaction) {
  final bool isCredit = transaction.transType == "Credit";

  // Enhanced color scheme
  final Color primaryColor = isCredit
      ? Theme.of(context).appBarTheme.backgroundColor ??
          Color(0xFF4CAF50) // Vibrant green for credits
      : Color(0xFFE53935); // Material red for debits

  final Color lightColor = isCredit
      ? Color(0xFFE8F5E8) // Light green background
      : Color(0xFFFFEBEE); // Light red background

  final Color iconBgColor = isCredit
      ? Color(0xFF4CAF50).withOpacity(0.1)
      : Color(0xFFE53935).withOpacity(0.1);

  return GestureDetector(
    onTap: () {
      PaymentDetailPopup.show(context, transaction);
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            // Enhanced Icon Container
          
            SizedBox(width: 16),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Reference with enhanced styling
                  Text(
                    transaction.transRefNo,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),

                  SizedBox(height: 6),

                  // Date with icon
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          transaction.transDate,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF9E9E9E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Enhanced Amount Display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.1),
                        primaryColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${isCredit ? '+' : '-'}₦${_formatAmount(transaction.amountCredited)}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                SizedBox(height: 8),

                // Status indicator
                ],
            ),
          ],
        ),
      ),
    ),
  );
}

// Helper function to format amount with commas
String _formatAmount(String amount) {
  try {
    final number = double.parse(amount);
    return number.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  } catch (e) {
    return amount;
  }
}

// Optional: Enhanced Transaction List Widget
Widget buildTransactionList(
    BuildContext context, List<Transaction> transactions) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF121212),
          Color(0xFF1E1E1E),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return buildTransactionItem(context, transactions[index]);
      },
    ),
  );
}

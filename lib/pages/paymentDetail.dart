import 'package:flutter/material.dart';
import 'package:sgx/Models/Transactions.dart';
import 'package:sgx/pages/reportIssuingdialog.dart';

class PaymentDetailPopup extends StatelessWidget {
  final Transaction transaction;

  const PaymentDetailPopup({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  static void show(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentDetailPopup(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Color(0xFF2E2E2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transaction Status Card
                  _buildStatusCard(),
                  SizedBox(height: 20),

                  // Amount Section
                  _buildAmountSection(),
                  SizedBox(height: 20),

                  // Transaction Details
                  _buildDetailsSection(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 84, 84, 84),
            Color.fromARGB(255, 49, 49, 49)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 15),
          Text(
            transaction.transType == TransactionType.Credit
                ? 'Payment Received'
                : 'Payment Sent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Transaction Completed',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            'Amount',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${transaction.transType == "Credit" ? '+' : '-'}₦${transaction.amountCredited}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: transaction.transType == "Credit"
                  ? Color(0xFF4CAF50)
                  : Color(0xFFFF5722),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transaction Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          SizedBox(height: 15),
          _buildDetailRow('Transaction ID', _generateTransactionId()),
          _buildDetailRow('Date & Time', _formatDateTime()),
          _buildDetailRow('Description',
              transaction.transRefNo ?? 'No description provided'),
          _buildDetailRow('Status', 'Completed'),
          if (transaction.transType == "Debt") ...[
            _buildDetailRow('Vehicle ID', 'SGX-${_generateVehicleId()}'),
            _buildDetailRow('Distance', '${_generateDistance()} km'),
            _buildDetailRow('Duration', '${_generateDuration()} mins'),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: Color(0xFF4CAF50),
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SGX Wallet',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  Text(
                    'Primary payment method',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _generateTransactionId() {
    return 'TXN${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  String _generateVehicleId() {
    return '${(double.parse(transaction.amountCredited) * 100).toInt().toString().padLeft(4, '0')}';
  }

  String _generateDistance() {
    return (double.parse(transaction.amountCredited) / 15).toStringAsFixed(1);
  }

  String _generateDuration() {
    return ((double.parse(transaction.amountCredited) / 15) * 8)
        .toInt()
        .toString();
  }

  String _formatDateTime() {
    // In a real app, you'd parse the actual date
    return '${transaction.transDate} • ${DateTime.now().year}';
  }

  void _copyTransactionId(BuildContext context) {
    //Clipboard.setData(ClipboardData(text: _generateTransactionId()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction ID copied to clipboard'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _shareTransaction(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality would be implemented here'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _downloadReceipt(BuildContext context) {
    // Implement receipt download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt download would be implemented here'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _reportIssue(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => ReportIssueDialog(transaction: transaction),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sgx/Models/Transactions.dart';

class ReportIssueDialog extends StatefulWidget {
  final Transaction transaction;

  const ReportIssueDialog({Key? key, required this.transaction})
      : super(key: key);

  @override
  _ReportIssueDialogState createState() => _ReportIssueDialogState();
}

class _ReportIssueDialogState extends State<ReportIssueDialog> {
  final TextEditingController _issueController = TextEditingController();
  String _selectedIssueType = 'Incorrect Amount';

  final List<String> _issueTypes = [
    'Incorrect Amount',
    'Wrong Location',
    'Service Issue',
    'Payment Problem',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'Report Issue',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2E2E2E),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Issue Type',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E2E2E),
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedIssueType,
                isExpanded: true,
                onChanged: (value) {
                  setState(() {
                    _selectedIssueType = value!;
                  });
                },
                items: _issueTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Description',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E2E2E),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _issueController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Please describe the issue...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFF4CAF50)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // Submit issue report
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Issue reported successfully'),
                backgroundColor: Color(0xFF4CAF50),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }
}

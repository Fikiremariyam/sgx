import 'package:flutter/material.dart';

class WeeklyIncomeData {
  final String month;
  final List<double> weeklyIncome; // 4-5 weeks per month

  WeeklyIncomeData({
    required this.month,
    required this.weeklyIncome,
  });
}

List<WeeklyIncomeData> get sampleData => [
      WeeklyIncomeData(
        month: 'January',
        weeklyIncome: [1200.50, 1350.75, 1100.25, 1450.00],
      ),
      WeeklyIncomeData(
        month: 'February',
        weeklyIncome: [1300.00, 1250.25, 1400.75, 1180.50],
      ),
      WeeklyIncomeData(
        month: 'March',
        weeklyIncome: [1500.00, 1320.25, 1280.50, 1600.75],
      ),
      WeeklyIncomeData(
        month: 'April',
        weeklyIncome: [1420.50, 1380.25, 1550.00, 1290.75],
      ),
      WeeklyIncomeData(
        month: 'May',
        weeklyIncome: [1650.00, 1480.25, 1520.50, 1700.75],
      ),
      WeeklyIncomeData(
        month: 'June',
        weeklyIncome: [1580.50, 1620.25, 1450.00, 1750.75],
      ),
      WeeklyIncomeData(
        month: 'July',
        weeklyIncome: [1580.50, 1620.25, 1450.00, 1750.75],
      ),
      WeeklyIncomeData(
        month: 'August',
        weeklyIncome: [1580.50, 1620.25, 1450.00, 1750.75],
      ),
    ];

Widget buildIncomeTable(BuildContext context) {
  int maxWeeks = sampleData.fold(
      0,
      (max, data) =>
          data.weeklyIncome.length > max ? data.weeklyIncome.length : max);

  return Table(
    border: TableBorder.all(
      color: Colors.grey[300]!,
      width: 1,
    ),
    columnWidths: {
      0: const FixedColumnWidth(100), // Month column
      for (int i = 1; i <= maxWeeks; i++)
        i: const FixedColumnWidth(120), // Week columns
    },
    children: [
      // Header row
      TableRow(
        decoration: BoxDecoration(
          color: Colors.blue[50],
        ),
        children: [
          _buildHeaderCell('Month'),
          for (int week = 1; week <= maxWeeks; week++)
            _buildHeaderCell('Week $week'),
        ],
      ),
      // Data rows
      ...sampleData.map((monthData) => TableRow(
            children: [
              _buildDataCell(monthData.month, isMonth: true),
              for (int week = 0; week < maxWeeks; week++)
                _buildDataCell(
                  week < monthData.weeklyIncome.length
                      ? '\$${monthData.weeklyIncome[week].toStringAsFixed(2)}'
                      : '-',
                ),
            ],
          )),
    ],
  );
}

Widget _buildHeaderCell(String text) {
  return Container(
    padding: const EdgeInsets.all(12),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      textAlign: TextAlign.center,
    ),
  );
}

Widget _buildDataCell(String text, {bool isMonth = false}) {
  return Container(
    padding: const EdgeInsets.all(12),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: isMonth ? FontWeight.w600 : FontWeight.normal,
        color: isMonth ? Colors.blue[700] : Colors.black87,
      ),
      textAlign: isMonth ? TextAlign.left : TextAlign.center,
    ),
  );
}

Widget _buildTotalSummary(BuildContext context) {
  double totalIncome = sampleData.fold(
      0,
      (sum, monthData) =>
          sum +
          monthData.weeklyIncome
              .fold(0, (weekSum, income) => weekSum + income));

  double averageWeekly = totalIncome /
      sampleData.fold(
          0, (count, monthData) => count + monthData.weeklyIncome.length);

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.green[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.green[200]!),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem(
          'Total Income',
          '\$${totalIncome.toStringAsFixed(2)}',
          Colors.green[700]!,
        ),
        _buildSummaryItem(
          'Average Weekly',
          '\$${averageWeekly.toStringAsFixed(2)}',
          Colors.blue[700]!,
        ),
        _buildSummaryItem(
          'Total Weeks',
          '${sampleData.fold(0, (count, monthData) => count + monthData.weeklyIncome.length)}',
          Colors.orange[700]!,
        ),
      ],
    ),
  );
}

Widget _buildSummaryItem(String label, String value, Color color) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    ],
  );
}

Widget buildweekly(BuildContext context) {
  return SingleChildScrollView(
    child: Card(
      color: Colors.green[50],
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Income Summary',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildIncomeTable(context),
            ),
            const SizedBox(height: 20),
            _buildTotalSummary(context),
          ],
        ),
      ),
    ),
  );
}

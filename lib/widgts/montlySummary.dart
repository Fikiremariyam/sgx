import 'package:flutter/material.dart ';

class MonthlyBalanceData {
  final String month;
  final int year;
  final double balance;
  final double income;
  final double expenses;

  MonthlyBalanceData({
    required this.month,
    required this.year,
    required this.balance,
    required this.income,
    required this.expenses,
  });

  String get monthYear => '$month $year';
  bool get isPositive => balance >= 0;
}

class MonthlySummaryWidget extends StatelessWidget {
  final List<MonthlyBalanceData> balanceData;
  final bool showDetails;

  const MonthlySummaryWidget({
    Key? key,
    required this.balanceData,
    this.showDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildMonthlyGrid(context),
              const SizedBox(height: 20),
              _buildSummaryStats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Monthly Balance Summary',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
        ),
        Icon(
          Icons.account_balance_wallet,
          color: Colors.blue[600],
          size: 28,
        ),
      ],
    );
  }

  Widget _buildMonthlyGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 6,
      ),
      itemCount: balanceData.length,
      itemBuilder: (context, index) {
        return _buildMonthCard(context, balanceData[index]);
      },
    );
  }

  Widget _buildMonthCard(BuildContext context, MonthlyBalanceData data) {
    Color cardColor = data.isPositive ? Colors.green[50]! : Colors.red[50]!;
    Color borderColor = data.isPositive ? Colors.green[200]! : Colors.red[200]!;
    Color textColor = data.isPositive ? Colors.green[700]! : Colors.red[700]!;
    IconData icon = data.isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    data.monthYear,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  icon,
                  color: textColor,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${data.balance.abs().toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (showDetails) ...[
              const SizedBox(height: 4),
              Text(
                'Income: \$${data.income.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Expenses: \$${data.expenses.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStats(BuildContext context) {
    double totalBalance =
        balanceData.fold(0, (sum, data) => sum + data.balance);
    double totalIncome = balanceData.fold(0, (sum, data) => sum + data.income);
    double totalExpenses =
        balanceData.fold(0, (sum, data) => sum + data.expenses);
    double averageBalance =
        balanceData.isNotEmpty ? totalBalance / balanceData.length : 0;

    int positiveMonths = balanceData.where((data) => data.isPositive).length;
    int negativeMonths = balanceData.length - positiveMonths;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Text(
            'Summary Statistics',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Balance',
                  '\$${totalBalance.toStringAsFixed(2)}',
                  totalBalance >= 0 ? Colors.green[700]! : Colors.red[700]!,
                  Icons.account_balance,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Average Balance',
                  '\$${averageBalance.toStringAsFixed(2)}',
                  averageBalance >= 0 ? Colors.green[700]! : Colors.red[700]!,
                  Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Income',
                  '\$${totalIncome.toStringAsFixed(2)}',
                  Colors.green[700]!,
                  Icons.arrow_upward,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Total Expenses',
                  '\$${totalExpenses.toStringAsFixed(2)}',
                  Colors.red[700]!,
                  Icons.arrow_downward,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Positive Months',
                  '$positiveMonths',
                  Colors.green[700]!,
                  Icons.thumb_up,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Negative Months',
                  '$negativeMonths',
                  Colors.red[700]!,
                  Icons.thumb_down,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

List<MonthlyBalanceData> get monthlySampleData => [
      MonthlyBalanceData(
        month: 'January',
        year: 2024,
        balance: 2500.75,
        income: 5000.00,
        expenses: 2499.25,
      ),
      MonthlyBalanceData(
        month: 'February',
        year: 2024,
        balance: -150.50,
        income: 4800.00,
        expenses: 4950.50,
      ),
      MonthlyBalanceData(
        month: 'March',
        year: 2024,
        balance: 1800.25,
        income: 5200.00,
        expenses: 3399.75,
      ),
      MonthlyBalanceData(
        month: 'April',
        year: 2024,
        balance: 3200.00,
        income: 5500.00,
        expenses: 2300.00,
      ),
      MonthlyBalanceData(
        month: 'May',
        year: 2024,
        balance: -500.75,
        income: 4500.00,
        expenses: 5000.75,
      ),
      MonthlyBalanceData(
        month: 'June',
        year: 2024,
        balance: 2100.50,
        income: 5300.00,
        expenses: 3199.50,
      ),
      MonthlyBalanceData(
        month: 'July',
        year: 2024,
        balance: 1750.25,
        income: 5100.00,
        expenses: 3349.75,
      ),
      MonthlyBalanceData(
        month: 'August',
        year: 2024,
        balance: 2850.00,
        income: 5400.00,
        expenses: 2550.00,
      ),
    ];

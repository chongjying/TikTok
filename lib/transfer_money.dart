import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tiktok1/homepage.dart';
import 'transaction_database.dart'; // Make sure this file exists and has the necessary methods/classes
import 'package:fl_chart/fl_chart.dart'; // Importing fl_chart package

class TransferMoneyPage extends StatefulWidget {
  const TransferMoneyPage({Key? key}) : super(key: key);

  @override
  _TransferMoneyPageState createState() => _TransferMoneyPageState();
}

class _TransferMoneyPageState extends State<TransferMoneyPage> {
  late Future<List<Transaction>> _transactions;
  int tiktokPoints = 1001; // Example TikTok points

  @override
  void initState() {
    super.initState();
    _transactions = _fetchTransactions();
  }

  Future<List<Transaction>> _fetchTransactions() async {
    return getTransactions(); // Replace with your method to fetch transactions
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 229, 229, 229),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Transfer Money',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Pie Chart Integration
              const Text(
                'This month',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              PieChartWidget(), // Adding the PieChartWidget
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconColumn(context, Icons.qr_code, 'QR Code', QRCodePage()),
                  _buildIconColumn(context, Icons.account_balance, 'Send to Bank', SelectBankPage()),
                  _buildIconColumn(context, Icons.contact_page, 'Send to Contact', SelectContactPage()), 
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionPage(),
                          ),
                        );
                      },
                      child: Text(
                        'View All >',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Transaction>>(
                  future: _transactions,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No transactions available.'));
                    } else {
                      final transactions = snapshot.data!;
                      return ListView.builder(
                        itemCount:
                            transactions.length > 3 ? 3 : transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          String formattedAmount =
                              transaction.amount.toStringAsFixed(2);

                          return ListTile(
                            title: Text(transaction.details,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(transaction.createdTime,
                                    style: const TextStyle(color: Colors.grey)),
                                Text('\$$formattedAmount',
                                    style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                            trailing: Text(transaction.referenceNo.toString(),
                                style: const TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailPage(
                                      transaction: transaction),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconColumn(BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, size: 40.0, color: Colors.white), // Adjusted to white for better visibility
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.white, // Adjusted to white for better visibility
              ),
            ),
          ),
        ],
      ),
    );
  }
}


//Pie Chart
class PieChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Generate random data
    double spending = Random().nextInt(5000) + 1000;
    double income = Random().nextInt(10000) + 5000;

    return SizedBox(
      height: 200, // Adjust the height as needed
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              color: Colors.red,
              value: spending,
              title: 'Spending',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            PieChartSectionData(
              color: Colors.green,
              value: income,
              title: 'Income',
              radius: 50,
              titleStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
          sectionsSpace: 4,
          centerSpaceRadius: 40,
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              if (pieTouchResponse != null &&
                  pieTouchResponse.touchedSection != null) {
                final touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                if (touchedIndex == 0) {
                  print('Spending was touched');
                } else if (touchedIndex == 1) {
                  print('Income was touched');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}




class QRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: const Center(
        child: Text('QR Code Page'),
      ),
    );
  }
}

class SelectContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send to Contact'),
      ),
      body: const Center(
        child: Text('Select Contact Page'),
      ),
    );
  }
}

class SelectBankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send to Bank'),
      ),
      body: const Center(
        child: Text('Select Bank Page'),
      ),
    );
  }
}


class TransactionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: const Center(
        child: Text('Transactions Page'),
      ),
    );
  }
}


class TransactionDetailPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailPage({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Details: ${transaction.details}'),
            Text('Amount: \$${transaction.amount.toStringAsFixed(2)}'),
            Text('Reference No: ${transaction.referenceNo}'),
            Text('Created Time: ${transaction.createdTime}'),
          ],
        ),
      ),
    );
  }
}

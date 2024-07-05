import 'package:flutter/material.dart';
import 'package:tiktok1/transaction_history.dart';
import 'package:tiktok1/transfer_money.dart';
import 'transaction.dart';
import 'transaction_database.dart';
import 'package:tiktok1/transaction_details.dart';
import 'wallet_topup.dart';
import 'live_rewards.dart'; 
import 'coin_purchase.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Widget _buildIconColumn(
      BuildContext context, IconData icon, String label, Widget page) {
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
          Icon(icon, size: 40.0),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'WELCOME, [XXX]', // Replace [XXX] with a dynamic name if needed
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        iconSize: 38.0,
                        onPressed: () {
                          // Navigate to TikTok Points page or implement functionality
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Balance',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'RM 1234.56', // Replace with a dynamic number if needed
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Implement your top-up functionality here
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'TikTok Points >',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '0101010',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIconColumn(
                          context, Icons.add_box, 'Top Up', WalletTopUp()),
                      _buildIconColumn(context, Icons.arrow_upward,
                          'Transfer Money', TransferMoneyPage()),
                      _buildIconColumn(context, Icons.monetization_on, 'Coin',
                          CoinPurchasePage()), // Update here
                      _buildIconColumn(context, Icons.card_giftcard,
                          'Live Reward', LiveRewardScreen()), // Update here
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryPage(),
                      ),
                    );
                  },
                  child: const Text(
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
                            style: const TextStyle(color: Colors.black)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.createdTime,
                                style: const TextStyle(color: Colors.grey)),
                            Text('\$$formattedAmount',
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        trailing: Text(transaction.referenceNo.toString(),
                            style: const TextStyle(color: Colors.black)),
                             onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailPage(transaction: transaction),
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
    );
  }
}




class LiveRewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Reward'),
      ),
      body: const Center(
        child: Text('LiveRewardPage'),
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
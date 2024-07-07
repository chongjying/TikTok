import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tiktok1/database_helper.dart';
import 'package:tiktok1/transaction_history.dart';
import 'package:tiktok1/transfer_money.dart';
import 'package:tiktok1/transaction_details.dart';
import 'wallet_topup.dart';
import 'live_rewards.dart';
import 'coin_purchase.dart';

class HomePage extends StatefulWidget {
  final Account account;

  HomePage({required this.account});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Transaction>> _transactions;
  int tiktokPoints = 1001; // Example TikTok points
  late double _walletBalance;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _fetchBalance(); 
  }

  Future<void> _fetchTransactions() async {
    List<Transaction> transactions = await DatabaseHelper.instance.getTransactions();
    setState(() {
      _transactions = Future.value(transactions);
    });
  }

  Future<void> _fetchBalance() async {
    double balance = await DatabaseHelper.getBalance(widget.account.userID!);
    setState(() {
      _walletBalance = balance;
    });
  }

  Widget _buildIconColumn(
      BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        ).then((value) {
          if (value != null && value) {
            _fetchBalance(); // Update balance after returning from the page
          }
        });
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'WELCOME, ${widget.account.username}',
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
                          // Navigate to user profile or implement functionality
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
                            _walletBalance != null
                                ? 'RM ${_walletBalance.toStringAsFixed(2)}'
                                : 'Loading...', // Display wallet balance dynamically
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => WalletTopUp()),
                          ).then((value) {
                            if (value != null && value) {
                              _fetchBalance(); // Update balance after top-up
                            }
                          });
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
                          'Transfer Money', TransferMoneyPage(account: widget.account)),
                      _buildIconColumn(context, Icons.monetization_on, 'Coin',
                          CoinPurchasePage(account: widget.account)), // Update here
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
                            Text('RM$formattedAmount',
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        trailing: Text(transaction.referenceNo.toString(),
                            style: const TextStyle(color: Colors.black)),
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
    );
  }
}

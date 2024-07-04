import 'package:flutter/material.dart';
import 'LIVE_rewards_page.dart'; // Ensure this import is correct
import 'transaction.dart';
import 'tiktok_wallet.dart';
import 'transaction_database.dart';
import 'transaction_details.dart';
import 'transaction.dart'; // Ensure this import is correct

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Transaction>> _transactions;

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
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Black background section
          Container(
            color: Colors.black,
            padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TikTokWallet(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  'Balance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'RM 1234.56', // Replace with a dynamic number if needed
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIconColumn(context, Icons.arrow_downward, 'Receive Money', ReceiveMoneyPage()),
                    _buildIconColumn(context, Icons.arrow_upward, 'Send Money', SendMoneyPage()),
                    _buildIconColumn(context, Icons.monetization_on, 'Coin', CoinPurchasePage()),
                    _buildIconColumn(context, Icons.card_giftcard, 'Live Reward', LiveRewardPage()),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionPage(),
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
          ),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: _transactions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No transactions available.'));
                } else {
                  final transactions = snapshot.data!;
                  return ListView.builder(
                    itemCount: transactions.length > 3 ? 3 : transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      String formattedAmount = transaction.amount.toStringAsFixed(2);
                      
                      return ListTile(
                        title: Text(transaction.details, style: const TextStyle(color: Colors.black)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(transaction.createdTime, style: const TextStyle(color: Colors.grey)),
                            Text('\$$formattedAmount', style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                        trailing: Text(transaction.referenceNo.toString(), style: const TextStyle(color: Colors.black)),
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

class ReceiveMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receive Money'),
      ),
      body: const Center(
        child: Text('Receive Money Page'),
      ),
    );
  }
}

class SendMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
      ),
      body: const Center(
        child: Text('Send Money Page'),
      ),
    );
  }
}

class CoinPurchasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Purchase'),
      ),
      body: const Center(
        child: Text('Coin Purchase Page'),
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
        child: Text('Live Reward Page'),
      ),
    );
  }
}

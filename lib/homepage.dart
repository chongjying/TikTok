import 'package:flutter/material.dart';
import 'LIVE_rewards_page.dart';
import 'coin_purchase.dart';
import 'transaction.dart';
import 'tiktok_wallet.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Example for transaction History
  final List<Map<String, String>> transactions = const [
    {
      'title': 'Subscription Payment',
      'date': '2024-06-01',
      'amount': '\$10.00'
    },
    {'title': 'Item Purchase', 'date': '2024-06-15', 'amount': '\$25.00'},
    {
      'title': 'Subscription Renewal',
      'date': '2024-07-01',
      'amount': '\$10.00'
    },
    // Add more transactions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
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
                      'WELCOME, [XXX]',
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
                      iconSize: 38.0, // Adjust the icon size as needed
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TikTokWallet(),
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
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length > 3 ? 3 : transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(transactions[index]['title']!,
                      style: const TextStyle(color: Colors.black)),
                  subtitle: Text(transactions[index]['date']!,
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Text(transactions[index]['amount']!,
                      style: const TextStyle(color: Colors.black)),
                  onTap: () {
                    // You can add a detail view for each transaction if needed
                  },
                );
              },
            ),
          ),
        ],
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
          Icon(icon, size: 40.0),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class ReceiveMoneyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Money'),
      ),
      body: Center(
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
        title: Text('Send Money'),
      ),
      body: Center(
        child: Text('Send Money Page'),
      ),
    );
  }
}


class LiveRewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Reward'),
      ),
      body: Center(
        child: Text('Live Reward Page'),
      ),
    );
  }
}
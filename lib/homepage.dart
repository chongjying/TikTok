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
          Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 20.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(
                  Icons.account_circle,
                  color: Colors.black,
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
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'WELCOME, [XXX]',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16), // Adjusted padding
              child: Row(
                children: [
                  // Left Column
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoinPurchasePage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 120, // Shorter height for left column
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8), // Adjusted padding
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // First Row (Image and Title side by side)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/coins.png',
                                      width: 30,
                                      height: 30,
                                    ),
                                    const SizedBox(width: 4), // Space between the image and text
                                    const Text(
                                      'Coins',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8), // Space between the two rows

                                // Second Row (Numerical figure)
                                const Text(
                                  '1000', // Replace with a dynamic number if needed
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Middle Column
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 150, // Taller height for middle column
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 180, 180, 180),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              const Text(
                                'RM ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Right Column
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiveRewardsPage(),
                          ),
                        );
                      },
                      child: Container(
                        height: 120, // Shorter height for right column
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8), // Adjusted padding
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'LIVE Rewards', // Replace with a dynamic number if needed
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 16), // Space between the two rows

                                // Second Row (Numerical figure)
                                const Text(
                                  'RM 10.00', // Replace with a dynamic number if needed
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
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
              ],
            ),
          ),
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
}

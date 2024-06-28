import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  final List<Map<String, String>> transactions;

  const TransactionPage({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'Transaction History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(transactions[index]['title']!,
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(transactions[index]['date']!,
                      style: const TextStyle(color: Colors.grey)),
                  trailing: Text(transactions[index]['amount']!,
                      style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    // You can add a detail view for each transaction if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}

import 'package:flutter/material.dart';
import 'transaction_database.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Future<List<Transaction>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = _fetchTransactions();
  }

  Future<List<Transaction>> _fetchTransactions() async {
    return getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Transaction History'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      title: Text(transaction.details,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(transaction.createdTime,
                          style: const TextStyle(color: Colors.grey)),
                      trailing: Text('\$${transaction.referenceNo}',
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        // Add a detail view for each transaction if needed
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

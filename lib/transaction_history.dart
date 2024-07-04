import 'package:flutter/material.dart';
import 'transaction_database.dart';
import 'transaction_details.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 20.0), // Adjusted padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Transaction History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 48), // Adjust spacing between back button and title
              ],
            ),
          ),
          Expanded(
            child: Padding(
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
                        String formattedAmount = transaction.amount.toStringAsFixed(2);
                        return Card(
                          color: const Color.fromARGB(255, 41, 41, 41),
                          child: ListTile(
                            title: Text(transaction.details,
                                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(transaction.createdTime, style: const TextStyle(color: Colors.grey)),
                                Text('\$$formattedAmount', style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                              ],
                            ),
                            trailing: Text('\$${transaction.referenceNo}',
                                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TransactionDetailPage(transaction: transaction),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

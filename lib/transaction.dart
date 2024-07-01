// transaction.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Transaction {
  final int? id;
  final int referenceNo;
  final String sender;
  final String receiver;
  final String details;
  final String createdTime;
  final String status;

  Transaction({
    this.id,
    required this.referenceNo,
    required this.sender,
    required this.receiver,
    required this.details,
    required this.createdTime,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referenceNo': referenceNo,
      'sender': sender,
      'receiver': receiver,
      'details': details,
      'created_time': createdTime,
      'status': status,
    };
  }
}

Future<Database> initializeDatabase() async {
  final path = join(await getDatabasesPath(), 'transaction.db');

  return openDatabase(
    path,
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE transactions(id INTEGER PRIMARY KEY, referenceNo INTEGER, sender TEXT, receiver TEXT, details TEXT, created_time TEXT, status TEXT)',
      );
    },
    version: 1,
  );
}

Future<List<Transaction>> getTransactions(Database db) async {
  final List<Map<String, dynamic>> maps = await db.query('transactions');

  return List.generate(maps.length, (i) {
    return Transaction(
      id: maps[i]['id'],
      referenceNo: maps[i]['referenceNo'],
      sender: maps[i]['sender'],
      receiver: maps[i]['receiver'],
      details: maps[i]['details'],
      createdTime: maps[i]['created_time'],
      status: maps[i]['status'],
    );
  });
}

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
    final database = await initializeDatabase();
    return getTransactions(database);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final transaction = snapshot.data![index];
                return ListTile(
                  title: Text(transaction.details),
                  subtitle: Text(transaction.createdTime),
                  trailing: Text(transaction.status),
                );
              },
            );
          }
        },
      ),
    );
  }
}

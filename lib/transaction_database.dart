import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class Transaction {
  final int? id;
  final int referenceNo;
  final String sender;
  final String receiver;
  final String details;
  final String createdTime;
  final String status;
  final double amount;

  Transaction({
    this.id,
    required this.referenceNo,
    required this.sender,
    required this.receiver,
    required this.details,
    required this.createdTime,
    required this.status,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'referenceNo': referenceNo,
      'sender': sender,
      'receiver': receiver,
      'details': details,
      'amount': amount,
      'created_time': createdTime,
      'status': status,
    };
  }
}

Future<void> initializeDatabaseFactory() async {
  sqfliteFfiInit();
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  }

}

Future<Database> initializeDatabase() async {
  await initializeDatabaseFactory();

  final path = join(await getDatabasesPath(), 'transaction.db');
    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE transactions(id INTEGER PRIMARY KEY, referenceNo INTEGER, sender TEXT, receiver TEXT, details TEXT, amount REAL, created_time TEXT, status TEXT)',
          );
        },
        onOpen: (db) async {
          // Optional: Handle database open events
        },
        version: 1,
      ),
    );
}


Future<List<Transaction>> getTransactions() async {
  final Database db = await initializeDatabase();
  final List<Map<String, dynamic>> maps = await db.query('transactions');

  return List.generate(maps.length, (i) {
    return Transaction(
      id: maps[i]['id'],
      referenceNo: maps[i]['referenceNo'],
      sender: maps[i]['sender'],
      receiver: maps[i]['receiver'],
      details: maps[i]['details'],
      amount: maps[i]['amount'],
      createdTime: maps[i]['created_time'],
      status: maps[i]['status'],
    );
  });
}

Future<void> insertTransaction(Transaction transaction) async {
  final Database db = await initializeDatabase();

  await db.insert(
    'transactions',
    transaction.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


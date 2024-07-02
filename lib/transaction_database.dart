import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<Database> initializeDatabase() async {
  if (kIsWeb) {
    // Change default factory on the web
    databaseFactory = databaseFactoryFfiWeb;
  }

  final path = await getDatabasePath();
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

Future<String> getDatabasePath() async {
  if (kIsWeb) {
    return 'transaction.db';
  } else {
    return join(await getDatabasesPath(), 'transaction.db');
  }
}

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

  Transaction copyWith({
    int? id,
    int? referenceNo,
    String? sender,
    String? receiver,
    String? details,
    String? createdTime,
    String? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      referenceNo: referenceNo ?? this.referenceNo,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      details: details ?? this.details,
      createdTime: createdTime ?? this.createdTime,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Transaction{id: $id, referenceNo: $referenceNo, sender: $sender, receiver: $receiver, details: $details, createdTime: $createdTime, status: $status}';
  }
}

Future<void> insertTransaction(Database db, Transaction transaction) async {
  await db.insert(
    'transactions',
    transaction.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
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

Future<void> updateTransaction(Database db, Transaction transaction) async {
  await db.update(
    'transactions',
    transaction.toMap(),
    where: 'id = ?',
    whereArgs: [transaction.id],
  );
}

Future<void> deleteTransaction(Database db, int id) async {
  await db.delete(
    'transactions',
    where: 'id = ?',
    whereArgs: [id],
  );
}

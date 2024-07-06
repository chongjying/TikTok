import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database does not exist, create it
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'lib/transaction.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS accounts(userID INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, walletBalance REAL, coinBalance INTEGER, diamondBalance INTEGER, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE IF NOT EXISTS transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, referenceNo INTEGER, userID INTEGER, sender TEXT, receiver TEXT, details TEXT, amount REAL, created_time TEXT, status TEXT)',
        );
      },
    );
  }

  static Future<void> insertAccount(Account account) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('account', account.toMap());
  }

  static Future<Account?> getAccountByUsernameAndPassword(String username, String password) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }
    List<Map<String, dynamic>> maps = await _database!.query(
      'accounts',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return Account(
        userID: maps.first['userID'],
        username: maps.first['username'],
        walletBalance: maps.first['walletBalance'],
        coinBalance: maps.first['coinBalance'],
        diamondBalance: maps.first['diamondBalance'],
        password: maps.first['password'],
      );
    } else {
      return null;
    }
  }
 static Future<double> getBalance(int userID) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }
    Account? account = await getAccountById(userID);
    return account?.walletBalance ?? 0.00;
  }

  static Future<Account?> getAccountById(int userID) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }
    List<Map<String, dynamic>> maps = await _database!.query(
      'accounts',
      where: 'userID = ?',
      whereArgs: [userID],
    );

    if (maps.isNotEmpty) {
      return Account(
        userID: maps.first['userID'],
        username: maps.first['username'],
        walletBalance: maps.first['walletBalance'],
        coinBalance: maps.first['coinBalance'],
        diamondBalance: maps.first['diamondBalance'],
        password: maps.first['password'],
      );
    } else {
      return null;
    }
  }

  static Future<List<Transaction>> getTransactions() async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }
    final List<Map<String, dynamic>> maps = await _database!.query('transactions');

    return List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        referenceNo: maps[i]['referenceNo'],
        userID: maps[i]['userID'], // Foreign key
        sender: maps[i]['sender'],
        receiver: maps[i]['receiver'],
        details: maps[i]['details'],
        amount: maps[i]['amount'],
        createdTime: maps[i]['created_time'],
        status: maps[i]['status'],
      );
    });
  }

  static Future<void> insertTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    final Database db = await instance.database;
    return await db.query('accounts');
  }
}

class Transaction {
  final int? id;
  final int referenceNo;
  final int userID; // Foreign key
  final String sender;
  final String receiver;
  final String details;
  final String createdTime;
  final String status;
  final double amount;

  Transaction({
    this.id,
    required this.referenceNo,
    required this.userID,
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
      'userID': userID,
      'sender': sender,
      'receiver': receiver,
      'details': details,
      'amount': amount,
      'created_time': createdTime,
      'status': status,
    };
  }
}

class Account {
  final int? userID;
  final String username;
  final double walletBalance;
  final int coinBalance;
  final int diamondBalance;
  final String password;

  Account({
    this.userID,
    required this.username,
    required this.walletBalance,
    required this.coinBalance,
    required this.diamondBalance,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'username': username,
      'walletBalance': walletBalance,
      'coinBalance': coinBalance,
      'diamondBalance': diamondBalance,
      'password': password,
    };
  }
}

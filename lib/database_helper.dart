import 'package:flutter/foundation.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _accountDatabase;
  static Database? _transactionDatabase;

  // Initialize both databases
  Future<void> initializeDatabases() async {
    await initializeDatabaseFactory();
    _accountDatabase = await _initAccountDatabase();
    _transactionDatabase = await _initTransactionDatabase();
  }

  // Initialize the database factory based on platform
  Future<void> initializeDatabaseFactory() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    /*if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }*/
  }

  // Getters for account and transaction databases
  Future<Database> get accountDatabase async {
    await initializeDatabaseFactory();
    if (_accountDatabase != null) return _accountDatabase!;
    await initializeDatabases();
    return _accountDatabase!;
  }

  Future<Database> get transactionDatabase async {
    await initializeDatabaseFactory();
    if (_transactionDatabase != null) return _transactionDatabase!;
    await initializeDatabases();
    return _transactionDatabase!;
  }

  // Initialize the transaction database
  Future<Database> _initTransactionDatabase() async {
    final String path = join(await getDatabasesPath(), 'transactions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, referenceNo INTEGER, userID INTEGER, sender TEXT, receiver TEXT, details TEXT, amount REAL, created_time TEXT, status TEXT)',
        );
      },
    );
  }

  // Initialize the account database
  Future<Database> _initAccountDatabase() async {
    final String path = join(await getDatabasesPath(), 'assets/account.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS accounts(userID INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, walletBalance REAL, coinBalance INTEGER, diamondBalance INTEGER, password TEXT)',
        );
      },
    );
  }

  // Insert an account into the account database
  static Future<void> insertAccount(Account account) async {
    final db = await DatabaseHelper.instance.accountDatabase;
    await db.insert('accounts', account.toMap());
  }

  // Retrieve an account by username and password
  static Future<Account?> getAccountByUsernameAndPassword(
      String username, String password) async {
    final db = await DatabaseHelper.instance.accountDatabase;
    List<Map<String, dynamic>> maps = await db.query(
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

  // Retrieve balance for a specific user ID
  static Future<double> getBalance(int userID) async {
    final db = await DatabaseHelper.instance.accountDatabase;
    Account? account = await getAccountById(userID, db);
    return account?.walletBalance ?? 0.00;
  }

  // Retrieve an account by user ID
  static Future<Account?> getAccountById(int userID, [Database? db]) async {
    db ??= await DatabaseHelper.instance.accountDatabase;
    List<Map<String, dynamic>> maps = await db.query(
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

  // Retrieve transactions from the transaction database
  Future<List<Transaction>> getTransactions() async {
    final db = await DatabaseHelper.instance.transactionDatabase;
    final List<Map<String, dynamic>> maps = await db.query('transactions');

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

  // Insert a transaction into the transaction database
  static Future<void> insertTransaction(Transaction transaction) async {
    final db = await DatabaseHelper.instance.transactionDatabase;
    await db.insert('transactions', transaction.toMap());
  }

  // Retrieve all accounts from the account database
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await instance.accountDatabase;
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

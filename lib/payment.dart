import 'package:flutter/material.dart';
import 'package:tiktok1/database_helper.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final String price;
  final String itemAmount;
  final Account account;

  PaymentSelectionScreen({
    required this.account,
    required this.price,
    required this.itemAmount,
  });

  @override
  _PaymentSelectionScreenState createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String? _selectedPaymentMethod;
  final String _savedMethod = '0000 XXXX XXXX 0000';
  late Future<double> accountBalance;

  @override
  void initState() {
    super.initState();
    accountBalance = _fetchAccountBalance();
  }

  Future<double> _fetchAccountBalance() async {
    // Ensure userID is not null before passing to DatabaseHelper.getBalance()
    if (widget.account.userID != null) {
      return DatabaseHelper.getBalance(widget.account.userID!);
    } else {
      // Handle the case where userID is null (you might want to return a default value or throw an error)
      throw Exception('User ID is null.');
    }
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('TikTok Wallet Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<double>(
                future: accountBalance,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final balance = snapshot.data!;
                    return Text('Current Balance: RM ${balance.toStringAsFixed(2)}');
                  } else {
                    return Text('Loading...');
                  }
                },
              ),
              Text('Amount to Pay: RM ${widget.price}'),
              Text('Coins to purchase: ${widget.itemAmount}'),
            ],
          ),
          actions: [
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                // Deduct the balance and insert the transaction
                _deductBalanceAndInsertTransaction();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _deductBalanceAndInsertTransaction() async {
    double amount = double.parse(widget.price);
    int coin = int.parse(widget.itemAmount);
    Account account = widget.account;
    Transaction transaction = Transaction(
      referenceNo: DateTime.now().millisecondsSinceEpoch,
      sender: account.username,
      receiver: 'TikTok Wallet',
      userID: account.userID ?? 0,
      details: 'Purchase $coin Coins',
      amount: amount,
      createdTime: DateTime.now().toIso8601String(),
      status: 'Completed',
    );

    try {
      // Update the account balance
      double newBalance = await DatabaseHelper.instance.deductAccountBalance(account.userID ?? 0, amount);
      int updatedCoinBalance = await DatabaseHelper.instance.addCoinBalance(account.userID ?? 0, coin);

      // Insert the transaction into the database
      await DatabaseHelper.insertTransaction(transaction);

      // Show SnackBar only on successful top-up
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Purchased successfully!'),
        ),
      );

      // Return true to indicate success
      Navigator.pop(context, true);
    } catch (e) {
      // Show error message if any error occurs during transaction processing
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error processing transaction!', style: TextStyle(color: Colors.red)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: const Color.fromARGB(255, 229, 229, 229),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 229, 229, 229),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildPaymentOption('TikTok Wallet'),
            _buildPaymentOption('Credit / Debit Card'),
            _buildPaymentOption('Touch \'n Go eWallet'),
            _buildPaymentOption('Online Banking'),
            SizedBox(height: 20),
            Text(
              'SAVED METHOD(S)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption('$_savedMethod Credit/Debit Card', isSavedMethod: true),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentMethod != null) {
                    if (_selectedPaymentMethod == 'TikTok Wallet') {
                      _showPaymentDialog(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Selected: $_selectedPaymentMethod')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select a payment method')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Confirm Selection',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, {bool isSavedMethod = false}) {
    return ListTile(
      leading: Radio<String>(
        value: title,
        groupValue: _selectedPaymentMethod,
        onChanged: (String? value) {
          setState(() {
            _selectedPaymentMethod = value;
          });
        },
      ),
      title: Text(title),
    );
  }
}

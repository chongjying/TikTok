import 'package:flutter/material.dart';

class PaymentSelectionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentSelectionScreen(),
    );
  }
}

class PaymentSelectionScreen extends StatefulWidget {
  @override
  _PaymentSelectionScreenState createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String? _selectedPaymentMethod;
  final String _savedMethod = '0000 XXXX XXXX 0000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildPaymentOption('TikTok Wallet'),
            _buildPaymentOption('Credit /Debit Card'),
            _buildPaymentOption('Online Banking'),
            _buildPaymentOption('Postpaid (Buy Now, Pay Later)'),
            SizedBox(height: 20),
            Text(
              'SAVED METHOD(S)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption('$_savedMethod Credit/Debit Card',
                isSavedMethod: true),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentMethod != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Selected: $_selectedPaymentMethod')),
                    );
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

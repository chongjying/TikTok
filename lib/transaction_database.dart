import 'package:flutter/material.dart';
import 'tiktok_wallet.dart';

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
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPaymentOption('TikTok Wallet'),
            _buildPaymentOption('Credit /Debit Card'),
            _buildPaymentOption('Touch \'n Go ewallet'),
            _buildPaymentOption('Online Banking'),
            _buildPaymentOption('Postpaid (Buy Now, Pay Later)'),
            const SizedBox(height: 20),
            const Text(
              'SAVED METHOD(S)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            _buildPaymentOption('$_savedMethod Credit/Debit Card',
                isSavedMethod: true),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedPaymentMethod != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Selected: $_selectedPaymentMethod')),
                    );
                    if (_selectedPaymentMethod == 'TikTok Wallet') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TikTokWallet(),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please select a payment method')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
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

void main() {
  runApp(PaymentSelectionApp());
}

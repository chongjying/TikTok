import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tiktok_wallet.dart';

class WalletTopUp extends StatelessWidget {
  const WalletTopUp({Key? key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _amountController = TextEditingController();

    void handleTopUp(int amount) {
      _amountController.text = amount.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Top-up RM$amount'),
        ),
      );
    }

    void handleTopUpSubmit() {
      int amount = int.tryParse(_amountController.text) ?? 0;
      if (amount > 0) {
        // Replace this with actual top-up logic
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Processing top-up of RM$amount...'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter a valid amount.'),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Top Up Amount',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              style: TextStyle(
                  color: Colors.black), // Text color of entered amount
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black87, // Border color
                    width: 2.0, // Border width
                  ),
                ),
                labelText: 'Enter amount',
                labelStyle: TextStyle(color: Colors.black), // Label text color
                hintText: '50',
                hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5)), // Hint text color
                prefixText: 'RM ', // Prefix text to display 'RM'
                prefixStyle:
                    TextStyle(color: Colors.black), // Prefix text color
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly // Accepts only digits
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Amount:',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => handleTopUp(10),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('RM10'),
                ),
                ElevatedButton(
                  onPressed: () => handleTopUp(20),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('RM20'),
                ),
                ElevatedButton(
                  onPressed: () => handleTopUp(50),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('RM50'),
                ),
                ElevatedButton(
                  onPressed: () => handleTopUp(100),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('RM100'),
                ),
                ElevatedButton(
                  onPressed: () => handleTopUp(200),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('RM200'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: handleTopUpSubmit,
              style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Top Up'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transaction_database.dart';

class WalletTopUp extends StatelessWidget {
  const WalletTopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _amountController = TextEditingController();

    void handleTopUp(int amount) {
      _amountController.text = amount.toString();
      // No SnackBar here
    }

    void handleTopUpSubmit() async {
      double _amount = double.tryParse(_amountController.text) ?? 0;
      if (_amount > 0) {
        // Insert the transaction into the database
        Transaction transaction = Transaction(
          referenceNo: DateTime.now().millisecondsSinceEpoch,
          sender: 'User',
          receiver: 'TikTok Wallet',
          details: 'Top-up RM$_amount',
          amount: _amount,
          createdTime: DateTime.now().toIso8601String(),
          status: 'Completed',
        );

        try {
          await insertTransaction(transaction); // Assuming insertTransaction function is defined in transaction_database.dart
          // Show SnackBar only on successful top-up
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Top-up RM$_amount successfully!'),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error processing transaction!', style: TextStyle(color: Colors.red),),
            ),
          );
        }
      } 
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Added Padding widget with back button and title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: const Color.fromARGB(255, 229, 229, 229)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Top Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 48), // Placeholder to balance the row
                  ],
                ),
              ),
              const SizedBox(height: 48), // Adjusted spacing
              const Text(
                'Top Up Amount',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                style: TextStyle(
                  color: Colors.white,
                ), // Text color of entered amount
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white, // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  labelText: 'Enter amount',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ), // Label text color
                  hintText: '50',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                  ), // Hint text color
                  prefixText: 'RM ', // Prefix text to display 'RM'
                  prefixStyle: TextStyle(
                    color: Colors.white,
                  ), // Prefix text color
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Accepts only digits
              ),
              const SizedBox(height: 36),
              const Text(
                'Select Amount:',
                style: TextStyle(
                  color: Colors.white,
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
                      minimumSize: Size(100, 50), // Control width and height
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
                      minimumSize: Size(100, 50), // Control width and height
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
                      minimumSize: Size(100, 50), // Control width and height
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
                      minimumSize: Size(100, 50), // Control width and height
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
                      minimumSize: Size(100, 50), // Control width and height
                    ),
                    child: const Text('RM200'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleTopUpSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color set to red
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  minimumSize: Size(50, 50), // Control width and height
                ),
                child: const Text(
                  'Top Up',
                  style: TextStyle(
                    color: Colors.white, // Text color set to white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'payment.dart';

class LiveRewardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 229, 229, 229)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                SizedBox(height: 100), // Adjust height as needed
                Center(
                  child: Text(
                    'Total Balance',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'RM 0.00',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Accumulated Diamonds: 0',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentSelectionScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Colors.red, // Button background color
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Withdraw',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

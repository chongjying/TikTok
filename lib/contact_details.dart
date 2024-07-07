import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactDetails extends StatelessWidget {
  final String phoneNumber;
  final String name; // Name of the contact
  final IconData accountIcon; // Icon representing the contact's account

  ContactDetails({
    required this.phoneNumber,
    this.name = 'John Doe', // Default name for demonstration
    this.accountIcon = Icons.account_circle, // Default icon for demonstration
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('Contact Details')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center align contents
          children: [
            // Contact Information Section
            Container(
              width: 300,
              height: 200, // Fixed height for the card
              child: Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40, // Adjust size as needed
                        child: Icon(Icons.person, color: Colors.black, size: 50),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        phoneNumber,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Transfer Money Section
            Container(
              height: 150, // Fixed height for the card
              child: Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer Money',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter amount (RM)', // Added "RM"
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.white),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Handle transfer money action
                              final amount = '100'; // Placeholder amount
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Money transferred RM $amount to $name'),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            child: Text('Transfer Money'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

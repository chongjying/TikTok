import 'package:flutter/material.dart';
import 'package:tiktok1/transaction_history.dart'; // Assuming 'transaction.dart' contains the Transaction class
import 'package:tiktok1/transaction_database.dart'; // Adjust import path as per your project structure

class TransactionDetailPage extends StatelessWidget {
  final Transaction transaction;

  const TransactionDetailPage({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 80.0), // Adjusted padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Center(
                  child: Text(
                    'Transaction Details',
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  _buildDetailRow('Details:', '${transaction.details}'),
                  Divider(color: Colors.black54, thickness: 0.3,),
                  SizedBox(height: 10),
                  _buildDetailRow('Created Time:', '${transaction.createdTime}'),
                  Divider(color: Colors.black54, thickness: 0.3,),
                  SizedBox(height: 10),
                  _buildDetailRow('Amount:', 'RM ${transaction.amount}'),
                  Divider(color: Colors.black54, thickness: 0.3,),
                  SizedBox(height: 10),
                  _buildDetailRow('Sender:', '${transaction.sender}'),
                  Divider(color: Colors.black54, thickness: 0.3,),
                  SizedBox(height: 10),
                  _buildDetailRow('Receiver:', '${transaction.receiver}'),
                  Divider(color: Colors.black54, thickness: 0.3,),
                  SizedBox(height: 10),
                  _buildDetailRow('Reference No:', '${transaction.referenceNo}'),
                  Divider(color: Colors.black54, thickness: 0.3,),
                  SizedBox(height: 10),
                  _buildDetailRow('Status:', '${transaction.status}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.white, // Adjust as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120, // Adjust width as needed
            child: Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

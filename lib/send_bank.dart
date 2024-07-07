import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectBankPage(),
    );
  }
}

class SelectBankPage extends StatelessWidget {
  // Example list of banks
  final List<String> banks = [
    'Bank A',
    'Bank B',
    'Bank C',
    // Add more banks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('Select Bank')),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          child: ListView.builder(
            itemCount: banks.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  // Handle bank selection here
                  print('Selected bank: ${banks[index]}');
                },
                child: ListTile(
                  title: Text(banks[index]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_picker/country_picker.dart';
import 'contact_details.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectContactPage(),
      theme: ThemeData.dark(), // Set the theme to dark
    );
  }
}

class SelectContactPage extends StatefulWidget {
  @override
  _SelectContactPageState createState() => _SelectContactPageState();
}

class _SelectContactPageState extends State<SelectContactPage> {
  String _selectedCountryCode = '+60'; // Default country code
  TextEditingController _phoneNumberController = TextEditingController();
  List<Map<String, String>> contacts = [
    {'name': 'John Doe', 'phone': '+60 019-9987657'}, // Example contacts
    {'name': 'Jane Smith', 'phone': '+60 011-2233445'},
    {'name': 'Alice Johnson', 'phone': '+60 012-3456789'},
  ];
  List<Map<String, String>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(contacts);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(child: Text('Contact Page')),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Country Code Container
                GestureDetector(
                  onTap: () {
                    _openCountryPickerDialog(
                        context); // Open country picker dialog
                  },
                  child: Container(
                    width: 90, // Adjust the width as needed
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                    color: Colors.grey[800],
                    child: Row(
                      children: [
                        Text(
                          _selectedCountryCode,
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                    width:
                        10), // Spacer between country code and phone number input

                // Phone Number Input Container
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                    color: Colors.grey[800],
                    child: TextField(
                      controller: _phoneNumberController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) {
                        filterContacts(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height:
                    10), // Spacer between phone number input and "All Contacts" text

            // "All Contacts" Text
            Text(
              'All Contacts',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height:
                    20), // Spacer between "All Contacts" text and contact list

            // Display Contact Items based on filtered contacts
            Expanded(
              child: ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  return ContactItem(
                    name: filteredContacts[index]['name']!,
                    phoneNumber: filteredContacts[index]['phone']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactDetails(
                            phoneNumber: filteredContacts[index]['phone']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCountryPickerDialog(BuildContext context) {
    showCountryPicker(
      context: context,
      showPhoneCode:
          true, // Optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          _selectedCountryCode = '+' + country.phoneCode!;
        });
      },
    );
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredContacts = List.from(contacts);
      });
    } else {
      setState(() {
        filteredContacts = contacts
            .where((contact) =>
                contact['phone']!.contains(query) ||
                contact['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }
}

class ContactItem extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final VoidCallback onTap;

  ContactItem({
    required this.name,
    required this.phoneNumber,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        onEnter: (_) {},
        onExit: (_) {},
        child: Container(
          margin: EdgeInsets.only(bottom: 16.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.black),
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    phoneNumber,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

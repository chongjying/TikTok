import 'package:flutter/material.dart';
import 'database_helper.dart';

class AccountTablePage extends StatefulWidget {
  const AccountTablePage({Key? key}) : super(key: key);

  @override
  _AccountTablePageState createState() => _AccountTablePageState();
}

class _AccountTablePageState extends State<AccountTablePage> {
  late Future<List<Account>> _accountsFuture;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _walletBalanceController = TextEditingController();
  final TextEditingController _coinBalanceController = TextEditingController();
  final TextEditingController _diamondBalanceController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _accountsFuture = DatabaseHelper.instance.getAllAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Table'),
      ),
      body: FutureBuilder<List<Account>>(
        future: _accountsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No accounts found.'));
          } else {
            return Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('UserID')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Wallet Balance')),
                      DataColumn(label: Text('Coin Balance')),
                      DataColumn(label: Text('Diamond Balance')),
                      DataColumn(label: Text('Password')),
                    ],
                    rows: snapshot.data!.map((account) {
                      return DataRow(cells: [
                        DataCell(Text(account.userID.toString())),
                        DataCell(Text(account.username)),
                        DataCell(Text(account.walletBalance.toString())),
                        DataCell(Text(account.coinBalance.toString())),
                        DataCell(Text(account.diamondBalance.toString())),
                        DataCell(Text(account.password)),
                      ]);
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildAddUserForm(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildAddUserForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _walletBalanceController,
              decoration: const InputDecoration(labelText: 'Wallet Balance'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter wallet balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _coinBalanceController,
              decoration: const InputDecoration(labelText: 'Coin Balance'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter coin balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _diamondBalanceController,
              decoration: const InputDecoration(labelText: 'Diamond Balance'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter diamond balance';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Create Account object from form data
                  Account newAccount = Account(
                    username: _usernameController.text.trim(),
                    walletBalance: double.parse(_walletBalanceController.text.trim()),
                    coinBalance: int.parse(_coinBalanceController.text.trim()),
                    diamondBalance: int.parse(_diamondBalanceController.text.trim()),
                    password: _passwordController.text.trim(),
                  );

                  // Insert the new account into the database
                  await DatabaseHelper.insertAccount(newAccount);

                  // Clear form fields after submission
                  _usernameController.clear();
                  _walletBalanceController.clear();
                  _coinBalanceController.clear();
                  _diamondBalanceController.clear();
                  _passwordController.clear();

                  // Refresh account list
                  setState(() {
                    _accountsFuture = DatabaseHelper.instance.getAllAccounts();
                  });
                }
              },
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}

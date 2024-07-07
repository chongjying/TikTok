import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'payment.dart';

class CoinPurchasePage extends StatefulWidget {


  @override
  _CoinPurchasePageState createState() => _CoinPurchasePageState();
    final Account account;

  const CoinPurchasePage({Key? key, required this.account}) : super(key: key);
}

class _CoinPurchasePageState extends State<CoinPurchasePage> {
  late Future<int> coinBalance;
  int? selectedIndex;
  String selectedCoinAmount = '0';
  String selectedPrice = '0';

  @override
  void initState() {
    super.initState();
    coinBalance = _fetchCoinBalance();
  }

  void onBoxSelected(int index, String coinAmount, String price) {
    setState(() {
      selectedIndex = index;
      selectedCoinAmount = coinAmount;
      selectedPrice = price.replaceAll('RM ', '').trim();
    });
  }

  Future<int> _fetchCoinBalance() async {
    // Ensure userID is not null before passing to DatabaseHelper.getBalance()
    if (widget.account.userID != null) {
      return DatabaseHelper.getCoinBalance(widget.account.userID!);
    } else {
      // Handle the case where userID is null (you might want to return a default value or throw an error)
      throw Exception('User ID is null.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        'Coin',
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
            // Coin Balance Row
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 41, 41, 41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/coins.png',
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Coin Balance',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: FutureBuilder<int>(
                      future: coinBalance,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final balance = snapshot.data!;
                          return Text(
                            '${balance}',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return Text(
                            'Loading...', // Placeholder text while waiting for data
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            // Gap between the rows
            SizedBox(
              height: 20,
            ),
            // Selection Boxes Row
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 41, 41, 41),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Recharge',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 228, 228, 228),
                    ),
                  ),
                  Divider(
                    color: Color.fromARGB(255, 228, 228, 228),
                    thickness: 0.3,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: SelectableBox(
                          index: 0,
                          isSelected: selectedIndex == 0,
                          onTap: onBoxSelected,
                          imagePath: 'assets/coins.png',
                          coinAmount: '14',
                          price: 'RM 1.00',
                        ),
                      ),
                      Expanded(
                        child: SelectableBox(
                          index: 1,
                          isSelected: selectedIndex == 1,
                          onTap: onBoxSelected,
                          imagePath: 'assets/coins.png',
                          coinAmount: '65',
                          price: 'RM 4.90',
                        ),
                      ),
                      Expanded(
                        child: SelectableBox(
                          index: 2,
                          isSelected: selectedIndex == 2,
                          onTap: onBoxSelected,
                          imagePath: 'assets/coins.png',
                          coinAmount: '330',
                          price: 'RM 23.90',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: SelectableBox(
                          index: 3,
                          isSelected: selectedIndex == 3,
                          onTap: onBoxSelected,
                          imagePath: 'assets/coins.png',
                          coinAmount: '660',
                          price: 'RM 47.90',
                        ),
                      ),
                      Expanded(
                        child: SelectableBox(
                          index: 4,
                          isSelected: selectedIndex == 4,
                          onTap: onBoxSelected,
                          imagePath: 'assets/coins.png',
                          coinAmount: '1325',
                          price: 'RM 95.90',
                        ),
                      ),
                      Expanded(
                        child: SelectableBox(
                          index: 5,
                          isSelected: selectedIndex == 5,
                          onTap: onBoxSelected,
                          imagePath: 'assets/coins.png',
                          coinAmount: '3333',
                          price: 'RM 238.90',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Purchase Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSelectionScreen(
                          account: widget.account,
                          price: selectedPrice,
                          itemAmount: selectedCoinAmount,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Purchase',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
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

class SelectableBox extends StatelessWidget {
  final int index;
  final bool isSelected;
  final Function(int, String, String) onTap;
  final String imagePath;
  final String coinAmount;
  final String price;

  const SelectableBox({
    Key? key,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.imagePath,
    required this.coinAmount,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index, coinAmount, price),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[100] : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Colors.red : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: Offset(2.0, 2.0),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // First Row: Image and Text side by side
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    coinAmount,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8), // Space between the two rows
              // Second Row: Random price in RM
              Text(
                price,
                style: const TextStyle(
                  color: Color.fromARGB(255, 139, 139, 139),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

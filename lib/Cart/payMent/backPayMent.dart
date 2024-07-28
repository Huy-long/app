import 'package:app_banhang/Cart/payMent/backPage.dart';
import 'package:flutter/material.dart';

class BankPaymentPage extends StatelessWidget {
  final List<String> banks = [
    'Vietcombank',
    'VietinBank',
    'Agribank',
    'Techcombank',
    'BIDV',
    'Sacombank',
    // Add more banks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh Toán Bằng Thẻ Ngân Hàng'),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: banks.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.account_balance, color: Colors.teal),
            title: Text(banks[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BankTransferPage(
                    bankName: banks[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


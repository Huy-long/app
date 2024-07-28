import 'package:app_banhang/Cart/payMent/backPayMent.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn phương thức thanh toán',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 20),
            PaymentMethodOption(
              method: 'Thanh toán khi nhận hàng',
              icon: Icons.payment,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationPage(
                      method: 'Thanh toán khi nhận hàng',
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            PaymentMethodOption(
              method: 'Chuyển khoản qua mã QR',
              icon: Icons.qr_code,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRPaymentPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            PaymentMethodOption(
              method: 'Thanh toán bằng thẻ ngân hàng',
              icon: Icons.credit_card,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BankPaymentPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodOption extends StatelessWidget {
  final String method;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentMethodOption({
    required this.method,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          leading: Icon(icon, color: Colors.teal),
          title: Text(
            method,
            style: TextStyle(fontSize: 16),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ),
      ),
    );
  }
}

class OrderConfirmationPage extends StatelessWidget {
  final String method;

  const OrderConfirmationPage({required this.method});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác Nhận Đơn Hàng'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Bạn đã chọn phương thức: $method',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class QRPaymentPage extends StatefulWidget {
  @override
  _QRPaymentPageState createState() => _QRPaymentPageState();
}

class _QRPaymentPageState extends State<QRPaymentPage> {
  @override
  Widget build(BuildContext context) {
    final qrData = 'https://your-bank-account-info-or-payment-link'; // Thay đổi theo thông tin thực tế

    return Scaffold(
      appBar: AppBar(
        title: Text('Chuyển Khoản Qua Mã QR'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Quét mã QR để chuyển khoản:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 320,
                gapless: false,
              ),
              SizedBox(height: 20),
              Text(
                'Mã QR này chứa thông tin chuyển khoản. Vui lòng quét mã và thực hiện chuyển khoản.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle payment action here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Proceeding to Payment'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
                child: Text(
                  'Thanh toán',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

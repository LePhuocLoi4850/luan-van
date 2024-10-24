import 'package:flutter/material.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

class VNPayTestPage extends StatefulWidget {
  const VNPayTestPage({Key? key}) : super(key: key);

  @override
  State<VNPayTestPage> createState() => _VNPayTestPageState();
}

class _VNPayTestPageState extends State<VNPayTestPage> {
  // Thông tin kết quả thanh toán
  String responseCode = '';
  String transactionStatus = '';
  String message = '';

  // Các tham số thanh toán (thay thế bằng thông tin thực tế của bạn)
  final String vnpTmnCode = 'YOUR_VNPAY_TMN_CODE'; // Mã merchant
  final String vnpHashSecret = 'YOUR_VNPAY_HASH_SECRET'; // Khóa bí mật
  final String vnpReturnUrl = 'YOUR_RETURN_URL'; // URL trả về

  Future<void> _makePayment() async {
    try {
      // Tạo URL thanh toán
      final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
        url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
        version: '2.1.0',
        tmnCode: vnpTmnCode,
        txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
        orderInfo: 'Test thanh toán VNPAY',
        amount: 10000, // Số tiền thanh toán (đơn vị VND)
        returnUrl: vnpReturnUrl,
        ipAdress: '192.168.1.1', // Thay thế bằng IP của thiết bị
        vnpayHashKey: vnpHashSecret,
        vnPayHashType: VNPayHashType.HMACSHA512,
        vnpayExpireDate: DateTime.now().add(const Duration(minutes: 15)),
      );

      // Gọi hàm thanh toán
      final result = await VNPAYFlutter.instance.show(
        paymentUrl: paymentUrl,
        onPaymentSuccess: (params) {
          setState(() {
            responseCode = params['vnp_ResponseCode'] ?? '';
            transactionStatus = _getTransactionStatus(responseCode);
            message = 'Thanh toán thành công!';
          });
        },
        onPaymentError: (params) {
          setState(() {
            responseCode = params['vnp_ResponseCode'] ?? '';
            transactionStatus = _getTransactionStatus(responseCode);
            message = 'Thanh toán thất bại!';
          });
        },
      );

      // In kết quả
    } catch (e) {
      // Xử lý lỗi
      print('Error: $e');
      setState(() {
        message = 'Đã xảy ra lỗi: $e';
      });
    }
  }

  // Hàm chuyển đổi mã response code sang trạng thái giao dịch
  String _getTransactionStatus(String responseCode) {
    switch (responseCode) {
      case '00':
        return 'Thành công';
      case '01':
        return 'Giao dịch bị lỗi';
      case '02':
        return 'Ngân hàng từ chối giao dịch';
      case '03':
        return 'Mã đơn vị không tồn tại';
      case '04':
        return 'Không đúng định dạng mã đơn vị';
      case '05':
        return 'Không đúng định dạng ngày thanh toán';
      case '06':
        return 'Giao dịch không tồn tại';
      case '07':
        return 'Sai mật khẩu';
      case '08':
        return 'Quá hạn mức giao dịch';
      case '09':
        return 'Loại thẻ không tồn tại';
      case '10':
        return 'Loại thẻ không được chấp nhận';
      case '11':
        return 'Số thẻ không tồn tại';
      case '12':
        return 'Thẻ đã hết hạn';
      case '13':
        return 'Thẻ chưa được kích hoạt hoặc bị khóa';
      case '24':
        return 'Giao dịch bị nghi ngờ gian lận';
      case '51':
        return 'Số dư tài khoản không đủ';
      case '65':
        return 'Số lần thử mật khẩu vượt quá giới hạn';
      case '75':
        return 'Ngân hàng thanh toán đang bảo trì';
      case '99':
        return 'Người dùng hủy giao dịch';
      default:
        return 'Lỗi không xác định';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VNPAY Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _makePayment,
              child: const Text('Thực hiện thanh toán'),
            ),
            const SizedBox(height: 20),
            Text('Response Code: $responseCode'),
            Text('Trạng thái: $transactionStatus'),
            Text('Message: $message'),
          ],
        ),
      ),
    );
  }
}

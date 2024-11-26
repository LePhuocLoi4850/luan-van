import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String?> createMomoPayment(
      {required int amount, required String orderInfo}) async {
    final url = Uri.parse(
        'http://10.0.2.2:5000/payment'); // Thay thế bằng địa chỉ server Node.js của bạn
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': amount,
          'orderInfo': orderInfo,
        }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final payUrl = data['payUrl'];
      return payUrl;
    } else {
      // Xử lý lỗi
      print('Failed to create MoMo payment: ${response.body}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ví dụ MoMo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final payUrl = await createMomoPayment(
              amount: 50000,
              orderInfo: 'Thanh toán đơn hàng',
            );
            if (payUrl != null) {
              Get.toNamed("/vnpay", arguments: payUrl);
            }
          },
          child: const Text('Thanh toán với MoMo'),
        ),
      ),
    );
  }
}

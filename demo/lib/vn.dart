import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'web.dart';

class VNPayScreen extends StatefulWidget {
  @override
  _VNPayScreenState createState() => _VNPayScreenState();
}

class _VNPayScreenState extends State<VNPayScreen> {
  Future<void> _createPaymentUrl() async {
    final url = Uri.parse('http://10.0.2.2:8888/order/create_payment_url');
    final headers = {'Content-Type': 'application/json'};
    final body = {
      "amount": 10000,
      "bankCode": 'NCB',
      "locale": 'vn',
    };
    final jsonBody = jsonEncode(body);
    try {
      final response = await http.post(url, headers: headers, body: jsonBody);

      if (response.statusCode == 302) {
        // Lấy URL từ header 'Location'
        String? location = response.headers['location'];
        if (location != null) {
          Get.to(() => Web(), arguments: location);
        } else {
          print('Không tìm thấy header Location');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // Xử lý lỗi
      print('Error: $e');
      // Hiển thị thông báo lỗi cho người dùng
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kết nối với server Node.js"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _createPaymentUrl,
          child: Text('Tạo URL thanh toán'),
        ),
      ),
    );
  }
}

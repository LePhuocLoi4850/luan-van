import 'package:http/http.dart' as http;
import 'dart:convert';

class VNPayService {
  static const String baseUrl = "http://10.0.2.2:8888/order/create_payment_url";

  static Future<String?> createPaymentUrl(String orderInfo, int amount) async {
    try {
      // Tạo URI từ baseUrl
      final uri = Uri.parse("$baseUrl/vnpay_payment");

      // Dữ liệu body
      final requestBody = jsonEncode({
        'orderInfo': orderInfo,
        'amount': amount,
        'ipAddr': '127.0.0.1',
      });

      // Gửi yêu cầu POST
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      // Xử lý kết quả
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data["paymentUrl"] != null) {
          return data["paymentUrl"];
        } else {
          throw Exception("Phản hồi không hợp lệ từ server: ${response.body}");
        }
      } else {
        throw Exception(
            "Lỗi server: ${response.statusCode}, Nội dung: ${response.body}");
      }
    } catch (e) {
      // Log lỗi chi tiết hơn để dễ dàng debug
      print("Lỗi khi tạo URL thanh toán: $e");
      return null;
    }
  }
}

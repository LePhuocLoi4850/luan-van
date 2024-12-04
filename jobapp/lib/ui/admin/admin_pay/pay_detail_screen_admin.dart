import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PayDetailScreenAdmin extends StatefulWidget {
  const PayDetailScreenAdmin({super.key});

  @override
  State<PayDetailScreenAdmin> createState() => _PayDetailScreenAdminState();
}

class _PayDetailScreenAdminState extends State<PayDetailScreenAdmin> {
  Map<String, dynamic> data = {};
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.purple, Colors.red],
                        ).createShader(bounds),
                        child: const Text(
                          'NowCV',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Hóa đơn số: ${data['pay_id']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        data['day_order'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    'HÓA ĐƠN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Text(
                data['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Số điện thoại của khách hàng: +84 912 345 678'),
              Text('Địa chỉ của khách hàng: 123 Đường ABC, Thành phố DEF'),

              SizedBox(height: 20),

              // Bảng chi tiết
              Table(
                border: TableBorder.all(),
                columnWidths: {
                  0: FixedColumnWidth(100),
                  1: FixedColumnWidth(100),
                  2: FixedColumnWidth(100),
                  3: FixedColumnWidth(100),
                },
                children: [
                  TableRow(
                    children: [
                      _buildTableCell('HẠNG MỤC', true),
                      _buildTableCell('SỐ LƯỢNG', true),
                      _buildTableCell('ĐƠN GIÁ', true),
                      _buildTableCell('THÀNH TIỀN', true),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell(data['sv_name']),
                      _buildTableCell('1'),
                      _buildTableCell(data['price'].toString()),
                      _buildTableCell(data['price'].toString()),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text('Tổng cộng: ${data['price'].toString()}'),
              SizedBox(height: 20),
              Text(
                'THÔNG TIN THANH TOÁN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                  'Ngân hàng VB | Từ tài khoản Công ty ${data['name']} | Số tài khoản: 33-456-7890'),
              Text('Hình thức thanh toán: Thẻ ATM'),
              Text('Mô hình thanh toán: MoMo'),

              SizedBox(height: 20),

              // Footer
              Text(
                  'www.nowcv.vn | 123 Đường ABC, Thành phố DEF | +84 912 345 678'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, [bool isBold = false]) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

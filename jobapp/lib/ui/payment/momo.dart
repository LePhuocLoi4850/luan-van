import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class Momo extends StatefulWidget {
  const Momo({Key? key}) : super(key: key);

  @override
  State<Momo> createState() => _MomoState();
}

class _MomoState extends State<Momo> {
  final AuthController controller = Get.find<AuthController>();
  List<Map<String, dynamic>> _allService = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchAllService();
  }

  Future<void> fetchAllService() async {
    setState(() {
      isLoading = true;
    });
    try {
      _allService = await Database().fetchAllService();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String?> createMomoPayment({
    required String orderInfo,
    required int sv_id,
    required int cid,
    required String name,
    required String sv_name,
    required int sv_price,
  }) async {
    final url = Uri.parse('http://10.0.2.2:5000/payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'orderInfo': orderInfo,
        'sv_id': sv_id,
        'cid': cid,
        'name': name,
        'sv_name': sv_name,
        'sv_price': sv_price,
      }),
    );

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
        title: const Text('Các gói dịch vụ'),
      ),
      body: Container(
        color: Colors.grey[300],
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _allService.isEmpty
                ? Center(
                    child: Text('Không có dịch vụ nào đang hoat động'),
                  )
                : ListView.builder(
                    itemCount: _allService.length,
                    itemBuilder: (context, index) {
                      final sv = _allService[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: 170,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        sv['sv_name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '${sv['sv_price']} VNĐ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: SizedBox(
                                      width: 300,
                                      child: Text(sv['sv_description'])),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          final payUrl =
                                              await createMomoPayment(
                                                  orderInfo:
                                                      'Thanh toán đơn hàng',
                                                  sv_id: sv['sv_id'],
                                                  cid: controller
                                                      .companyModel.value.id!,
                                                  name: controller
                                                      .companyModel.value.name!,
                                                  sv_name: sv['sv_name'],
                                                  sv_price: int.parse(
                                                      sv['sv_price']
                                                          .replaceAll('.', '')
                                                          .replaceAll(
                                                              ',', '')));
                                          if (payUrl != null) {
                                            Map<String, dynamic> data = {
                                              'url': payUrl,
                                              'sv_id': sv['sv_id'],
                                              'cid': controller
                                                  .companyModel.value.id!,
                                              'name': controller
                                                  .companyModel.value.name!,
                                              'sv_name': sv['sv_name'],
                                              'sv_price': int.parse(
                                                  sv['sv_price'].replaceAll(
                                                      RegExp(r'[^0-9]'), ''))
                                            };
                                            Get.toNamed("/web",
                                                arguments: data);
                                          }
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.grey[200],
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 10), // Padding
                                          textStyle: TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold), // Font chữ
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        child: Text(
                                          'Mua Ngay',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

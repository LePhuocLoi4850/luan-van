import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../server/database.dart';

class AdminPay extends StatefulWidget {
  const AdminPay({super.key});

  @override
  State<AdminPay> createState() => _AdminPayState();
}

class _AdminPayState extends State<AdminPay> {
  List<Map<String, dynamic>> _allPayData = [];
  List<Map<String, dynamic>> payData = [];
  String _selectedInterval = 'all';
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      _allPayData = await Database().fetchAllPayment();
      _filterPayData(_selectedInterval);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetch data admin: $e');
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách đơn hàng'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String interval) {
              setState(() {
                _selectedInterval = interval;
                _filterPayData(_selectedInterval);
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'all',
                child: Text('Tất cả'),
              ),
              const PopupMenuItem<String>(
                value: 'week',
                child: Text('Tuần'),
              ),
              const PopupMenuItem<String>(
                value: 'month',
                child: Text('Tháng'),
              ),
              const PopupMenuItem<String>(
                value: 'year',
                child: Text('Năm'),
              ),
            ],
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: payData.length,
              itemBuilder: (context, index) {
                final pay = payData[index];
                return GestureDetector(
                  onTap: () {
                    Map<String, dynamic> data = {
                      'pay_id': pay['pay_id'],
                      'day_order': pay['day_order'],
                      'sv_name': pay['sv_name'],
                      'price': pay['price'],
                      'pay': pay['pay'],
                      'cid': pay['cid'],
                      'name': pay['name'],
                    };
                    Get.toNamed('/payDetailScreenAdmin', arguments: data);
                  },
                  child: Card(
                    elevation: 1,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(15),
                      leading: Icon(
                        Icons.shopify_outlined,
                        color: Colors.blue,
                        size: 40,
                      ),
                      title: Text(
                        pay['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${formatCurrency(pay['price'].toDouble())} VND',
                            style: TextStyle(
                              color:
                                  Colors.green, // Màu xanh lá cây cho giá tiền
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                .format(pay['day_order']),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios,
                          size: 18), // Thêm icon mũi tên
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _filterPayData(String interval) {
    setState(() {
      switch (interval) {
        case 'week':
          payData = _allPayData.where((pay) {
            DateTime now = DateTime.now();
            DateTime firstDayOfCurrentWeek =
                now.subtract(Duration(days: now.weekday - 1));
            DateTime lastDayOfCurrentWeek =
                firstDayOfCurrentWeek.add(Duration(days: 6));
            return pay['day_order'].isAfter(firstDayOfCurrentWeek) &&
                pay['day_order'].isBefore(lastDayOfCurrentWeek);
          }).toList();
          break;
        case 'month':
          payData = _allPayData.where((pay) {
            DateTime now = DateTime.now();
            return pay['day_order'].month == now.month &&
                pay['day_order'].year == now.year;
          }).toList();
          break;
        case 'year':
          payData = _allPayData.where((pay) {
            DateTime now = DateTime.now();
            return pay['day_order'].year == now.year;
          }).toList();
          break;
        default:
          payData = List.from(_allPayData);
      }
    });
  }
}

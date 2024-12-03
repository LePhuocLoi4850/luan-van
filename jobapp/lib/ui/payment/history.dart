import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  AuthController controller = Get.find<AuthController>();
  List<Map<String, dynamic>> _historyList = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      isLoading = true;
    });
    int cid = controller.companyModel.value.id!;
    try {
      _historyList = await Database().fetchHistoryPayment(cid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch sử thanh toán'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _historyList.length,
              itemBuilder: (context, index) {
                final history = _historyList[index];
                return Card(
                  // Sử dụng Card để tạo viền và bo góc
                  elevation: 2, // Độ nổi của Card
                  margin: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16), // Khoảng cách giữa các Card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo góc Card
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(
                        16), // Khoảng cách nội dung trong ListTile
                    leading: Icon(Icons.payment, size: 30), // Icon thanh toán
                    title: Text(
                      history['sv_name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      // Sử dụng Column để căn chỉnh subtitle
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${history['price']} VNĐ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 4), // Khoảng cách giữa giá và ngày
                        Text(
                          '${history['day_order']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    trailing: Container(
                      // Container cho trạng thái
                      padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16), // Padding cho trạng thái
                      decoration: BoxDecoration(
                        color: history['status']
                            ? Colors.red[100]
                            : Colors.green[100], // Màu nền theo trạng thái
                        borderRadius:
                            BorderRadius.circular(20), // Bo góc trạng thái
                      ),
                      child: Text(
                        history['status'] ? 'Thất bại' : 'Thành công',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: history['status']
                              ? Colors.red
                              : Colors.green, // Màu chữ theo trạng thái
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

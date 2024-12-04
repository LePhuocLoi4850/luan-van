import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../server/database.dart';

class JobDetailAdmin extends StatefulWidget {
  const JobDetailAdmin({super.key});

  @override
  State<JobDetailAdmin> createState() => _JobDetailAdminState();
}

class _JobDetailAdminState extends State<JobDetailAdmin>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> job = {};
  List<Map<String, dynamic>> applyList = [];
  bool isLoading = false;
  String? salary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final jid = Get.arguments as int;
      job = await Database().fetchJobDetailAdmin(jid);
      applyList = await Database().fetchAppliesForJob(jid);
      salary = '${job['salary_from']} - ${job['salary_to']} Triệu';
    } catch (e) {
      print('Fetch data error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết công việc'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Thông tin'),
            Tab(text: 'Hồ sơ ứng tuyển'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildJobInfo(),
                _buildApplyList(),
              ],
            ),
    );
  }

  Widget _buildJobInfo() {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue, // Màu sắc border
            width: 1, // Độ dày border
          ),
          borderRadius: BorderRadius.circular(15), // Bo góc
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Tiêu đề:', job['title']),
              _buildInfoRow('Công ty:', job['nameC']),
              _buildInfoRow('Mức lương:', '$salary VND'),
              _buildInfoRow('Địa chỉ:', job['address']),
              _buildInfoRow('Kinh nghiệm:', job['experience']),
              _buildInfoRow('Mô tả:', job['description']),
              _buildInfoRow('Yêu cầu:', job['request']),
              _buildInfoRow('Quyền lợi:', job['interest']),
              _buildInfoRow('Hạn chót:',
                  DateFormat('dd/MM/yyyy').format(job['expiration_date'])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplyList() {
    return applyList.isEmpty
        ? const Center(
            child: Text('Chưa có hồ sơ ứng tuyển nào cho công việc này.'))
        : ListView.builder(
            itemCount: applyList.length,
            itemBuilder: (context, index) {
              final apply = applyList[index];
              return Container(
                color: getStatusBackgroundColor(apply['status']),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageFromBase64String(apply['image']),
                  ),
                  title: Text(
                    apply['nameu'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    children: [
                      Text(apply['title']),
                      Text(
                          'Ngày ứng tuyển: ${DateFormat('dd/MM/yyyy').format(apply['apply_date'])}'),
                    ],
                  ),
                  trailing: Icon(
                    Status.getIcon(apply['status']),
                    color: Status.getColor(apply['status']),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value ?? 'Chưa cập nhật',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color getStatusBackgroundColor(String status) {
    switch (status) {
      case 'applied':
        return Colors.yellow[50]!; // Màu vàng nhạt
      case 'rejected':
        return Colors.red[50]!; // Màu đỏ nhạt
      default:
        return Colors.green[50]!; // Màu xanh lá cây nhạt
    }
  }

  Widget imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return Image.asset(
        'assets/images/user.png',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 60, // Điều chỉnh kích thước ảnh
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Xử lý lỗi khi giải mã base64
          print('Error loading image: $error');
          return Image.asset(
            'assets/images/user.png', // Hiển thị ảnh mặc định
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          );
        },
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return Image.asset(
        'assets/images/user.png', // Hiển thị ảnh mặc định
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
  }
}

class Status {
  static IconData getIcon(String status) {
    switch (status) {
      case 'applied':
        return Icons.av_timer;
      case 'rejected':
        return Icons.cancel_sharp;
      default:
        return Icons.check_box;
    }
  }

  static Color getColor(String status) {
    switch (status) {
      case 'applied':
        return Colors.yellow;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}

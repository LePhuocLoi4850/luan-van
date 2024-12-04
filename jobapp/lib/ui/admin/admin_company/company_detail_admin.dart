import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/server/database.dart';

class CompanyDetailAdmin extends StatefulWidget {
  const CompanyDetailAdmin({super.key});

  @override
  State<CompanyDetailAdmin> createState() => _CompanyDetailAdminState();
}

class _CompanyDetailAdminState extends State<CompanyDetailAdmin>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> company = {};
  List<Map<String, dynamic>> jobList = [];
  List<Map<String, dynamic>> applyList = [];
  bool isLoading = false;
  String? salary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      final cid = Get.arguments as int;
      applyList = await Database().fetchAppliesForCompany(cid);
      print(applyList);
      company = await Database().fetchUserDataByCid(cid);
      jobList = await Database().fetchAllJobForCid(cid, false);
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
        title: const Text('Chi tiết công ty'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Thông tin'),
            Tab(text: 'Việc làm'),
            Tab(text: 'Hồ sơ ứng tuyển'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Thông tin công ty
                _buildCompanyInfo(),

                // Tab 2: Việc làm của công ty
                _buildJobList(),

                // Tab 3: Hồ sơ ứng tuyển
                _buildApplyList(),
              ],
            ),
    );
  }

  Widget _buildCompanyInfo() {
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
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: MemoryImage(base64Decode(company['image'])),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Tên công ty:', company['name']),
              _buildInfoRow('Email:', company['email']),
              _buildInfoRow('Số điện thoại:', company['phone']),
              _buildInfoRow('Địa chỉ:', company['address']),
              _buildInfoRow('Quy mô:', company['scale']),
              _buildInfoRow('Mô tả:', company['description']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobList() {
    return jobList.isEmpty
        ? const Center(child: Text('Công ty này chưa đăng tuyển việc làm nào.'))
        : ListView.builder(
            itemCount: jobList.length,
            itemBuilder: (context, index) {
              final job = jobList[index];
              salary = '${job['salaryFrom']} - ${job['salaryTo']} Triệu';
              int lastCommaIndex = job['address'].lastIndexOf(",");
              final address =
                  job['address'].substring(lastCommaIndex + 1).trim();
              return Card(
                elevation: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: const Color.fromARGB(255, 142, 201, 248),
                      ),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageFromBase64String(job['image']),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${job['title']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  job['nameC'],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 124, 124, 124)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 85.0, top: 5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    address,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    job['experience'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 85.0, top: 5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_money_outlined,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        salary!,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                                'Hạn chót ứng tuyển: ${DateFormat('dd/MM/yyyy').format(job['expiration_date'])}'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _buildApplyList() {
    return applyList.isEmpty
        ? const Center(
            child: Text('Chưa có hồ sơ ứng tuyển nào cho công ty này.'))
        : ListView.builder(
            itemCount: applyList.length,
            itemBuilder: (context, index) {
              final apply = applyList[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: getStatusBackgroundColor(apply['status']),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageFromBase64String(apply['image']),
                    ),
                    title: Text(
                      apply['nameu'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
              );
            },
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

  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return const Image(
        image: AssetImage('assets/images/user.png'),
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

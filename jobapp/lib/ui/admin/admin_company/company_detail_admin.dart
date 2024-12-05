import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
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
  List<Map<String, dynamic>> _allPayData = [];
  List<Map<String, dynamic>> payData = [];
  String _selectedInterval = 'all';
  bool isLoading = false;
  String? salary;
  int? cid;
  bool showActiveJobs = true;
  bool showHiddenJobs = true;
  String? _currentFilter;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    cid = Get.arguments;
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
      company = await Database().fetchUserDataByCid(cid);
      jobList = await Database().fetchAllJobForCidAdmin(cid);
      _allPayData = await Database().fetchAllPayment();
      _filterPayData(_selectedInterval);
    } catch (e) {
      print('Fetch data error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
            Tab(text: 'Hóa đơn')
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCompanyInfo(),
                _buildJobList(),
                _buildApplyList(),
                _buildPay(),
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

  BoxDecoration _getServiceDayBorder(String? serviceDay) {
    if (serviceDay != null && serviceDay.isNotEmpty) {
      try {
        DateTime serviceDate = DateTime.parse(serviceDay);
        if (serviceDate.isAfter(DateTime.now())) {
          return BoxDecoration(
            border: GradientBoxBorder(
              width: 3,
              gradient: LinearGradient(
                colors: [Colors.red, Colors.yellow, Colors.green, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            borderRadius: BorderRadius.circular(8),
          );
        }
      } catch (e) {
        print('Error parsing service_day: $e');
      }
    }
    return BoxDecoration();
  }

  Widget _buildJobList() {
    return jobList.isEmpty
        ? const Center(child: Text('Công ty này chưa đăng tuyển việc làm nào.'))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              PopupMenuButton<String>(
                initialValue: _currentFilter,
                onSelected: (String filter) {
                  setState(() {
                    _currentFilter = filter;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Tất cả',
                      child: Text('Tất cả'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Đã ẩn',
                      child: Text('Đã ẩn'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Hoạt động',
                      child: Text('Hoạt động'),
                    ),
                  ];
                },
                child: ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text(_currentFilter ?? 'Thống kê'),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: jobList.length,
                  itemBuilder: (context, index) {
                    final job = jobList[index];
                    salary = '${job['salaryFrom']} - ${job['salaryTo']} Triệu';

                    if (_currentFilter == 'Đã ẩn' && job['status'] != true) {
                      return const SizedBox.shrink();
                    } else if (_currentFilter == 'Hoạt động' &&
                        job['status'] != false) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/jobDetailAdmin', arguments: job['jid']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Container(
                              decoration: _getServiceDayBorder(
                                  job['service_day'].toString()),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: imageFromBase64String(job['image']),
                              ),
                            ),
                            title: Text(
                              job['title'],
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(job['nameC']),
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Icon(Icons.person_2),
                                    Text(job['num_apply'].toString()),
                                  ],
                                ),
                                Text(
                                    'Hết hạn: ${DateFormat('dd/MM/yyyy').format(job['expiration_date'])}'),
                              ],
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(7.0),
                              decoration: BoxDecoration(
                                color: job['status'] == false
                                    ? Colors.green[50]
                                    : Colors.red[50],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () async {
                                  await Database()
                                      .deleteJob(job['jid'], !job['status']);
                                  setState(() {
                                    job['status'] = !job['status'];
                                  });
                                },
                                child: Text(
                                  job['status'] == false
                                      ? 'Hoạt động'
                                      : 'Đã ẩn',
                                  style: TextStyle(
                                    color: job['status'] == false
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
              return GestureDetector(
                onTap: () {
                  Map<String, dynamic> data = {
                    'uid': apply['uid'],
                    'jid': apply['jid'],
                    'title': apply['title'],
                    'name': apply['nameu'],
                    'image': apply['image'],
                  };
                  Get.toNamed('/uvDetailAdmin', arguments: data);
                },
                child: Padding(
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                ),
              );
            },
          );
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(amount);
  }

  Widget _buildPay() {
    return applyList.isEmpty
        ? const Center(
            child: Text('Chưa có hồ sơ ứng tuyển nào cho công ty này.'))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
                    child: Text('Tuần này'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'month',
                    child: Text('Tháng này'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'year',
                    child: Text('Năm này'),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
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
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                  color: Colors
                                      .green, // Màu xanh lá cây cho giá tiền
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
              ),
            ],
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';

import '../../../controller/user_controller.dart';
import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

class AdminCompany extends StatefulWidget {
  const AdminCompany({super.key});

  @override
  State<AdminCompany> createState() => _AdminCompanyState();
}

class _AdminCompanyState extends State<AdminCompany> {
  AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  List<Map<String, dynamic>> _allCompany = [];
  bool isLoading = false;
  String? _currentFilter;
  @override
  void initState() {
    super.initState();
    fetchAllCompany();
  }

  void fetchAllCompany() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      _allCompany = await Database().fetchAllCompanyAdmin();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công ty'),
        actions: [
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
                  value: 'Hoạt động',
                  child: Text('Hoạt động'),
                ),
                const PopupMenuItem<String>(
                  value: 'Bị khóa',
                  child: Text('Bị khóa'),
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
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: _allCompany.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final company = _allCompany[index];
                  if (_currentFilter == 'Hoạt động' &&
                      company['status'] != false) {
                    return const SizedBox.shrink();
                  } else if (_currentFilter == 'Bị khóa' &&
                      company['status'] != true) {
                    return const SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/companyDetailAdmin',
                          arguments: company['cid']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Container(
                          decoration: _getServiceDayBorder(
                              company['service_day'].toString()),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: imageFromBase64String(company['image']),
                          ),
                        ),
                        title: Text(company['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Ngày tạo: ${DateFormat('dd/MM/yyyy').format(company['created_at'])}'),
                            Text('Việc làm đã đăng: ${company['countJ']}'),
                            Text('Số lượng hồ sơ: ${company['countU']}'),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            await Database().updateAuthStatus(
                                company['email'], !company['status']);
                            setState(() {
                              company['status'] = !company['status'];
                            });
                          },
                          icon: Icon(
                            company['status']
                                ? Icons.lock
                                : Icons.lock_open, // Chọn icon dựa trên status
                            color: company['status']
                                ? Colors.yellow
                                : Colors.black, // Chọn màu dựa trên status
                          ),
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

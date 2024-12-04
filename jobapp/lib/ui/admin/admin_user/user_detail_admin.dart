import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UserDetailAdmin extends StatefulWidget {
  const UserDetailAdmin({super.key});

  @override
  State<UserDetailAdmin> createState() => _UserDetailAdminState();
}

class _UserDetailAdminState extends State<UserDetailAdmin>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> applyList = [];
  List<Map<String, dynamic>> certificateData = [];
  List<Map<String, dynamic>> experienceData = [];
  List<Map<String, dynamic>> skillData = [];
  List<Map<String, dynamic>> educationData = [];
  List<Map<String, dynamic>> cvUploadData = [];
  bool isLoading = false;
  int? uid;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchData();
    uid = Get.arguments;
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
      final uid = Get.arguments as int;
      cvUploadData = await Database().fetchAllCvForUid(uid);
      userData = await Database().fetchUserDataForUid(uid);
      applyList = await Database().fetchApplyForUid(uid);
      certificateData = await Database().fetchCertificate(uid);
      experienceData = await Database().fetchExperience(uid);
      skillData = await Database().fetchSkill(uid);
      educationData = await Database().fetchEducation(uid);
    } catch (e) {
      print('Fetch data error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchPdf(String pdf) async {
    try {
      if (pdf.isEmpty) {
        return;
      } else {
        Get.to(
          () => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SfPdfViewer.memory(
              base64Decode(pdf),
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết ứng viên'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Thông tin'),
            Tab(text: 'Hồ sơ ứng tuyển'),
            Tab(
              text: 'Danh sách cv',
            )
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildUserInfo(),
                _buildApplyList(),
                _buildListCV(),
              ],
            ),
    );
  }

  Widget _buildListCV() {
    return applyList.isEmpty
        ? const Center(child: Text('Ứng viên này chưa có cv upload nào.'))
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Now CV_Profile'),
                      TextButton(
                        onPressed: () async {
                          Get.toNamed('/cvProfileScreen', arguments: uid);
                        },
                        child: Text(
                          'Xem',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: cvUploadData.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final cv = cvUploadData[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            cv['nameCv'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(cv['time']),
                          trailing: TextButton(
                            onPressed: () async {
                              fetchPdf(cv['pdf']);
                            },
                            child: Text(
                              'Xem',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
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

  Widget _buildUserInfo() {
    return SingleChildScrollView(
      child: Card(
        elevation: 0.0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                ),
                                child: ClipOval(
                                  child: imageFromBase64String(
                                    userData['image'],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    userData['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '22 Tuổi',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Giới tính:${userData['gender']}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THÔNG TIN LIÊN HỆ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Điện thoại: ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            userData['phone'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Email: ',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            userData['email'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          child: Text(
                            'Địa chỉ: ',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            userData['address'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THÔNG TIN CHUNG',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Ngành nghề: ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            userData['career'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Kinh nghiệm: ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            userData['experience'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        const Text(
                          'Mức lương: ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            '${userData['salary_from']} - ${userData['salary_to']} Triệu',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  experienceData.isEmpty
                      ? const SizedBox(
                          width: 10,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const Text(
                              'Kinh nghiệm làm việc',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: experienceData.length,
                              itemBuilder: (context, index) {
                                final cv = experienceData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cv['position'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              cv['nameCompany'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(cv['time_from'].toString()))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cv['time_to'].toString()))}',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  educationData.isEmpty
                      ? const SizedBox(
                          width: 10,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const Text(
                              'Học vấn',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: educationData.length,
                              itemBuilder: (context, index) {
                                final cv = educationData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cv['name'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              cv['career'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(cv['time_from'].toString()))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cv['time_to'].toString()))}',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  certificateData.isEmpty
                      ? const SizedBox(
                          width: 10,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const Text(
                              'Chứng chỉ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: certificateData.length,
                              itemBuilder: (context, index) {
                                final cv = certificateData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cv['nameCertificate'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              cv['nameHost'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              '${DateFormat('dd/MM/yyyy').format(DateTime.parse(cv['time_from'].toString()))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(cv['time_to'].toString()))}',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                  skillData.isEmpty
                      ? const SizedBox(
                          width: 10,
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const Text(
                              'Kỹ năng',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: skillData.length,
                              itemBuilder: (context, index) {
                                final cv = skillData[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              cv['nameSkill'],
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            RatingBar.builder(
                                              initialRating:
                                                  cv['rating'].toDouble(),
                                              ignoreGestures: true,
                                              direction: Axis.horizontal,
                                              allowHalfRating: false,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplyList() {
    return applyList.isEmpty
        ? const Center(
            child: Text('Ứng viên này chưa ứng tuyển vào công việc nào.'))
        : ListView.separated(
            itemCount: applyList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final apply = applyList[index];
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      apply['title'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(apply['namec']),
                    trailing: Text(
                      getStatus(apply['status']),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          );
  }

  String getStatus(String status) {
    switch (status) {
      case 'applied':
        return 'Đang chờ duyệt';
      case 'rejected':
        return 'Đã bị từ chối';
      default:
        return 'Đã nhận';
    }
  }

  Widget imageFromBase64String(String base64String) {
    // Thay đổi kiểu trả về thành Widget
    if (base64String.isEmpty || base64String == 'null') {
      return Image.asset(
        'assets/images/user.png', // Sử dụng Image.asset
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

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class ProfileUVScreen extends StatefulWidget {
  const ProfileUVScreen({super.key});

  @override
  State<ProfileUVScreen> createState() => _ProfileUVScreenState();
}

class _ProfileUVScreenState extends State<ProfileUVScreen> {
  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  List<dynamic> kn = [
    'Sắp đi làm',
    '1 năm',
    '2 năm',
    '3 năm',
    '4 năm',
    '5 năm'
  ];
  List<String> item = [
    'Việc làm đã ứng tuyển',
    'Việc làm đã lưu',
    'Việc làm phù hợp',
    'NTD đã xem hồ sơ'
  ];

  @override
  void initState() {
    super.initState();
    userController.getUserData(controller.userModel.value.id!);
  }

  void updateContactStatus(bool status) async {
    int uid = controller.userModel.value.id!;
    try {
      await Database().updateContactStatus(uid, status);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _logout() async {
    await controller.logout();
    // userController.clearFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.blue,
            pinned: true,
            floating: false,
            expandedHeight: 120,
            elevation: 10,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: const EdgeInsets.all(10),
              title: Obx(() {
                return Row(
                  children: [
                    ClipOval(
                      child: imageFromBase64String(
                        controller.userModel.value.image.toString(),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Hello ',
                        style: const TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                            text: controller.userModel.value.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.person_pin_rounded,
                        size: 35,
                        color: Colors.blue,
                      ),
                      const Expanded(
                        child: Text(
                          'Cho phép NTD liên hệ',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Obx(
                        () => CupertinoSwitch(
                          activeColor: Colors.blue,
                          trackColor: Colors.grey[400],
                          value: userController.isSwitchContact.value,
                          onChanged: (value) {
                            userController.isSwitchContact.value = value;
                            updateContactStatus(value);
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 5,
              color: Colors.grey[200],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'Cài đặt tài khoản',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 410,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/a');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.person_sharp,
                                  size: 35, color: Colors.grey),
                              Expanded(
                                child: Text(
                                  'Thông tin tài khoản',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(Icons.chevron_right_outlined,
                                  size: 35, color: Colors.grey)
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[200],
                        ),
                        GestureDetector(
                          onTap: () {
                            print('nice');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.lock, size: 35, color: Colors.grey),
                              Expanded(
                                child: Text(
                                  'Chính sách bảo mật',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(Icons.chevron_right_outlined,
                                  size: 35, color: Colors.grey)
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[200],
                        ),
                        GestureDetector(
                          onTap: () {
                            print('nice');
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.phone_in_talk_sharp,
                                  size: 35, color: Colors.grey),
                              Expanded(
                                child: Text(
                                  'Trợ giúp',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Icon(Icons.chevron_right_outlined,
                                  size: 35, color: Colors.grey)
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 5,
              color: Colors.grey[200],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      _logout();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đăng Xuất  ',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Icon(Icons.logout, color: Colors.black)
                      ],
                    ),
                  ),
                ),
              ),
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
        fit: BoxFit.cover,
      );
    }
    try {
      return Image.memory(
        width: 80,
        height: 80,
        base64Decode(base64String),
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding Base64 image: $e');
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }
  }
}

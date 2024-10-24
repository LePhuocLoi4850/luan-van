import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import 'category.dart';

class HomeNTD extends StatefulWidget {
  const HomeNTD({super.key});

  @override
  State<HomeNTD> createState() => _HomeNTDState();
}

class _HomeNTDState extends State<HomeNTD> {
  final AuthController controller = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
  }

  Image imageFromBase64String(String base64String) {
    if (base64String.isEmpty || base64String == 'null') {
      return const Image(
        image: AssetImage('assets/images/user.png'),
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }

    try {
      return Image.memory(
        base64Decode(base64String),
        width: 60,
        height: 60,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(
                30), // Adjust this value to control the roundness
          ),
          child: AppBar(
            toolbarHeight: 220,
            backgroundColor: Colors.blue,
            title: Obx(() {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0, left: 10, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Xin chào nhà tuyển dụng',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              controller.logout();
                            },
                            icon: const Icon(Icons.logout))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(
                            color: const Color.fromARGB(255, 216, 216, 216),
                            width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                ),
                                child: ClipOval(
                                  child: controller.companyModel.value.image !=
                                          null
                                      ? imageFromBase64String(controller
                                          .companyModel.value.image
                                          .toString())
                                      : const Image(
                                          image: AssetImage(
                                              'assets/images/user.png'),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        ),
                                )),
                            SizedBox(
                              width: 200,
                              height: 70,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      controller.companyModel.value.name
                                          .toString(),
                                      style: const TextStyle(fontSize: 22),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: 630,
          child: Column(
            children: [
              SizedBox(
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(255, 216, 216, 216),
                          width: 3),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 10),
                            child: Text(
                              'Danh mục của bạn ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          //Danh mục
                          Category(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
                child: Container(
                  width: 400,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(
                        color: const Color.fromARGB(255, 216, 216, 216),
                        width: 3),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 180,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Tổng số tin đã đăng',
                                      style: TextStyle(fontSize: 15),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('Tuần này'), Text('0 tin')],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text('Tháng này'), Text('0 tin')],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Ứng viên đã ứng tuyển',
                                      style: TextStyle(fontSize: 15),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tuần này'),
                                  Text(
                                    '0 ứng viên',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Tháng này'),
                                  Text('0 ứng viên')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

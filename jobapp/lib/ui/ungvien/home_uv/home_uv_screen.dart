import 'dart:convert';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:jobapp/ui/ungvien/home_uv/Job_gird.dart';

import '../../../controller/cv_storage_controller.dart';
import '../../../models/cv.dart';

// Tắt overscroll indicator cho cả iOS và Android
class NoOverscrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomeUV extends StatefulWidget {
  const HomeUV({super.key});

  @override
  State<HomeUV> createState() => _HomeUVState();
}

class _HomeUVState extends State<HomeUV> {
  final AuthController controller = Get.find<AuthController>();
  final cvStorageController = Get.find<CvStorageController>();
  final _offsetToArmed = 50.0;
  Map<String, dynamic> _userData = {};
  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    int uid = controller.userModel.value.id!;
    print(uid);
    try {
      await _fetchCvUpload();

      _userData = await Database().fetchUserDataForUid(uid);

      controller.userModel.value = controller.userModel.value.copyWith(
          id: _userData['uid'],
          name: _userData['name'],
          email: _userData['email'],
          career: _userData['career'],
          gender: _userData['gender'],
          phone: _userData['phone'],
          birthday: _userData['birthday'],
          address: _userData['address'],
          description: _userData['description'],
          salaryFrom: int.tryParse(_userData['salary_from']),
          salaryTo: int.tryParse(_userData['salary_to']),
          image: _userData['image'],
          experience: _userData['experience'],
          createdAt: _userData['create_at']);
      controller.saveUserData(controller.userModel.value);
      setState(() {});
    } catch (e) {
      print('lỗi refresh: $e');
    }
  }

  Future<void> _fetchCvUpload() async {
    try {
      int uid = controller.userModel.value.id!;
      final cvData = await Database().fetchAllCvForUid(uid);
      cvStorageController.clearCvData();
      for (final cvMap in cvData) {
        final cv = CV.fromMap(cvMap);
        cvStorageController.addCv(cv);
      }
    } catch (e) {
      print('lỗi fetch cv upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoOverscrollBehavior(),
        child: CustomRefreshIndicator(
          onRefresh: () async {
            await _handleRefresh();
          },
          offsetToArmed: _offsetToArmed,
          builder: (context, child, controller1) => AnimatedBuilder(
              animation: controller1,
              child: child,
              builder: (context, child) {
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Image(
                          image: AssetImage('assets/images/refresh.gif'),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0.0, 90 * controller1.value),
                      child: controller1.isLoading ? ScreenRefresh() : child,
                    )
                  ],
                );
              }),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 100,
                elevation: 10,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1,
                  titlePadding: const EdgeInsets.only(left: 10),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Obx(
                      () {
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
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: '${controller.userModel.value.name}!',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 1],
                      ),
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 1090,
                  color: Colors.white,
                  child: JobGird(),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
}

class ScreenRefresh extends StatelessWidget {
  const ScreenRefresh({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10)),
                )
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                    )
                  ],
                ),
              ],
            ),
            Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: 250,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 150,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                            ),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80, top: 8),
                          child: Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 250,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 223, 223, 223),
                      width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                width: 250,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 150,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const SizedBox(
                              width: 80,
                            ),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80, top: 8),
                          child: Container(
                            width: 100,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

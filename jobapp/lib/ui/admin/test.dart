import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  UserController usersController = Get.put(UserController());

  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> companyData = [];
  List<Map<String, dynamic>> jobData = [];
  final _userController = ScrollController();
  final _userKey = GlobalKey();

  final _companyKey = GlobalKey();
  final _jobKey = GlobalKey();
  int? countUser;
  int? countCompany;
  int? countJob;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
    _userController.addListener(() {
      userController.isScroll.value = _userController.position.pixels > 10;
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      userData = await Database().fetchAllUsers();
      countUser = await Database().countUser();
      companyData = await Database().fetchAllCompany();
      countCompany = await Database().countCompany();
      jobData = await Database().fetchAllJob(false);
      countJob = await Database().countJobs();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetch data admin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SpinKitSpinningLines(
              color: Colors.blue,
              size: 50.0,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.purple, Colors.red],
                ).createShader(bounds),
                child: const Text(
                  'NowCV',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      onPressed: () {
                        controller.logout();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: const Color.fromARGB(255, 192, 19, 6),
                      ),
                    ))
              ],
              backgroundColor: Colors.black,
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  controller: _userController,
                  child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Scrollable.ensureVisible(
                                    _userKey.currentContext!,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 170,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Text(
                                          'Users',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        left: 30,
                                        child: Center(
                                          child: Text(
                                            countUser!.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Scrollable.ensureVisible(
                                    _companyKey.currentContext!,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 170,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.red,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Text(
                                          'Company',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        left: 30,
                                        child: Center(
                                          child: Text(
                                            countCompany!.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Icon(
                                          Icons.location_city_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Scrollable.ensureVisible(
                                    _jobKey.currentContext!,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Container(
                                  width: 170,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.purple,
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        left: 10,
                                        child: Text(
                                          'Job',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 50,
                                        left: 30,
                                        child: Center(
                                          child: Text(
                                            countJob!.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 10,
                                        child: Icon(
                                          Icons.sticky_note_2_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: 170,
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green,
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Text(
                                        'Thêm',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Icon(
                                        Icons.add,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ShaderMask(
                            key: _userKey,
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 190, 224, 252),
                                Colors.blue
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Danh sách Users',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: userData.length,
                              itemBuilder: (context, index) {
                                final user = userData[index];
                                return SizedBox(
                                  width: double.infinity,
                                  height: 90,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ClipOval(
                                          child: imageFromBase64String(
                                              user['image']),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              user['name'],
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              user['career'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          ShaderMask(
                            key: _companyKey,
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 246, 192, 192),
                                Colors.red
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Danh sách Company',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: companyData.length,
                              itemBuilder: (context, index) {
                                final company = companyData[index];
                                return SizedBox(
                                  width: double.infinity,
                                  height: 90,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ClipOval(
                                          child: imageFromBase64String(
                                              company['image']),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              company['name'],
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              company['career'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                );
                              }),
                          const SizedBox(
                            height: 20,
                          ),
                          ShaderMask(
                            key: _jobKey,
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 240, 190, 252),
                                Colors.purple
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'Danh sách Job',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: jobData.length,
                              itemBuilder: (context, index) {
                                final job = jobData[index];
                                return SizedBox(
                                  width: double.infinity,
                                  height: 90,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ClipOval(
                                          child: imageFromBase64String(
                                              job['image']),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              job['title'],
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              job['careerJ'],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: Obx(
              () => userController.isScroll.value
                  ? FloatingActionButton(
                      onPressed: () {
                        _userController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox.shrink(),
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
//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(
//             child: SpinKitSpinningLines(
//               color: Colors.blue,
//               size: 50.0,
//             ),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               title: ShaderMask(
//                 shaderCallback: (bounds) => const LinearGradient(
//                   colors: [Colors.purple, Colors.red],
//                 ).createShader(bounds),
//                 child: const Text(
//                   'NowCV',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               actions: [
//                 Padding(
//                     padding: const EdgeInsets.only(right: 20.0),
//                     child: IconButton(
//                       onPressed: () {
//                         controller.logout();
//                       },
//                       icon: Icon(
//                         Icons.logout,
//                         color: const Color.fromARGB(255, 192, 19, 6),
//                       ),
//                     ))
//               ],
//               backgroundColor: Colors.black,
//             ),
//             body: Stack(
//               children: [
//                 Container(
//                   color: Colors.black,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 35, vertical: 110),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Get.toNamed('/adminUser');
//                               },
//                               child: Container(
//                                 width: 150,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.blue,
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: Text(
//                                         'Users',
//                                         style: TextStyle(
//                                           fontSize: 28,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 50,
//                                       left: 30,
//                                       child: Center(
//                                         child: Text(
//                                           countUser!.toString(),
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 10,
//                                       right: 10,
//                                       child: Icon(
//                                         Icons.person,
//                                         size: 40,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 Get.toNamed('/adminCompany');
//                               },
//                               child: Container(
//                                 width: 150,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.red,
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: Text(
//                                         'Company',
//                                         style: TextStyle(
//                                           fontSize: 28,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 50,
//                                       left: 30,
//                                       child: Center(
//                                         child: Text(
//                                           countCompany!.toString(),
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 10,
//                                       right: 10,
//                                       child: Icon(
//                                         Icons.location_city_rounded,
//                                         size: 40,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Get.toNamed('/adminJob');
//                               },
//                               child: Container(
//                                 width: 150,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.purple,
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: Text(
//                                         'Job',
//                                         style: TextStyle(
//                                           fontSize: 28,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 50,
//                                       left: 30,
//                                       child: Center(
//                                         child: Text(
//                                           countJob!.toString(),
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 10,
//                                       right: 10,
//                                       child: Icon(
//                                         Icons.sticky_note_2_rounded,
//                                         size: 40,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () async {
//                                 Map<String, dynamic> data = {
//                                   'data': serviceData,
//                                   'count_service': countService
//                                 };
//                                 final result = await Get.toNamed(
//                                     '/adminService',
//                                     arguments: data);
//                                 if (result != null) {
//                                   setState(() {
//                                     countService = result['count_service'];
//                                   });
//                                 }
//                               },
//                               child: Container(
//                                 width: 150,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.green,
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: Text(
//                                         'Service',
//                                         style: TextStyle(
//                                           fontSize: 28,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 50,
//                                       left: 30,
//                                       child: Center(
//                                         child: Text(
//                                           countService!.toString(),
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 10,
//                                       right: 10,
//                                       child: Icon(
//                                         Icons.shopping_basket_rounded,
//                                         size: 40,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Get.toNamed('/adminJob');
//                               },
//                               child: Container(
//                                 width: 150,
//                                 height: 100,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   color: Colors.purple,
//                                 ),
//                                 child: Stack(
//                                   children: [
//                                     Positioned(
//                                       top: 10,
//                                       left: 10,
//                                       child: Text(
//                                         'Apply',
//                                         style: TextStyle(
//                                           fontSize: 28,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 50,
//                                       left: 30,
//                                       child: Center(
//                                         child: Text(
//                                           countJob!.toString(),
//                                           style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     Positioned(
//                                       bottom: 10,
//                                       right: 10,
//                                       child: Icon(
//                                         Icons.account_circle,
//                                         size: 40,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             gradient: LinearGradient(
//                               begin: Alignment.topLeft,
//                               end: Alignment.bottomRight,
//                               colors: [Colors.blue, Colors.purple],
//                             ),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.5),
//                                 spreadRadius: 2,
//                                 blurRadius: 5,
//                               ),
//                             ],
//                           ),
//                           child: Padding(
//                             padding: const EdgeInsets.all(20),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   'Doanh thu',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 Text(
//                                   '${formatCurrency(revenue.toDouble())} VND',
//                                   style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             floatingActionButton: Obx(
//               () => userController.isScroll.value
//                   ? FloatingActionButton(
//                       onPressed: () {
//                         _userController.animateTo(
//                           0,
//                           duration: const Duration(milliseconds: 500),
//                           curve: Curves.easeInOut,
//                         );
//                       },
//                       child: const Icon(
//                         Icons.arrow_upward,
//                         color: Colors.red,
//                       ),
//                     )
//                   : const SizedBox.shrink(),
//             ),
//           );
//   }
// }
// // Container(
//                         //   decoration: BoxDecoration(
//                         //     borderRadius: BorderRadius.circular(10),
//                         //     color: Color(0xFF2A2D3E),
//                         //   ),
//                         //   child: Padding(
//                         //     padding: const EdgeInsets.all(10.0),
//                         //     child: Column(
//                         //       children: [
//                         //         ShaderMask(
//                         //           shaderCallback: (bounds) =>
//                         //               const LinearGradient(
//                         //             begin: Alignment
//                         //                 .topLeft, // Thêm hiệu ứng gradient cho text
//                         //             end: Alignment.bottomRight,
//                         //             colors: [Colors.white, Colors.white70],
//                         //           ).createShader(bounds),
//                         //           child: const Text(
//                         //             'Danh sách Đơn hàng',
//                         //             style: TextStyle(
//                         //               fontSize: 22,
//                         //               fontWeight: FontWeight.bold,
//                         //               color: Colors.white,
//                         //             ),
//                         //           ),
//                         //         ),
//                         //         SizedBox(height: 10),
//                         //         ListView.builder(
//                         //           shrinkWrap: true,
//                         //           physics: NeverScrollableScrollPhysics(),
//                         //           itemCount: payData.length,
//                         //           itemBuilder: (context, index) {
//                         //             final pay = payData[index];
//                         //             return Card(
//                         //               elevation: 2,
//                         //               margin:
//                         //                   EdgeInsets.symmetric(vertical: 5),
//                         //               shape: RoundedRectangleBorder(
//                         //                 borderRadius:
//                         //                     BorderRadius.circular(10),
//                         //               ),
//                         //               child: ListTile(
//                         //                 contentPadding: EdgeInsets.all(15),
//                         //                 leading: Icon(
//                         //                   Icons.shopify_outlined,
//                         //                   color: Colors.blue,
//                         //                   size: 40,
//                         //                 ),
//                         //                 title: Text(
//                         //                   pay['name'],
//                         //                   style: TextStyle(
//                         //                     fontSize: 18,
//                         //                     fontWeight: FontWeight.bold,
//                         //                   ),
//                         //                 ),
//                         //                 subtitle: Column(
//                         //                   crossAxisAlignment:
//                         //                       CrossAxisAlignment.start,
//                         //                   children: [
//                         //                     Text(
//                         //                       '${formatCurrency(pay['price'].toDouble())} VND',
//                         //                       style: TextStyle(
//                         //                         color: Colors
//                         //                             .green, // Màu xanh lá cây cho giá tiền
//                         //                       ),
//                         //                     ),
//                         //                     SizedBox(height: 5),
//                         //                     Text(
//                         //                       DateFormat(
//                         //                               'yyyy-MM-dd HH:mm:ss')
//                         //                           .format(pay['day_order']),
//                         //                       style: TextStyle(
//                         //                         fontSize: 12,
//                         //                         color: Colors.grey[600],
//                         //                       ),
//                         //                     ),
//                         //                   ],
//                         //                 ),
//                         //                 trailing: Icon(
//                         //                     Icons.arrow_forward_ios,
//                         //                     size: 18), // Thêm icon mũi tên
//                         //               ),
//                         //             );
//                         //           },
//                         //         ),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//                         // const SizedBox(
//                         //   height: 20,
//                         // ),
//                         // Container(
//                         //   decoration: BoxDecoration(
//                         //       borderRadius: BorderRadius.circular(10),
//                         //       color: Color.fromARGB(255, 30, 32, 46)),
//                         //   child: Padding(
//                         //     padding: const EdgeInsets.all(10.0),
//                         //     child: Column(
//                         //       children: [
//                         //         ShaderMask(
//                         //           shaderCallback: (bounds) =>
//                         //               const LinearGradient(
//                         //             colors: [Colors.white, Colors.white70],
//                         //           ).createShader(bounds),
//                         //           child: const Text(
//                         //             'Danh sách Dịch vụ',
//                         //             style: TextStyle(
//                         //               fontSize: 22,
//                         //               fontWeight: FontWeight.bold,
//                         //               color: Colors.white,
//                         //             ),
//                         //           ),
//                         //         ),
//                         //         ListView.builder(
//                         //             shrinkWrap: true,
//                         //             physics: NeverScrollableScrollPhysics(),
//                         //             itemCount: serviceData.length,
//                         //             itemBuilder: (context, index) {
//                         //               final service = serviceData[index];
//                         //               return SizedBox(
//                         //                 width: double.infinity,
//                         //                 height: 90,
//                         //                 child: Row(
//                         //                   mainAxisAlignment:
//                         //                       MainAxisAlignment.spaceBetween,
//                         //                   children: [
//                         //                     Expanded(
//                         //                       child: Column(
//                         //                         crossAxisAlignment:
//                         //                             CrossAxisAlignment.start,
//                         //                         mainAxisAlignment:
//                         //                             MainAxisAlignment.center,
//                         //                         children: [
//                         //                           Row(
//                         //                             mainAxisAlignment:
//                         //                                 MainAxisAlignment
//                         //                                     .spaceBetween,
//                         //                             children: [
//                         //                               Text(
//                         //                                 service['sv_name'],
//                         //                                 style: TextStyle(
//                         //                                   fontSize: 18,
//                         //                                   color: Colors.white,
//                         //                                 ),
//                         //                               ),
//                         //                               Text(
//                         //                                 service['sv_price'],
//                         //                                 style: TextStyle(
//                         //                                   fontSize: 18,
//                         //                                   fontWeight:
//                         //                                       FontWeight.bold,
//                         //                                   color: Colors.white,
//                         //                                 ),
//                         //                               ),
//                         //                             ],
//                         //                           ),
//                         //                         ],
//                         //                       ),
//                         //                     ),
//                         //                   ],
//                         //                 ),
//                         //               );
//                         //             }),
//                         //       ],
//                         //     ),
//                         //   ),
//                         // ),
//                         // const SizedBox(
//                         //   height: 20,
//                         // ),
   // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         Get.toNamed('/adminApply');
                      //       },
                      //       child: Container(
                      //         width: 150,
                      //         height: 100,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Colors.purple,
                      //         ),
                      //         child: Stack(
                      //           children: [
                      //             Positioned(
                      //               top: 10,
                      //               left: 10,
                      //               child: Text(
                      //                 'Apply',
                      //                 style: TextStyle(
                      //                   fontSize: 28,
                      //                   fontWeight: FontWeight.bold,
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //             ),
                      //             Positioned(
                      //               top: 50,
                      //               left: 30,
                      //               child: Center(
                      //                 child: Text(
                      //                   countJob!.toString(),
                      //                   style: TextStyle(
                      //                     fontSize: 20,
                      //                     fontWeight: FontWeight.bold,
                      //                     color: Colors.white,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             Positioned(
                      //               bottom: 10,
                      //               right: 10,
                      //               child: Icon(
                      //                 Icons.account_circle,
                      //                 size: 40,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
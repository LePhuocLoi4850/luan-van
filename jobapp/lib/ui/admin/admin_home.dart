import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/controller/favorites_controller.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  UserController usersController = Get.put(UserController());
  FavoritesController faController = Get.put(FavoritesController());

  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> serviceData = [];
  List<Map<String, dynamic>> payData = [];
  final _userController = ScrollController();

  int? countUser;
  int? countCompany;
  int? countJob;
  int? countService;
  int revenue = 0;
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
      countUser = await Database().countUser();
      serviceData = await Database().fetchAllService();
      countCompany = await Database().countCompany();
      payData = await Database().fetchAllPayment();
      countJob = await Database().countJobs();
      countService = await Database().countService();
      revenue = await Database().calculateTotalPrice();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetch data admin: $e');
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(amount);
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
            body: SafeArea(
              // Sử dụng SafeArea
              child: SingleChildScrollView(
                controller: _userController,
                child: Padding(
                  padding: const EdgeInsets.all(20), // Điều chỉnh padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/adminUser');
                            },
                            child: Container(
                              width: 150,
                              height: 100,
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
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed('/adminCompany');
                            },
                            child: Container(
                              width: 150,
                              height: 100,
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
                                      size: 40,
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
                              Get.toNamed('/adminJob');
                            },
                            child: Container(
                              width: 150,
                              height: 100,
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
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              Map<String, dynamic> data = {
                                'data': serviceData,
                                'count_service': countService
                              };
                              final result = await Get.toNamed('/adminService',
                                  arguments: data);
                              if (result != null) {
                                setState(() {
                                  countService = result['count_service'];
                                });
                              }
                            },
                            child: Container(
                              width: 150,
                              height: 100,
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
                                      'Service',
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
                                        countService!.toString(),
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
                                      Icons.shopping_basket_rounded,
                                      size: 40,
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
                              Get.toNamed('/adminJob');
                            },
                            child: Container(
                              width: 150,
                              height: 100,
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
                                      'Apply',
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
                                      Icons.account_circle,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF673AB7),
                              // Màu tím đậm
                              Color(0xFFE91E63) // Màu hồng
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Doanh thu',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${formatCurrency(revenue.toDouble())} VND',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ... (Nút cuộn lên đầu trang) ...
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

class AdminCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AdminCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            // Thêm đổ bóng cho card
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Icon(icon, size: 30, color: Colors.white), // Tăng kích thước icon
          ],
        ),
      ),
    );
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
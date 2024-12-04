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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Danh sách công ty'),
  //     ),
  //     body: isLoading
  //         ? Center(
  //             child: CircularProgressIndicator(),
  //           )
  //         : Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: SizedBox(
  //               height: 800,
  //               child: Container(
  //                 decoration:
  //                     BoxDecoration(borderRadius: BorderRadius.circular(15)),
  //                 child: SizedBox(
  //                   height: 200,
  //                   child: ListView.builder(
  //                       itemCount: _allCompany.length,
  //                       itemBuilder: (context, index) {
  //                         final company = _allCompany[index];
  //                         return Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 10.0),
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               Get.toNamed('/companyDetailAdmin',
  //                                   arguments: company['cid']);
  //                             },
  //                             child: Card(
  //                               elevation: 0.0,
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                     color: Colors.white,
  //                                     border: Border.all(
  //                                       color: const Color.fromARGB(
  //                                           255, 142, 201, 248),
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(15)),
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(10.0),
  //                                   child: Column(
  //                                     children: [
  //                                       Row(
  //                                         children: [
  //                                           Container(
  //                                             height: 70,
  //                                             width: 70,
  //                                             decoration: _getServiceDayBorder(
  //                                                 company['service_day']
  //                                                     .toString()),
  //                                             child: ClipRRect(
  //                                               borderRadius:
  //                                                   BorderRadius.circular(10),
  //                                               child: imageFromBase64String(
  //                                                   company['image']),
  //                                             ),
  //                                           ),
  //                                           const SizedBox(width: 16),
  //                                           Expanded(
  //                                             child: Column(
  //                                               crossAxisAlignment:
  //                                                   CrossAxisAlignment.start,
  //                                               children: [
  //                                                 Row(
  //                                                   mainAxisAlignment:
  //                                                       MainAxisAlignment
  //                                                           .spaceBetween,
  //                                                   children: [
  //                                                     Expanded(
  //                                                       child: Text(
  //                                                         '${company['name']}',
  //                                                         style:
  //                                                             const TextStyle(
  //                                                                 fontWeight:
  //                                                                     FontWeight
  //                                                                         .w500,
  //                                                                 fontSize: 20),
  //                                                         maxLines: 2,
  //                                                         overflow: TextOverflow
  //                                                             .ellipsis,
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 ),
  //                                                 Text(
  //                                                   company['career'],
  //                                                   style: const TextStyle(
  //                                                       fontSize: 17,
  //                                                       color: Color.fromARGB(
  //                                                           255,
  //                                                           124,
  //                                                           124,
  //                                                           124)),
  //                                                   overflow:
  //                                                       TextOverflow.ellipsis,
  //                                                   maxLines: 1,
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       Padding(
  //                                         padding: const EdgeInsets.only(
  //                                             left: 85.0, top: 5),
  //                                         child: Row(
  //                                           children: [
  //                                             Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: Colors.grey[200],
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10)),
  //                                               child: Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(7.0),
  //                                                 child: Text(
  //                                                   '${company['countJ'].toString()} việc làm',
  //                                                   style: const TextStyle(
  //                                                       fontWeight:
  //                                                           FontWeight.w500),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                             const SizedBox(
  //                                               width: 20,
  //                                             ),
  //                                             Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: Colors.grey[200],
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           10)),
  //                                               child: Padding(
  //                                                 padding:
  //                                                     const EdgeInsets.all(7.0),
  //                                                 child: Text(
  //                                                   '${company['countU'].toString()} hồ sơ',
  //                                                   style: const TextStyle(
  //                                                       fontWeight:
  //                                                           FontWeight.w500),
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ],
  //                                         ),
  //                                       ),
  //                                       const SizedBox(
  //                                         height: 10,
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         );
  //                       }),
  //                 ),
  //               ),
  //             ),
  //           ),
  //   );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách công ty'),
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
                        trailing: Icon(Icons.remove_red_eye_sharp),
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

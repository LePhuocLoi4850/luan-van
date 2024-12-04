import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/favorites_controller.dart';

import '../../../../controller/user_controller.dart';

import '../../auth/auth_controller.dart';

class JobGirdTitleVerticalAdmin extends StatefulWidget {
  final List<Map<String, dynamic>> allJobs;
  final BoxDecoration Function(String?) imageDecorator;

  const JobGirdTitleVerticalAdmin(
      {super.key, required this.allJobs, required this.imageDecorator});

  @override
  State<JobGirdTitleVerticalAdmin> createState() =>
      _JobGirdTitleVerticalAdminState();
}

class _JobGirdTitleVerticalAdminState extends State<JobGirdTitleVerticalAdmin> {
  AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  String salary = '';
  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.allJobs.length,
        itemBuilder: (context, index) {
          final job = widget.allJobs[index];
          salary = '${job['salaryFrom']} - ${job['salaryTo']} Triệu';

          return GestureDetector(
            onTap: () async {
              Get.toNamed('/jobDetailScreenAdmin', arguments: {
                'jid': job['jid'],
                'cid': job['cid'],
                'count': job['num_apply']
              });
            },
            child: Card(
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
                            decoration: widget
                                .imageDecorator(job['service_day'].toString()),
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
                            ),
                          ),
                        ],
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
                                child: Text(
                                  'Số lượng ứng tuyển: ${job['num_apply']}',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

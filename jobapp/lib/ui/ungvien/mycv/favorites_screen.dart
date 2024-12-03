import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/controller/favorites_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import '../../../server/database.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final AuthController controller = Get.find<AuthController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  String salary = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Việc làm yêu thích"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Obx(() {
        if (favoritesController.favoritesData.isEmpty) {
          return const Center(
            child: Text("Không có việc làm yêu thích nào"),
          );
        }

        return ListView.builder(
          scrollDirection: Axis.vertical,
          physics: const ClampingScrollPhysics(),
          itemCount: favoritesController.favoritesData.length,
          itemBuilder: (context, index) {
            final job = favoritesController.favoritesData[index];
            salary = '${job.salaryFrom} - ${job.salaryTo} Triệu';
            int lastCommaIndex = job.address.lastIndexOf(",");
            final address = job.address.substring(lastCommaIndex + 1).trim();

            return GestureDetector(
              onTap: () async {
                Get.toNamed('/jobDetailScreen',
                    arguments: {'jid': job.jid, 'cid': job.cid});
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: imageFromBase64String(job.image)),
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
                                        job.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await Database().removeFavorites(
                                            controller.userModel.value.id!,
                                            job.jid);
                                        favoritesController.removeFavorites(
                                          controller.userModel.value.id!,
                                          job.jid,
                                        );
                                      },
                                      icon: FaIcon(FontAwesomeIcons.solidHeart,
                                          color: Colors.red),
                                    )
                                  ],
                                ),
                                Text(
                                  job.nameC,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color:
                                          Color.fromARGB(255, 124, 124, 124)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 85.0, top: 5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    address,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Text(
                                    job.experience,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.attach_money_outlined,
                                        size: 18,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        salary,
                                        style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
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
        );
      }),
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

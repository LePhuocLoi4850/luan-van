import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/controller/favorites_controller.dart';
import 'package:jobapp/models/favorites.dart';
import '../../../controller/user_controller.dart';
import '../../../server/database.dart';
import '../../auth/auth_controller.dart';

class JobGirdTitle extends StatefulWidget {
  final List<Map<String, dynamic>> allJobs;
  final BoxDecoration Function(String?) imageDecorator;

  const JobGirdTitle(
      {super.key, required this.allJobs, required this.imageDecorator});

  @override
  State<JobGirdTitle> createState() => _JobGirdTitleState();
}

class _JobGirdTitleState extends State<JobGirdTitle> {
  AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  List<Map<String, dynamic>> _allFavorite = [];
  String salary = '';
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    int uid = controller.userModel.value.id!;
    try {
      _allFavorite = await Database().fetchAllFavoriteForUid(uid);
      print(_allFavorite);
      favoritesController.clearFavoritesData();
      for (var favorites in _allFavorite) {
        final favorite = Favorite.fromMap(favorites);
        favoritesController.addFavorites(favorite);
      }
    } catch (e) {
      print('lỗi favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.allJobs.length,
        itemBuilder: (context, index) {
          final job = widget.allJobs[index];
          salary = '${job['salaryFrom']} - ${job['salaryTo']} Triệu';
          int lastCommaIndex = job['address'].lastIndexOf(",");
          final address = job['address'].substring(lastCommaIndex + 1).trim();

          return GestureDetector(
            onTap: () async {
              Get.toNamed('/jobDetailScreen',
                  arguments: {'jid': job['jid'], 'cid': job['cid']});
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
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
                                          fontSize: 18),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Obx(() {
                                    bool isFavorite = favoritesController
                                        .favoritesData
                                        .any((favorite) =>
                                            favorite.jid == job['jid'] &&
                                            favorite.uid ==
                                                controller.userModel.value.id);
                                    return IconButton(
                                      onPressed: () async {
                                        if (isFavorite) {
                                          await Database().removeFavorites(
                                              controller.userModel.value.id!,
                                              job['jid']);
                                          favoritesController.removeFavorites(
                                            controller.userModel.value.id!,
                                            job['jid'],
                                          );
                                        } else {
                                          await Database().addFavorites(
                                              controller.userModel.value.id!,
                                              job['jid'],
                                              job['cid'],
                                              job['title'],
                                              job['nameC'],
                                              job['address'],
                                              job['experience'],
                                              job['salaryFrom'],
                                              job['salaryTo'],
                                              job['image'],
                                              DateTime.now());
                                          favoritesController.addFavorites(
                                              Favorite(
                                                  uid: controller
                                                      .userModel.value.id!,
                                                  jid: job['jid'],
                                                  cid: job['cid'],
                                                  title: job['title'],
                                                  nameC: job['nameC'],
                                                  address: job['address'],
                                                  experience: job['experience'],
                                                  salaryFrom: job['salaryFrom'],
                                                  salaryTo: job['salaryTo'],
                                                  image: job['image'],
                                                  createAt: DateTime.now()));
                                        }
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.solidHeart,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                    );
                                  })
                                ],
                              ),
                              Text(
                                job['nameC'],
                                style: const TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 124, 124, 124)),
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
                                  job['experience'],
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
                      ),
                      Row(
                        children: [
                          Text(
                              'Hạn chót ứng tuyển: ${DateFormat('dd/MM/yyyy').format(job['expiration_date'])}'),
                        ],
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

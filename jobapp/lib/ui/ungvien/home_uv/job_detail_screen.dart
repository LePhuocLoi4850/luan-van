import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

import '../../../controller/favorites_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../models/favorites.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen({super.key});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  Map<String, dynamic> detailJob = {};
  List<Map<String, dynamic>> _allJobCareer = [];
  int jId = Get.arguments['jid'];
  int cId = Get.arguments['cid'];
  bool isLoading = true;
  String? address;
  final ScrollController _scrollController = ScrollController();
  // bool _showAppBarTitle = false;
  bool isFavorite = false;

  String applicationStatus = 'apply';
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isLoading = false;
          });
        });
      }
    });
    fetchDetailJob();
    _scrollController.addListener(() {
      if (_scrollController.offset >= 320 &&
          !userController.isSwitchDetail.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            userController.isSwitchDetail.value = true;
          });
        });
      } else if (_scrollController.offset < 320 &&
          userController.isSwitchDetail.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            userController.isSwitchDetail.value = false;
          });
        });
      }
    });
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

  void fetchJobForCareer() async {
    String career = detailJob['careerJ'];
    try {
      _allJobCareer = await Database().fetchAllJobForCareer(career);
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void fetchDetailJob() async {
    try {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isLoading = true;
          });
        });
      }
      detailJob = await Database().fetchJobForId(jId);
      int lastCommaIndex = detailJob['address'].lastIndexOf(",");
      address = detailJob['address'].substring(lastCommaIndex + 1).trim();
      if (detailJob.isNotEmpty) {
        int uid = controller.userModel.value.id!;

        applicationStatus = await Database().checkApplicationStatus(jId, uid);
        fetchJobForCareer();
      } else {
        print('No job found with this ID.');
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  void withdraw() async {
    int uid = controller.userModel.value.id!;
    String status = 'withdraw';
    int jid = jId;
    int cid = cId;
    DateTime applyDate = DateTime.now();
    try {
      await Database().withdrawAndReapply(jid, uid, cid, status, applyDate);
      print(' hủy ứng tuyển thành công');
    } catch (e) {
      print(e);
    }
  }

  void reapply() async {
    int uid = controller.userModel.value.id!;
    String status = 'reapply';
    int jid = jId;
    int cid = cId;
    DateTime applyDate = DateTime.now();
    try {
      await Database().withdrawAndReapply(jid, uid, cid, status, applyDate);
      print('ứng tuyển lại thành công');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Obx(() {
            return AppBar(
              title: userController.isSwitchDetail.value
                  ? Text(detailJob['title'] ?? '')
                  : null,
              elevation: 0,
              backgroundColor: userController.isSwitchDetail.value
                  ? Colors.white
                  : Colors.transparent,
              bottom: userController.isSwitchDetail.value
                  ? TabBar(
                      isScrollable: false,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      indicatorSize: TabBarIndicatorSize.tab,
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                      tabs: [
                        Tab(
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            child: const Text("Thông tin"),
                          ),
                        ),
                        Tab(
                          child: Container(
                            width: 120,
                            alignment: Alignment.center,
                            child: const Text("Việc làm liên quan"),
                          ),
                        ),
                        Tab(
                          child: Container(
                            width: 100,
                            alignment: Alignment.center,
                            child: const Text("Công ty"),
                          ),
                        ),
                      ],
                    )
                  : null,
            );
          }),
        ),
        body: isLoading
            ? const Center(
                child: SpinKitChasingDots(
                  color: Colors.blue,
                  size: 50.0,
                ),
              )
            : NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      floating: true,
                      automaticallyImplyLeading: false,
                      expandedHeight: 270,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          children: [
                            Container(
                              height: 320,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/logo.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 110,
                              left: 15,
                              right: 15,
                              child: Container(
                                height: 260,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 45.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              detailJob['title'] ?? '',
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(detailJob['name'] ?? '',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ))
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            buildColumnDetail(
                                              icon: Icons.monetization_on,
                                              label: 'Mức lương',
                                              value:
                                                  '${detailJob['salaryFrom']} - ${detailJob['salaryTo']} Triệu',
                                            ),
                                            buildDivider(),
                                            buildColumnDetail(
                                              icon: Icons.share_location_sharp,
                                              label: 'Địa điểm',
                                              value: address ?? '',
                                            ),
                                            buildDivider(),
                                            buildColumnDetail(
                                              icon: Icons.star_half_outlined,
                                              label: 'Kinh nghiệm',
                                              value:
                                                  detailJob['experience'] ?? '',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 60,
                              left: 100,
                              right: 100,
                              child: Center(
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: _getServiceDayBorder(
                                      detailJob['service_day'].toString()),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/companyDetailScreen',
                                          arguments: detailJob['cid']);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: imageFromBase64String(
                                          detailJob['image']),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ];
                },
                body: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      TabBar(
                        isScrollable: false,
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        indicatorSize: TabBarIndicatorSize.tab,
                        padding: EdgeInsets.zero,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                        tabs: [
                          Tab(
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              child: const Text("Thông tin"),
                            ),
                          ),
                          Tab(
                            child: Container(
                              width: 120,
                              alignment: Alignment.center,
                              child: const Text("Việc làm liên quan"),
                            ),
                          ),
                          Tab(
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              child: const Text("Công ty"),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Thông tin chung',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, top: 15),
                                      child: SizedBox(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Icon(
                                                      Icons.star_half_outlined,
                                                      color: Colors.blueAccent,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Kinh nghiệm',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        detailJob['experience'],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Icon(
                                                      Icons
                                                          .free_cancellation_rounded,
                                                      color: Colors.blueAccent,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Hình thức',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        detailJob['type'],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Icon(
                                                      Icons.people,
                                                      color: Colors.blueAccent,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Số lượng tuyển',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        '${detailJob['quantity'].toString()} người',
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 10.0),
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.blueAccent,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Giới tính',
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                      Text(
                                                        detailJob['gender'],
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5),
                                      child: const Text(
                                        'Mô tả công việc',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      detailJob['description'],
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5),
                                      child: const Text(
                                        'Yêu cầu ứng viên',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      detailJob['request'],
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, bottom: 5),
                                      child: const Text(
                                        'Quyền lợi ứng viên',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      detailJob['interest'],
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: const Text(
                                        'Địa điểm',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      detailJob['address'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: const Text(
                                        'Thời gian làm việc',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            '- ',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w100),
                                          ),
                                          Text(
                                            detailJob['workingTime'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final job = _allJobCareer[index];
                                        int lastCommaIndex =
                                            job['address'].lastIndexOf(",");
                                        final address = job['address']
                                            .substring(lastCommaIndex + 1)
                                            .trim();
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 142, 201, 248),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        width: 70,
                                                        decoration:
                                                            _getServiceDayBorder(
                                                                job['service_day']
                                                                    .toString()),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              imageFromBase64String(
                                                                  job['image']),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    '${job['title']}',
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            20),
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                                ),
                                                                Obx(() {
                                                                  bool isFavorite = favoritesController.favoritesData.any((favorite) =>
                                                                      favorite.jid ==
                                                                          job[
                                                                              'jid'] &&
                                                                      favorite.uid ==
                                                                          controller
                                                                              .userModel
                                                                              .value
                                                                              .id);
                                                                  return IconButton(
                                                                    onPressed:
                                                                        () async {
                                                                      if (isFavorite) {
                                                                        await Database().removeFavorites(
                                                                            controller.userModel.value.id!,
                                                                            job['jid']);
                                                                        favoritesController
                                                                            .removeFavorites(
                                                                          controller
                                                                              .userModel
                                                                              .value
                                                                              .id!,
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
                                                                        favoritesController.addFavorites(Favorite(
                                                                            uid:
                                                                                controller.userModel.value.id!,
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
                                                                    icon:
                                                                        FaIcon(
                                                                      FontAwesomeIcons
                                                                          .solidHeart,
                                                                      color: isFavorite
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .grey,
                                                                    ),
                                                                  );
                                                                })
                                                              ],
                                                            ),
                                                            Text(
                                                              job['nameC'],
                                                              style: const TextStyle(
                                                                  fontSize: 17,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          124,
                                                                          124,
                                                                          124)),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 85.0, top: 5),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7.0),
                                                            child: Text(
                                                              address,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7.0),
                                                            child: Text(
                                                              job['experience'],
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 85.0, top: 5),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .blue[50],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(7.0),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .attach_money_outlined,
                                                                  size: 18,
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                                Text(
                                                                  job['nameC'],
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
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
                                        );
                                      },
                                      childCount: _allJobCareer.length,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detailJob['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.location_on_sharp,
                                                    size: 30,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'địa chỉ công ty',
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  Text(
                                                    detailJob['addressC'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    softWrap: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blue[50],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Icon(
                                                    Icons.location_city_rounded,
                                                    size: 30,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Quy mô công ty',
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                                Text(
                                                  detailJob['scale'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Giới thiệu công ty',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              userController
                                                      .isSwitchMore.value =
                                                  !userController
                                                      .isSwitchMore.value;
                                            });
                                          },
                                          child: Text(
                                            userController.isSwitchMore.value
                                                ? 'Thu gọn'
                                                : 'Xem thêm',
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        detailJob['descriptionC'],
                                        style: const TextStyle(fontSize: 16),
                                        maxLines:
                                            userController.isSwitchMore.value
                                                ? null
                                                : 6,
                                        overflow:
                                            userController.isSwitchMore.value
                                                ? TextOverflow.visible
                                                : TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),
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
        bottomNavigationBar: isLoading
            ? const Center(
                child: SpinKitChasingDots(
                  color: Colors.blue,
                  size: 50.0,
                ),
              )
            : PreferredSize(
                preferredSize: const Size.fromHeight(200),
                child: BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          switch (applicationStatus) {
                            case 'apply':
                              Get.toNamed('/apply', arguments: detailJob);
                              break;
                            case 'applied':
                              withdraw();
                              break;
                            case 'withdraw':
                              reapply();
                              break;
                            default:
                              break;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          (() {
                            switch (applicationStatus) {
                              case 'apply':
                                return 'Ứng tuyển';
                              case 'applied':
                                return 'Đang chờ duyệt';
                              case 'reapply':
                                return 'Hủy ứng tuyển';
                              case 'withdraw':
                                return 'Ứng tuyển';
                              case 'approved':
                                return 'Đã nhận việc';
                              default:
                                return applicationStatus;
                            }
                          })(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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

Widget buildColumnDetail({
  required IconData icon,
  required String label,
  required String value,
}) {
  return Column(
    children: [
      Icon(
        icon,
        color: Colors.blueAccent,
        size: 35,
      ),
      Text(
        label,
        style: const TextStyle(
          color: Colors.blueGrey,
          fontSize: 14,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
            color: Colors.blueAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget buildDivider() {
  return Container(
    width: 1, // Độ dày của đường kẻ
    height: 80, // Chiều cao của đường kẻ
    color: Colors.grey, // Màu của đường kẻ
    margin: const EdgeInsets.symmetric(horizontal: 10), // Khoảng cách hai bên
  );
}
/*

*/
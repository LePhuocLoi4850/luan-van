import 'package:flutter/material.dart';
import 'package:myapp/ui/company/company_detail.dart';
import 'package:postgres/postgres.dart';
import '../../../job_company.dart';
import '../../../ui/screens.dart';

class JobDetailScreen extends StatefulWidget {
  const JobDetailScreen(this.jobId, {super.key});
  final int jobId;
  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  late Future<List<dynamic>> _detailJob;
  late List<dynamic> detailJob;
  String? emailc;
  String? emailu;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? emailu = userProvider.email;
    _detailJob = DatabaseConnection().selectDetailJobs(widget.jobId);

    _detailJob.then((detailJob) async {
      if (detailJob.isNotEmpty) {
        // Check if data is available

        String? idJob = detailJob[0][0].toString();

        final String? hasApplied = await checkAppliedStatus(emailu!, idJob);
        print('giá trị của status $hasApplied');
        setState(() {
          if (hasApplied == 'applied') {
            buttonText = 'Hủy Ứng Tuyển';
          } else if (hasApplied == 'withdrawn' || hasApplied == 'refused') {
            buttonText = 'Ứng Tuyển Lại';
          } else if (hasApplied == 'received') {
            buttonText = 'Đã nhận';
          } else {
            buttonText = 'Ứng Tuyển';
          }
        });
      }
      print(buttonText);
      isLoading.value = false;
    }).catchError((error) {
      print('Error fetching job details: $error');
      isLoading.value = false;
    });
  }

  Future<String?> checkAppliedStatus(String emailu, String jobId) async {
    try {
      final conn = DatabaseConnection().connection;
      final result = await conn?.execute(
        Sql.named('''
        SELECT status FROM apply
        WHERE emailu = @emailu AND jobid = @jobId
        '''),
        parameters: {'emailu': emailu, 'jobId': jobId},
      );
      if (result != null && result.isNotEmpty && result[0].isNotEmpty) {
        return result[0][0].toString();
      } else {
        return null;
      }
    } catch (e) {
      print('Error checking applied status: $e');
    }
    return null;
  }

  Future<void> cancelApplication(String reason) async {
    setState(() {
      isLoading.value = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    emailu = userProvider.email;
    String jobId = widget.jobId.toString();
    try {
      print('bắt đầu update');
      detailJob = await DatabaseConnection().selectDetailJobs(widget.jobId);
      emailc = detailJob[0][1];
      String status = 'withdrawn';
      await DatabaseConnection().updateJobSpace(emailu!, jobId, status, reason);
      await DatabaseConnection().addApplicationHistory(
        emailu!,
        emailc!,
        jobId,
        status,
        reason,
      );
      print('update thành công');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hủy ứng tuyển thành công! Lý do: $reason')),
      );
      buttonText = 'Ứng Tuyển Lại';
    } catch (error) {
      //
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> reapplying() async {
    setState(() {
      isLoading.value = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    emailu = userProvider.email;
    String jobId = widget.jobId.toString();
    try {
      print('bắt đầu update');
      detailJob = await DatabaseConnection().selectDetailJobs(widget.jobId);
      emailc = detailJob[0][1];
      String status = 'applied';
      String? reason = 'Ứng Tuyển Lại';
      await DatabaseConnection().updateJobSpace(emailu!, jobId, status, reason);
      await DatabaseConnection().addApplicationHistory(
        emailu!,
        emailc!,
        jobId,
        status,
        reason,
      );
      print('update thành công');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ứng tuyển lại thành công!')),
      );
      buttonText = 'Ứng Tuyển Lại';
    } catch (error) {
      //
    } finally {
      setState(() {
        isLoading.value = false;
      });
    }
  }

  Future<void> apply() async {
    isLoading.value = true;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    detailJob = await DatabaseConnection().selectDetailJobs(widget.jobId);
    emailc = detailJob[0][1];
    emailu = userProvider.email;
    String? idJob = detailJob[0][0].toString();
    String? status = 'applied';
    String? name = detailJob[0][2];
    String? address = detailJob[0][5];
    String? salary = detailJob[0][3].toString();
    String? reason = 'Ứng Tuyển';
    final userId = await DatabaseConnection().getUserIdByEmail(emailu!);
    if (userId != null) {
      print('ID của user là: $userId');
    } else {
      print('Không tìm thấy user với email này.');
    }
    int? id = userId;
    try {
      await DatabaseConnection().applyJob(id!, emailu!, emailc!, idJob, status,
          name!, address!, salary, reason);
      await DatabaseConnection()
          .addApplicationHistory(emailu!, emailc!, idJob, status, reason);
      setState(() {
        buttonText = 'Hủy Ứng Tuyển';
      });
      isLoading.value = false;
    } catch (e) {
      print('Error applying for job: $e');
    }
  }

  String? buttonText = 'Ứng tuyển';

  @override
  Widget build(BuildContext context) {
    return Consumer<StatusProvider>(builder: (context, statusProvider, child) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 1),
          child: AppBar(
            title: const Text('Chi tiết việc làm'),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey,
                height: 1.0,
              ),
            ),
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _detailJob,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Job not found'));
            } else {
              final jobDetail = snapshot.data![0];
              return SingleChildScrollView(
                padding: const EdgeInsets.only(top: 5.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 0.0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 200, 200, 200),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        'assets/images/imageJ.jpg',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Placeholder(
                                            fallbackHeight: 70,
                                            fallbackWidth: 70,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            const Icon(
                                              Icons.person_3_outlined,
                                              size: 15,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                              jobDetail[2],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              jobDetail[2],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .library_add_check_rounded,
                                                  color: Colors.green,
                                                  size: 22,
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  child: Text(
                                                    jobDetail[1],
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        color: Color.fromARGB(
                                                            255,
                                                            158,
                                                            155,
                                                            145)),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 170,
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 211, 211, 211),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CompanyDetailScreen(jobDetail[1]),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Thông tin công ty',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 170,
                                  height: 35,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 211, 211, 211),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (statusProvider.status) {
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Job1(jobDetail[1]),
                                            ));
                                        statusProvider.toggleStatus();
                                      }
                                    },
                                    child: const Text(
                                      'Việc làm khác',
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 1,
                              width: 360,
                              color: const Color.fromARGB(
                                  255, 143, 143, 143), // Màu sắc của đường kẻ
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'THÔNG TIN CÔNG VIỆC',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.monetization_on,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const Text(
                                        'Mức lương:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          '${jobDetail[3]}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.wallet_travel_outlined,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const Text(
                                        'Loại hình công việc:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          jobDetail[4],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.groups_outlined,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const Text(
                                        'Số lượng cần tuyển:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          '${jobDetail[6]} người',
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.wallet_travel_outlined,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const Text(
                                        'Địa chỉ làm việc:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: Text(
                                            jobDetail[5],
                                            softWrap: true,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 1,
                              width: 360,
                              color: const Color.fromARGB(255, 143, 143, 143),
                            ),
                            const SizedBox(height: 10),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Lịch LÀM VIỆC',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Column(
                                        children: [
                                          const Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: Icon(
                                                  Icons.watch_later_outlined,
                                                  color: Colors.amber,
                                                ),
                                              ),
                                              Text(
                                                'Thời gian làm việc:',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 34),
                                              child: Text(
                                                jobDetail[7],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                                maxLines: 10,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ]),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 1,
                              width: 360,
                              color: const Color.fromARGB(255, 143, 143, 143),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'YÊU CẦU',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: FaIcon(
                                          FontAwesomeIcons.venusMars,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                      ),
                                      const Text(
                                        'Giới tính:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          jobDetail[8],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(
                                          Icons.cake_outlined,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      const Text(
                                        'Độ tuổi:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          jobDetail[9],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: FaIcon(
                                          FontAwesomeIcons.graduationCap,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                      ),
                                      const Text(
                                        'Học vấn:',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          jobDetail[10],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: FaIcon(
                                              FontAwesomeIcons.medal,
                                              color: Colors.amber,
                                              size: 20,
                                            ),
                                          ),
                                          Text(
                                            'Kinh nghiệm:',
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 34),
                                        child: Text(
                                          jobDetail[11],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 1,
                              width: 360,
                              color: const Color.fromARGB(255, 143, 143, 143),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MÔ TẢ CÔNG VIỆC',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    jobDetail[13],
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 158, 155, 145)),
                                    maxLines: 20,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 1,
                              width: 360,
                              color: const Color.fromARGB(255, 143, 143, 143),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'YÊU CẦU KHÁC',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          jobDetail[14],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.all(8),
                              height: 1,
                              width: 360,
                              color: const Color.fromARGB(255, 143, 143, 143),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'PHÚC LỢI',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: Text(
                                          jobDetail[15],
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
        bottomNavigationBar: PreferredSize(
          preferredSize: const Size.fromHeight(200),
          child: BottomAppBar(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: ValueListenableBuilder<bool>(
                  valueListenable: isLoading,
                  builder: (context, isLoading, child) {
                    return SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isLoading && buttonText == 'Ứng Tuyển') {
                            apply();
                          } else if (!isLoading &&
                              buttonText == 'Hủy Ứng Tuyển') {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 250, // Adjust height as needed
                                  child: ListView(
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text('Vị trí quá xa'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          cancelApplication("Vị trí quá xa");
                                        },
                                      ),
                                      ListTile(
                                        title: const Text(
                                            'Không phù hợp với kỹ năng'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          cancelApplication(
                                              "Không phù hợp với kỹ năng");
                                        },
                                      ),
                                      ListTile(
                                        title: const Text(
                                            'Tìm được công việc khác'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          cancelApplication(
                                              "Tìm được công việc khác");
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            reapplying();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                buttonText!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Gọi Điện',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      );
    });
  }
}

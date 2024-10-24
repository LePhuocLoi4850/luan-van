import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class JobGird extends StatefulWidget {
  const JobGird({super.key});

  @override
  State<JobGird> createState() => _JobGirdState();
}

class _JobGirdState extends State<JobGird> {
  late Future<List<List<dynamic>>> _jobAllId;
  late Future<List<List<dynamic>>> _jobWithCareer;
  late Future<List<List<dynamic>>> _jobInter;
  final PageController _pageController = PageController(
    viewportFraction: 1,
  );
  String inter = 'Thực tập';

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _jobAllId = DatabaseConnection().selectAllJobs();
    _jobWithCareer =
        DatabaseConnection().selectJobWithCareer(userProvider.userData!.career);
    _jobInter = DatabaseConnection().selectJobInter(inter);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 5, right: 5),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: Colors.orange,
                    ),
                    Text(
                      'Việc làm phù hợp',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 20, 121, 203),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<List<dynamic>>>(
                future: _jobWithCareer,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Không tìm thấy công việc nào.'));
                  } else {
                    final jobList = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        itemCount: jobList.length,
                        itemBuilder: (context, index) {
                          final jobData = {
                            'id': jobList[index][0],
                            'name': jobList[index][1],
                            'email': jobList[index][2],
                            'address': jobList[index][3],
                            'salary': jobList[index][4],
                          };
                          return Container(
                            width: 390,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 200, 200, 200)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: JobGirdTitle(jobData),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                    Text(
                      'Thực tập sinh',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 20, 121, 203)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<List<dynamic>>>(
                future: _jobInter,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Không tìm thấy công việc nào.'));
                  } else {
                    final jobList = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        physics: const ClampingScrollPhysics(),
                        itemCount: jobList.length,
                        itemBuilder: (context, index) {
                          final jobData = {
                            'id': jobList[index][0],
                            'name': jobList[index][1],
                            'email': jobList[index][2],
                            'address': jobList[index][3],
                            'salary': jobList[index][4],
                          };
                          return Container(
                            width: 390,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 200, 200, 200)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: JobGirdTitle(jobData),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.orange,
                    ),
                    Text(
                      'Việc làm Mới Nhất',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 20, 121, 203)),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<List<dynamic>>>(
                future: _jobAllId,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Không tìm thấy công việc nào.'));
                  } else {
                    final jobList = snapshot.data!.reversed.take(3).toList();
                    return SizedBox(
                      height: 550,
                      child: ListView.builder(
                        reverse: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: jobList.length,
                        itemBuilder: (context, index) {
                          final jobData = {
                            'id': jobList[index][0],
                            'name': jobList[index][1],
                            'email': jobList[index][2],
                            'address': jobList[index][3],
                            'salary': jobList[index][4],
                          };
                          return Container(
                            width: 390,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 200, 200, 200)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: JobGirdTitle(jobData),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Xem tất cả việc làm',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Ngành nghề nổi bậc',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 20, 121, 203)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('IT CNTT'),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('IT CNTT'),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(25)),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('IT CNTT'),
                        ],
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
  }
}

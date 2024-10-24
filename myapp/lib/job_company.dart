import 'package:flutter/material.dart';

import 'provider/status_provider.dart';
import 'ui/screens.dart';

class Job1 extends StatefulWidget {
  const Job1(this.job1, {super.key});
  final String job1;
  @override
  State<Job1> createState() => _Job1State();
}

class _Job1State extends State<Job1> {
  late Future<List<List<dynamic>>> _jobAllEmail;

  @override
  void initState() {
    super.initState();
    _jobAllEmail = DatabaseConnection().selectAllJobWithEmailC(widget.job1);
    _jobAllEmail.then((jobIds) {
      print('Job IDs pending: $jobIds');
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final statusProvider = Provider.of<StatusProvider>(context, listen: false);
    return PopScope(
      canPop: statusProvider.status,
      onPopInvoked: (didPop) {
        if (didPop) {
          statusProvider.toggleStatus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('Việc làm cùng công ty'),
          ),
          body: FutureBuilder<List<List<dynamic>>>(
            future: _jobAllEmail,
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
                return ListView.builder(
                  scrollDirection: Axis.vertical,
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
                            color: const Color.fromARGB(255, 200, 200, 200)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: JobGirdTitle(jobData),
                    );
                  },
                );
              }
            },
          )),
    );
  }
}

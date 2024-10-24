import 'package:flutter/material.dart';
import 'package:myapp/ui/screens.dart';

class JobPending extends StatefulWidget {
  const JobPending({super.key});

  @override
  State<JobPending> createState() => _JobPendingState();
}

class _JobPendingState extends State<JobPending> {
  late Future<List<List<dynamic>>> _allJobPanding;
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String status = 'applied';
    _allJobPanding =
        DatabaseConnection().selectAllJobPending(userProvider.email, status);
    _allJobPanding.then((jobIds) {
      print('Job IDs pending: $jobIds');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Công việc đang chờ duyệt'),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
          future: _allJobPanding,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Hoặc widget loading tùy ý
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final jobIds = snapshot.data!;
              return ListView.builder(
                  itemCount: jobIds.length,
                  itemBuilder: (context, index) {
                    final jobData = {
                      'id': jobIds[index][0],
                      'name': jobIds[index][1],
                      'email': jobIds[index][2],
                      'address': jobIds[index][3],
                      'salary': jobIds[index][4],
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
                  });
            }
          }),
    );
  }
}

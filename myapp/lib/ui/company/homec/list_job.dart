import 'package:flutter/material.dart';
import '../../../ui/screens.dart';

class ListJob extends StatefulWidget {
  const ListJob({super.key});

  @override
  State<ListJob> createState() => _ListJobState();
}

class _ListJobState extends State<ListJob> {
  late Future<List<List<dynamic>>> _jobList;
  String? email;

  @override
  void initState() {
    super.initState();
    final companyProvider =
        Provider.of<CompanyProvider>(context, listen: false);
    email = companyProvider.email;
    _fetchJob();
  }

  void _fetchJob() {
    setState(() {
      _jobList = DatabaseConnection().selectJob(email!);
      setState(() {
        _jobList;
      });
    });
  }

  Future<bool?> _handleDeleteJob(BuildContext context, String message, int id) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              DatabaseConnection().deleteJob(id);
              Navigator.of(ctx).pop(true);

              _fetchJob();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CompanyScreen(),
              ),
            );
          },
        ),
        title: const Text('Danh sách công việc'),
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: _jobList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không tìm thấy công việc nào.'));
          } else {
            final jobs = snapshot.data!;
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          job[1],
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit_rounded),
                                color: Colors.blue,
                                iconSize: 30,
                              ),
                              IconButton(
                                onPressed: () async {
                                  _handleDeleteJob(
                                    context,
                                    'Direct and straightforward?',
                                    job[0],
                                  );
                                },
                                icon: const Icon(Icons.delete_rounded),
                                color: Colors.red,
                                iconSize: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

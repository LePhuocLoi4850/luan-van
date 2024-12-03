import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';

class ListJob extends StatefulWidget {
  const ListJob({super.key});

  @override
  State<ListJob> createState() => _ListJobState();
}

class _ListJobState extends State<ListJob> {
  AuthController controller = Get.find<AuthController>();
  String? email;
  List<Map<String, dynamic>> _jobs = [];
  List<Map<String, dynamic>> _jobAll = [];
  List<Map<String, dynamic>> _jobEnable = [];
  List<Map<String, dynamic>> _jobDisable = [];
  bool _isLoading = true;
  int _jobFilterType = 1;

  @override
  void initState() {
    super.initState();
    _fetchJob();
  }

  void _fetchJob() async {
    final cid = await Database().selectIdCompanyForEmail(
        controller.companyModel.value.email.toString());
    try {
      final result = await Database().fetchJobForCid(cid);
      final resultEnable = await Database().fetchJobForCidAndStatus(cid, false);
      final resultDisable = await Database().fetchJobForCidAndStatus(cid, true);
      if (mounted) {
        setState(() {
          _jobs = result;
          _jobAll = result;
          _jobEnable = resultEnable;
          _jobDisable = resultDisable;
          _isLoading = false;
          switch (_jobFilterType) {
            case 1:
              _jobs = _jobAll;
              break;
            case 2:
              _jobs = _jobEnable;
              break;
            case 3:
              _jobs = _jobDisable;
              break;
          }
        });
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      setState(() {
        _isLoading = true;
      });
    }
  }

  Future<bool?> _handleDeleteJob(
      BuildContext context, String message, int jid) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Bạn chắc chắn?'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () {
              Database().deleteJob(jid, true);
              Navigator.of(ctx).pop(true);
              _fetchJob();
            },
            child: const Text('Có'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Danh sách công việc'),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              _jobFilterType = value;
              switch (value) {
                case 1:
                  setState(() {
                    _jobs = _jobAll;
                  });
                  break;
                case 2:
                  setState(() {
                    _jobs = _jobEnable;
                  });

                  break;
                case 3:
                  setState(() {
                    _jobs = _jobDisable;
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text('Tất cả công việc'),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text('Công việc hoạt động'),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text('Công việc bị ẩn'),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _jobs.length,
              itemBuilder: (context, index) {
                final job = _jobs[index];
                return ListTile(
                  title: Text(
                    job['title'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Text('${job['career']}'),
                  tileColor: job['status'] == true ? Colors.grey[300] : null,
                  trailing: FittedBox(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () async {
                              if (job['status'] != true) {
                                final result = await Get.toNamed('/editJob',
                                    arguments: job['jid']);
                                if (result != null) {
                                  setState(() {
                                    job['title'] = result['title'];
                                    job['career'] = result['career'];
                                  });
                                }
                              }
                            },
                            icon: Icon(
                              Icons.edit_square,
                              color: job['status'] == true
                                  ? Colors.grey[400]
                                  : Colors.green,
                              size: 25,
                            )),
                        IconButton(
                            onPressed: () {
                              job['status'] == true
                                  ? null
                                  : _handleDeleteJob(
                                      context,
                                      'Muốn ẩn công việc hiện tại?',
                                      job['jid'],
                                    );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: job['status'] == true
                                  ? Colors.grey[400]
                                  : Colors.red,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),
    );
  }
}

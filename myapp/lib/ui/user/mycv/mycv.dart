import 'package:flutter/material.dart';
import '../../../ui/screens.dart';
import 'job_denied.dart';
import 'job_pending.dart';
import 'job_received.dart';

class MyCVScreen extends StatefulWidget {
  const MyCVScreen({super.key});

  @override
  State<MyCVScreen> createState() => _MyCVScreenState();
}

class _MyCVScreenState extends State<MyCVScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${userProvider.userData?.name}'),
      ),
      body: Container(
        color: Color.fromARGB(255, 234, 234, 234),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: 400,
                height: 210,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: const Color.fromARGB(255, 230, 230, 230))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JobPending()),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.businessTime,
                                color: Colors.orange[400],
                              ),
                            ),
                            const Text(
                              'Công việc đang chờ duyêt',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JobReceived()),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.businessTime,
                                color: Colors.lightGreenAccent[700],
                              ),
                            ),
                            const Text(
                              'Công việc đã nhận',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const JobDenied()),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FaIcon(
                                FontAwesomeIcons.businessTime,
                                color: Colors.red[400],
                              ),
                            ),
                            const Text(
                              'Công việc bị từ chối',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../server/database.dart';

class AdminService extends StatefulWidget {
  const AdminService({super.key});

  @override
  State<AdminService> createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  List<Map<String, dynamic>> allService = [];
  Map<String, dynamic> data = {};
  int? countService;
  int count = 0;
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    allService = data['data'];
    countService = data['count_service'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(result: {'count_service': countService});
          },
        ),
        title: Text('Danh sách dịch vụ'),
        actions: [
          TextButton(
              onPressed: () async {
                final result = await Get.toNamed('/addService');

                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    allService.add(result);
                    countService = (countService ?? 0) + 1;
                  });
                }
              },
              child: Text('Thêm'))
        ],
      ),
      body: ListView.builder(
          itemCount: allService.length,
          itemBuilder: (context, index) {
            final sv = allService[index];
            return Padding(
              padding: EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed('/serviceDetail', arguments: sv['sv_id']);
                },
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sv['sv_name'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                sv['sv_price'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                              width: 300, child: Text(sv['sv_description'])),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                                child: Text(
                              'Đã mua: ${sv['num_companies_bought'] ?? 0}',
                              style: TextStyle(color: Colors.green),
                            )),
                            TextButton(
                              onPressed: () async {
                                Map<String, dynamic> data = {
                                  'sv_id': sv['sv_id'],
                                  'sv_name': sv['sv_name'],
                                  'sv_price': sv['sv_price'],
                                  'sv_description': sv['sv_description'],
                                };
                                final result = await Get.toNamed('/editService',
                                    arguments: data);
                                if (result != null) {
                                  setState(() {
                                    int index = allService.indexWhere(
                                        (sv) => sv['sv_id'] == result['sv_id']);
                                    allService[index] = result;
                                  });
                                }
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'Sửa',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Xác nhận xóa'),
                                      content: const Text(
                                          'Bạn có chắc chắn muốn xóa dịch vụ này?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Hủy'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Xóa'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();

                                            await Database()
                                                .deleteService(sv['sv_id']);
                                            setState(() {
                                              allService.removeWhere(
                                                  (service) =>
                                                      service['sv_id'] ==
                                                      sv['sv_id']);
                                              countService =
                                                  (countService ?? 0) - 1;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                'Xóa',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

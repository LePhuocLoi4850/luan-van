import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobapp/controller/favorites_controller.dart';
import 'package:jobapp/controller/user_controller.dart';
import 'package:jobapp/server/database.dart';
import 'package:jobapp/ui/admin/drawer.dart';
import 'package:jobapp/ui/auth/auth_controller.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  UserController usersController = Get.put(UserController());
  FavoritesController faController = Get.put(FavoritesController());

  final AuthController controller = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  List<Map<String, dynamic>> userData = [];
  List<Map<String, dynamic>> jobData = [];
  List<Map<String, dynamic>> serviceData = [];
  List<Map<String, dynamic>> payData = [];
  List<Map<String, dynamic>> paymentData = [];
  final _userController = ScrollController();
  List<ChartData> chartData = [];
  String _selectedInterval = 'week';
  late TooltipBehavior _tooltipBehavior;

  int? countUser;
  int? countCompany;
  int? countJob;
  int revenue = 0;
  int countService = 0;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _userController.addListener(() {
      userController.isScroll.value = _userController.position.pixels > 10;
    });
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      paymentData = await Database().fetchAllPayment();
      jobData = await Database().fetchAllJobChartAdmin();
      countUser = await Database().countUser();
      serviceData = await Database().fetchAllServiceAdmin();
      countCompany = await Database().countCompany();
      payData = await Database().fetchAllPayment();
      countJob = await Database().countJobs();
      countService = await Database().countService();
      revenue = await Database().calculateTotalPrice();
      _processChartData('week');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('fetch data admin: $e');
    }
  }

  void _processChartData(String interval) {
    chartData.clear();

    Map<String, Map<String, int>> groupedData = {};
    for (var payment in paymentData) {
      DateTime date = payment['day_order'];
      String serviceName = payment['sv_name']; // Lấy tên dịch vụ
      String key;
      switch (interval) {
        case 'week':
          key = '${date.year}-${date.weekOfYear}';
          break;
        case 'month':
          key = '${date.year}-${date.month}';
          break;
        case 'year':
          key = '${date.year}';
          break;
        default:
          key = '${date.year}-${date.weekOfYear}';
      }

      groupedData.putIfAbsent(serviceName, () => {});
      groupedData[serviceName]!.update(
        key,
        (value) => (value + payment['price']).toInt(),
        ifAbsent: () => payment['price'].toInt(),
      );
    }

    // Convert to ChartData objects
    groupedData.forEach((serviceName, serviceData) {
      serviceData.forEach((key, value) {
        chartData.add(ChartData(serviceName, key, value));
      });
    });
  }

  List<ColumnSeries<ChartData, String>> _getSeries() {
    Map<String, List<ChartData>> groupedByService = {};

    for (var data in chartData) {
      groupedByService.putIfAbsent(data.serviceName, () => []);
      groupedByService[data.serviceName]!.add(data);
    }

    return groupedByService.entries.map((entry) {
      return ColumnSeries<ChartData, String>(
        name: entry.key,
        dataSource: entry.value,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      );
    }).toList();
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat("#,##0", "en_US");
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: SpinKitSpinningLines(
              color: Colors.blue,
              size: 50.0,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.purple, Colors.red],
                ).createShader(bounds),
                child: const Text(
                  'NowCV',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: IconButton(
                      onPressed: () {
                        controller.logout();
                      },
                      icon: Icon(
                        Icons.logout,
                        color: const Color.fromARGB(255, 192, 19, 6),
                      ),
                    ))
              ],
              backgroundColor: Colors.white,
            ),
            drawer: AdminDrawer(
              countService: countService,
              serviceData: serviceData,
              onCountServiceChanged: (newCount) {
                setState(() {
                  countService = newCount;
                });
              },
            ),
            body: SafeArea(
              // Sử dụng SafeArea
              child: SingleChildScrollView(
                controller: _userController,
                child: Padding(
                  padding: const EdgeInsets.all(20), // Điều chỉnh padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildContainer(
                              'Ứng viên', countUser!.toString(), Colors.blue),
                          _buildContainer('Công ty', countCompany!.toString(),
                              Colors.green),
                          _buildContainer(
                              'Việc làm', countJob!.toString(), Colors.orange),
                          _buildContainer(
                              'Dịch vụ', countService.toString(), Colors.red),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF673AB7),
                              // Màu tím đậm
                              Color(0xFFE91E63) // Màu hồng
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Doanh thu',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${formatCurrency(revenue.toDouble())} VND',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(),
                              title: ChartTitle(text: 'Biểu đồ doanh thu'),
                              tooltipBehavior: _tooltipBehavior,
                              series: _getSeries(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildIntervalButton('Tuần', 'week'),
                              _buildIntervalButton('Tháng', 'month'),
                              _buildIntervalButton('Năm', 'year'),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelStyle: const TextStyle(fontSize: 10),
                              ),
                              title: ChartTitle(
                                  text:
                                      'Biểu đồ số lượng công việc và hồ sơ ứng tuyển'),
                              tooltipBehavior: _tooltipBehavior,
                              series: <CartesianSeries<Map<String, dynamic>,
                                  String>>[
                                ColumnSeries<Map<String, dynamic>, String>(
                                  name: 'Số lượng công việc',
                                  dataSource: jobData,
                                  xValueMapper:
                                      (Map<String, dynamic> data, _) =>
                                          data['nameC'],
                                  yValueMapper:
                                      (Map<String, dynamic> data, _) =>
                                          data['num_jobs'], // Sử dụng num_jobs
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  color: Colors.blue,
                                ),
                                ColumnSeries<Map<String, dynamic>, String>(
                                  name: 'Số lượng hồ sơ ứng tuyển',
                                  dataSource: jobData,
                                  xValueMapper:
                                      (Map<String, dynamic> data, _) =>
                                          data['nameC'],
                                  yValueMapper:
                                      (Map<String, dynamic> data, _) =>
                                          data['total_num_apply'],
                                  dataLabelSettings:
                                      DataLabelSettings(isVisible: true),
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: [
                                  WidgetSpan(
                                    child:
                                        Icon(Icons.square, color: Colors.blue),
                                  ),
                                  TextSpan(text: ' Số lượng công việc  '),
                                  WidgetSpan(
                                    child: Icon(Icons.square,
                                        color: Colors.orange),
                                  ),
                                  TextSpan(text: ' Số lượng hồ sơ ứng tuyển'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF2A2D3E),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  begin: Alignment
                                      .topLeft, // Thêm hiệu ứng gradient cho text
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, Colors.white70],
                                ).createShader(bounds),
                                child: const Text(
                                  'Danh sách Đơn hàng',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: payData.length,
                                itemBuilder: (context, index) {
                                  final pay = payData[index];
                                  return Card(
                                    elevation: 2,
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(15),
                                      leading: Icon(
                                        Icons.shopify_outlined,
                                        color: Colors.blue,
                                        size: 40,
                                      ),
                                      title: Text(
                                        pay['name'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${formatCurrency(pay['price'].toDouble())} VND',
                                            style: TextStyle(
                                              color: Colors
                                                  .green, // Màu xanh lá cây cho giá tiền
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            DateFormat('yyyy-MM-dd HH:mm:ss')
                                                .format(pay['day_order']),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios,
                                          size: 18), // Thêm icon mũi tên
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildIntervalButton(String label, String interval) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedInterval = interval;
            _processChartData(_selectedInterval);
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedInterval == interval ? Colors.blue : Colors.grey[300],
        ),
        child: Text(label),
      ),
    );
  }
}

class ChartData {
  ChartData(this.serviceName, this.x, this.y);
  final String serviceName; // Thêm tên dịch vụ
  final String x;
  final int y;
}

extension DateTimeExtensions on DateTime {
  int get weekOfYear {
    final firstDayOfYear = DateTime(this.year, 1, 1);
    final firstMonday = firstDayOfYear
        .add(Duration(days: (7 - firstDayOfYear.weekday + 1) % 7));
    final difference = this.difference(firstMonday).inDays;
    return (difference / 7).ceil() + 1;
  }
}

class AdminCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const AdminCard({
    Key? key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          boxShadow: [
            // Thêm đổ bóng cho card
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Icon(icon, size: 30, color: Colors.white), // Tăng kích thước icon
          ],
        ),
      ),
    );
  }
}

Widget _buildContainer(String title, String content, Color color) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      border: Border.all(color: color),
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(content),
      ],
    ),
  );
}

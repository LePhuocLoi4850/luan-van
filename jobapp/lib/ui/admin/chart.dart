import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:jobapp/server/database.dart';

class RevenueChart extends StatefulWidget {
  const RevenueChart({super.key});

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  List<Map<String, dynamic>> paymentData = [];
  bool isLoading = false;
  late TooltipBehavior _tooltipBehavior;
  List<ChartData> chartData = [];
  String _selectedInterval = 'week';

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      paymentData = await Database().fetchAllPayment();
      _processChartData(_selectedInterval);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu thanh toán: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Biểu đồ doanh thu'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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

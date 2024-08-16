import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:front/screens/historys/notification_screen.dart';
import 'package:front/theme/colors.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String _selectedPeriod = '일간';
  List<BarChartGroupData> barData = [];

  final List<NotificationItem> dailyLogs = [
    NotificationItem(DateTime(2024, 8, 1, 10, 30), 5),
    NotificationItem(DateTime(2024, 8, 1, 11, 45), 10),
    NotificationItem(DateTime(2024, 8, 1, 13, 20), 8),
    NotificationItem(DateTime(2024, 8, 1, 14, 10), 15),
    NotificationItem(DateTime(2024, 8, 2, 10, 30), 7),
    NotificationItem(DateTime(2024, 8, 2, 11, 45), 12),
    NotificationItem(DateTime(2024, 8, 2, 13, 20), 5),
    // 8월 14일부터 16일까지의 데이터 추가
    NotificationItem(DateTime(2024, 8, 14, 9, 0), 6),
    NotificationItem(DateTime(2024, 8, 14, 11, 0), 5),
    NotificationItem(DateTime(2024, 8, 14, 15, 0), 12),
    NotificationItem(DateTime(2024, 8, 15, 10, 0), 3),
    NotificationItem(DateTime(2024, 8, 15, 14, 0), 7),
    NotificationItem(DateTime(2024, 8, 15, 16, 0), 1),
    NotificationItem(DateTime(2024, 8, 16, 10, 30), 8),
    NotificationItem(DateTime(2024, 8, 16, 12, 30), 10),
    NotificationItem(DateTime(2024, 8, 16, 18, 0), 20),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateChartData();
  }

  void _updateChartData() {
    switch (_selectedPeriod) {
      case '일간':
        barData = _getDailyData();
        break;
      case '주간':
        barData = _getWeeklyData();
        break;
      case '월간':
        barData = _getMonthlyData();
        break;
    }
  }

  List<BarChartGroupData> _getDailyData() {
    final today = DateTime.now();
    final todayLogs = dailyLogs.where((log) =>
    log.time.year == today.year &&
        log.time.month == today.month &&
        log.time.day == today.day);

    return List.generate(24, (index) {
      final count = todayLogs
          .where((log) => log.time.hour == index)
          .fold<int>(0, (sum, log) => sum + log.count);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: Colors.black,
            width: MediaQuery.of(context).size.width / 28, // 막대그래프 너비 조정
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getWeeklyData() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final weeklyLogs = dailyLogs.where((log) =>
    log.time.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        log.time.isBefore(endOfWeek.add(const Duration(days: 1))));

    // 주간 데이터 집계
    List<int> weeklyCounts = List.filled(7, 0);
    weeklyLogs.forEach((log) {
      int dayOfWeek = log.time.weekday % 7; // 0 (일요일) ~ 6 (토요일)
      if (log.count >= 5) {
        weeklyCounts[dayOfWeek] += 1;
      }
    });

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyCounts[index].toDouble(),
            color: Colors.black,
            width: MediaQuery.of(context).size.width / 14, // 막대그래프 너비 조정
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getMonthlyData() {
    final today = DateTime.now();
    final firstDayOfMonth = DateTime(today.year, today.month, 1);
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;

    // 월간 데이터 집계
    List<int> monthlyCounts = List.filled(6, 0);

    dailyLogs.forEach((log) {
      if (log.time.year == today.year && log.time.month == today.month) {
        // 각 로그에 대해 해당 주차 계산
        int weekOfMonth = ((log.time.day - 1 + firstDayOfMonth.weekday) ~/ 7);
        if (log.count >= 5) {
          monthlyCounts[weekOfMonth] += 1;
        }
      }
    });

    return List.generate(6, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: monthlyCounts[index].toDouble(),
            color: Colors.black,
            width: MediaQuery.of(context).size.width / 14, // 막대그래프 너비 조정
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chartWidth = MediaQuery.of(context).size.width * 0.85; // 그래프 너비 조정
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: yelloMyStyle2,
          title: const Text(
            "분석 리포트",
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'PretendardBold'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
            children: [
              Center(
                child: SizedBox(
                  width: chartWidth, // 그래프 너비를 화면의 85%로 설정
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround, // 중앙 정렬
                      barGroups: barData,
                      gridData: FlGridData(show: false), // 세로줄 제거
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: _getYAxisInterval(), // Y축 간격 설정
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    color: blackMyStyle2,
                                    fontFamily: 'PretendardSemiBold',
                                    fontSize: 12,
                                    letterSpacing: -1.0, // 자간 더 좁히기
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _selectedPeriod == '일간'
                                      ? '${value.toInt()}'
                                      : _selectedPeriod == '주간'
                                      ? _getWeekDay(value.toInt())
                                      : '${value.toInt() + 1}주',
                                  style: const TextStyle(
                                    color: blackMyStyle2,
                                    fontFamily: 'PretendardSemiBold',
                                    fontSize: 12,
                                    letterSpacing: -1.0, // 자간 더 좁히기
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPeriodButton('일간'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('주간'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('월간'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: NotificationScreen(selectedPeriod: _selectedPeriod), // 알림 로그 리스트 표시
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getYAxisInterval() {
    double maxY = barData
        .map((data) => data.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);

    double interval = (maxY / 15).ceilToDouble();
    return interval > 0 ? interval : 1;
  }

  String _getWeekDay(int index) {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    final date = startOfWeek.add(Duration(days: index));
    return '${date.month}/${date.day}';
  }

  ElevatedButton _buildPeriodButton(String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
          _updateChartData();
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedPeriod == period ? yelloMyStyle1 : blackMyStyle2,
        foregroundColor: Colors.white,
      ),
      child: Text(period),
    );
  }
}


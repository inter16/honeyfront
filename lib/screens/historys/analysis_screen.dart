import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:front/theme/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:front/states/auth_provider.dart';

import 'notification_screen.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  List<NotificationItem> dailyLogs = [];
  List<NotificationItem> monthlyLogs = [];
  List<NotificationItem> yearlyLogs = [];
  String _selectedPeriod = '일간';
  List<BarChartGroupData> barData = [];
  ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllHistSumRequest(context);
  }

  void getAllHistSumRequest(BuildContext context) async {
    final url = Uri.parse('http://kulbul.iptime.org:8000/sensor/hist/all/sum');
    try {
      final response = await http.get(
        url,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Provider.of<AuthProvider>(context, listen: false).accessToken}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        setState(() {
          // Clear previous logs
          dailyLogs.clear();
          monthlyLogs.clear();
          yearlyLogs.clear();

          // Process daily logs
          responseData['day'].forEach((date, count) {
            final parts = date.split('-');
            if (parts.length == 4) {
              try {
                final year = int.parse(parts[0]);
                final month = int.parse(parts[1]);
                final day = int.parse(parts[2]);
                final hour = int.parse(parts[3]);
                DateTime parsedDate = DateTime(year, month, day, hour);
                dailyLogs.add(NotificationItem(parsedDate, count));
              } catch (e) {
                print("Error parsing day data: $date, error: $e");
              }
            } else {
              print("Invalid day data format: $date");
            }
          });

          // Process monthly logs
          responseData['month'].forEach((date, count) {
            final parts = date.split('-');
            if (parts.length == 3) {
              try {
                final year = int.parse(parts[0]);
                final month = int.parse(parts[1]);
                final day = int.parse(parts[2]);
                DateTime parsedDate = DateTime(year, month, day);
                monthlyLogs.add(NotificationItem(parsedDate, count));
              } catch (e) {
                print("Error parsing month data: $date, error: $e");
              }
            }
          });

          // Process yearly logs
          final currentMonth = DateTime.now();
          for (int i = 0; i < 12; i++) {
            final monthToConsider =
            DateTime(currentMonth.year, currentMonth.month - i, 1);
            String formattedDate =
                "${monthToConsider.year}-${monthToConsider.month.toString().padLeft(2, '0')}";
            yearlyLogs.add(NotificationItem(monthToConsider, responseData['year'][formattedDate] ?? 0));
          }

          _updateChartData(); // Update the chart data
        });
      } else if (response.statusCode == 400) {
        print('엑세스 토큰이 유효하지 않거나 만료되었습니다. 로그아웃합니다.');
        await Provider.of<AuthProvider>(context, listen: false).logout();
        context.go('/login');
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateChartData() {
    switch (_selectedPeriod) {
      case '일간':
        barData = _getDailyData();
        break;
      case '월간':
        barData = _getMonthlyData();
        break;
      case '연간':
        barData = _getYearlyData();
        break;
    }
  }

  List<BarChartGroupData> _getDailyData() {
    List<int> hourlyCounts = List.filled(24, 0);

    dailyLogs.forEach((log) {
      hourlyCounts[log.time.hour] += log.count;
    });

    return List.generate(24, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: hourlyCounts[index].toDouble(),
            color: Colors.black,
            width: 16,
            borderRadius: BorderRadius.zero, // 네모 모양 막대
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getMonthlyData() {
    List<int> dailyCounts = List.filled(31, 0);

    monthlyLogs.forEach((log) {
      final day = log.time.day;
      dailyCounts[day - 1] += log.count;
    });

    return List.generate(31, (index) {
      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: dailyCounts[index].toDouble(),
            color: Colors.black,
            width: 16,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _getYearlyData() {
    List<int> monthlyCounts = List.filled(12, 0);

    for (int i = 0; i < 12; i++) {
      final monthData = yearlyLogs[i];
      monthlyCounts[11 - i] = monthData.count;
    }

    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index + 1,
        barRods: [
          BarChartRodData(
            toY: monthlyCounts[index].toDouble(),
            color: Colors.black,
            width: 16,
            borderRadius: BorderRadius.zero,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: yelloMyStyle2,
        appBar: AppBar(
          backgroundColor: yelloMyStyle2,
          title: const Text(
            "분석 리포트",
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'PretendardBold',
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: SizedBox(
                    width: _getChartWidth(),
                    height: 250,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: barData,
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          verticalInterval: 1,
                          horizontalInterval: _getYAxisInterval(),
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                          getDrawingVerticalLine: (value) {
                            return FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: _getYAxisInterval(),
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'PretendardSemiBold',
                                      fontSize: 12,
                                      letterSpacing: -1.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // 오른쪽 제목 숨김
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false), // 위쪽 제목 숨김
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                if (_selectedPeriod == '일간') {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '${value.toInt()}시',
                                      style: const TextStyle(
                                        color: blackMyStyle1,
                                        fontFamily: 'PretendardSemiBold',
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else if (_selectedPeriod == '월간') {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      '${value.toInt()}일',
                                      style: const TextStyle(
                                        color: blackMyStyle1,
                                        fontFamily: 'PretendardSemiBold',
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else if (_selectedPeriod == '연간') {
                                  final currentMonth = DateTime.now();
                                  final monthToConsider = DateTime(
                                      currentMonth.year, currentMonth.month - (11 - value.toInt()), 1);
                                  final monthLabel = "${monthToConsider.month}월";

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      monthLabel,
                                      style: const TextStyle(
                                        color: blackMyStyle1,
                                        fontFamily: 'PretendardSemiBold',
                                        fontSize: 12,
                                        letterSpacing: -1.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            left: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        maxY: _getMaxYValue() * 1.2, // maxY 값을 추가하여 상단 여백 확보
                      ),
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
                  _buildPeriodButton('월간'),
                  const SizedBox(width: 8),
                  _buildPeriodButton('연간'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: NotificationScreen(
                  selectedPeriod: _selectedPeriod,
                  dailyLogs: dailyLogs,     // 일간 로그 데이터
                  monthlyLogs: monthlyLogs, // 월간 로그 데이터
                  yearlyLogs: yearlyLogs,   // 연간 로그 데이터
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getChartWidth() {
    switch (_selectedPeriod) {
      case '일간':
        return 24 * 40.0;
      case '월간':
        return 31 * 40.0;
      case '연간':
        return 12 * 40.0;
      default:
        return MediaQuery.of(context).size.width;
    }
  }

  double _getYAxisInterval() {
    if (barData.isEmpty) {
      return 1;
    }

    double maxY = barData
        .map((data) => data.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);

    double interval = (maxY / 15).ceilToDouble();
    return interval > 0 ? interval : 1;
  }

  double _getMaxYValue() {
    if (barData.isEmpty) {
      return 1;
    }
    return barData
        .map((data) => data.barRods.map((rod) => rod.toY).reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);
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
        backgroundColor:
        _selectedPeriod == period ? yelloMyStyle1 : blackMyStyle2,
        foregroundColor:
        _selectedPeriod == period ? blackMyStyle2 : whiteMyStyle1,
      ),
      child: Text(period),
    );
  }
}

import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String selectedPeriod;
  final List<NotificationItem> dailyLogs;
  final List<NotificationItem> monthlyLogs;
  final List<NotificationItem> yearlyLogs;

  NotificationScreen({
    required this.selectedPeriod,
    required this.dailyLogs,
    required this.monthlyLogs,
    required this.yearlyLogs,
  });

  @override
  Widget build(BuildContext context) {
    List<NotificationItem> logs;
    String Function(NotificationItem) logFormatter;

    switch (selectedPeriod) {
      case '일간':
        logs = _getHourlyMaxLogs(); // 시간대별 최대값 로그 가져오기
        logFormatter = (item) =>
        "${item.time.hour}시 내에 최대 ${item.count}마리 발견";
        break;
      case '월간':
        logs = _getMonthlyLogs(); // 월간 로그 가져오기
        logFormatter = (item) => "${item.time.day}일에 총 ${item.count}마리 발견";
        break;
      case '연간':
        logs = _getYearlyLogs(); // 연간 로그 가져오기
        logFormatter = (item) =>
        "${item.time.year}년 ${item.time.month}월에 총 ${item.count}마리 발견";
        break;
      default:
        logs = _getHourlyMaxLogs(); // 기본적으로 시간대별 로그
        logFormatter = (item) =>
        "${item.time.hour}시 내에 최대 ${item.count}마리 발견";
        break;
    }

    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.bug_report, color: Colors.red),
          title: Text(
            logFormatter(logs[index]),
            style: const TextStyle(fontSize: 16),
          ),
        );
      },
    );
  }

  // 시간대별 최대값 로그 가져오기
  List<NotificationItem> _getHourlyMaxLogs() {
    List<NotificationItem> hourlyMaxLogs = [];

    for (int hour = 0; hour < 24; hour++) {
      final logsInHour = dailyLogs.where((log) => log.time.hour == hour);
      if (logsInHour.isNotEmpty) {
        final maxCount = logsInHour.map((log) => log.count).reduce((a, b) => a > b ? a : b);
        hourlyMaxLogs.add(NotificationItem(DateTime.now().copyWith(hour: hour), maxCount));
      }
    }

    return hourlyMaxLogs;
  }

  // 월간 로그 처리 (monthlyLogs를 사용)
  List<NotificationItem> _getMonthlyLogs() {
    Map<DateTime, int> dailyCounts = {};

    // 날짜별로 총 마리 수 계산
    monthlyLogs.forEach((log) {
      final dateOnly = DateTime(log.time.year, log.time.month, log.time.day);
      dailyCounts.update(dateOnly, (value) => value + log.count, ifAbsent: () => log.count);
    });

    // 날짜별 총 마리 수 기반으로 NotificationItem 생성
    return dailyCounts.entries
        .map((entry) => NotificationItem(entry.key, entry.value))
        .toList();
  }

  // 연간 로그 처리 (yearlyLogs를 사용)
  List<NotificationItem> _getYearlyLogs() {
    Map<DateTime, int> monthlyCounts = {};

    // 월별로 총 마리 수 계산
    yearlyLogs.forEach((log) {
      final monthOnly = DateTime(log.time.year, log.time.month, 1);
      monthlyCounts.update(monthOnly, (value) => value + log.count, ifAbsent: () => log.count);
    });

    // 월별 총 마리 수 기반으로 NotificationItem 생성
    return monthlyCounts.entries
        .map((entry) => NotificationItem(entry.key, entry.value))
        .toList();
  }
}

class NotificationItem {
  final DateTime time;
  final int count;

  NotificationItem(this.time, this.count);
}

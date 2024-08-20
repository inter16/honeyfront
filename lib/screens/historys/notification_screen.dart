import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String selectedPeriod;
  final List<NotificationItem> dailyLogs;

  NotificationScreen({required this.selectedPeriod, required this.dailyLogs});

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
        logFormatter = (item) =>
        "${item.time.day}일에 5마리 이상 발견 ${item.count}회";
        break;
      case '연간':
        logs = _getYearlyLogs(); // 연간 로그 가져오기
        logFormatter = (item) =>
        "${item.time.year}년 ${item.time.month}월에 5마리 이상 발견 ${item.count}회";
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

  // 월간 로그 가져오기
  List<NotificationItem> _getMonthlyLogs() {
    final today = DateTime.now();
    final monthlyLogs = dailyLogs.where((log) =>
    log.time.year == today.year && log.time.month == today.month);

    List<NotificationItem> filteredLogs = [];
    Map<DateTime, int> dailyCounts = {};

    monthlyLogs.forEach((log) {
      if (log.count >= 5) {
        final dateOnly = DateTime(log.time.year, log.time.month, log.time.day);
        dailyCounts.update(dateOnly, (value) => value + 1, ifAbsent: () => 1);
      }
    });

    dailyCounts.forEach((date, count) {
      filteredLogs.add(NotificationItem(date, count));
    });

    return filteredLogs;
  }

  // 연간 로그 가져오기
  List<NotificationItem> _getYearlyLogs() {
    final today = DateTime.now();
    final yearlyLogs = dailyLogs.where((log) =>
    log.time.year == today.year); // 해당 년도의 로그 가져오기

    List<NotificationItem> filteredLogs = [];
    Map<DateTime, int> monthlyCounts = {};

    yearlyLogs.forEach((log) {
      if (log.count >= 5) {
        final dateOnly = DateTime(log.time.year, log.time.month, 1); // 월별로 묶기
        monthlyCounts.update(dateOnly, (value) => value + 1, ifAbsent: () => 1);
      }
    });

    monthlyCounts.forEach((date, count) {
      filteredLogs.add(NotificationItem(date, count));
    });

    return filteredLogs;
  }
}

class NotificationItem {
  final DateTime time;
  final int count;

  NotificationItem(this.time, this.count);
}

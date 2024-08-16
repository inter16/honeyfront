import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String selectedPeriod;

  NotificationScreen({required this.selectedPeriod});

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
  Widget build(BuildContext context) {
    List<NotificationItem> logs;
    String Function(NotificationItem) logFormatter;

    switch (selectedPeriod) {
      case '주간':
        logs = _getWeeklyLogs();
        logFormatter = (item) =>
        "${item.time.month}/${item.time.day}에 5마리 이상 발견 ${item.count}회";
        break;
      case '월간':
        logs = _getMonthlyLogs().map((log) {
          final count = dailyLogs
              .where((item) =>
          item.time.year == log.time.year &&
              item.time.month == log.time.month &&
              item.time.day == log.time.day &&
              item.count >= 5)
              .length;
          return NotificationItem(log.time, count);
        }).toList();
        logFormatter = (item) =>
        "${item.time.day}일에 5마리 이상 발견 ${item.count}회";
        break;
      default:
        logs = _getTodayLogs();
        logFormatter = (item) =>
        "${item.time.hour.toString().padLeft(2, '0')}:${item.time.minute.toString().padLeft(2, '0')}에 말벌 ${item.count}마리 발견";
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

  List<NotificationItem> _getTodayLogs() {
    final today = DateTime.now();
    return dailyLogs
        .where((log) =>
    log.time.year == today.year &&
        log.time.month == today.month &&
        log.time.day == today.day)
        .toList();
  }

  List<NotificationItem> _getWeeklyLogs() {
    final today = DateTime.now();
    final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final weeklyLogs = dailyLogs.where((log) =>
    log.time.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        log.time.isBefore(endOfWeek.add(const Duration(days: 1))));

    // 주간 로그에서 하루에 하나의 로그만 출력하고, 그 개수를 세서 표시
    List<NotificationItem> filteredLogs = [];
    Map<DateTime, int> dailyCounts = {};

    weeklyLogs.forEach((log) {
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

  List<NotificationItem> _getMonthlyLogs() {
    final today = DateTime.now();
    final monthlyLogs = dailyLogs.where((log) =>
    log.time.year == today.year && log.time.month == today.month);

    // 월간 로그에서 하루에 하나의 로그만 출력하고, 그 개수를 세서 표시
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
}

class NotificationItem {
  final DateTime time;
  final int count;

  NotificationItem(this.time, this.count);
}
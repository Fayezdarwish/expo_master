import 'package:flutter/material.dart';
import '../api/BoothApi.dart';  // تأكد من المسار الصحيح

class VisitorStatsScreen extends StatefulWidget {
  @override
  _VisitorStatsScreenState createState() => _VisitorStatsScreenState();
}

class _VisitorStatsScreenState extends State<VisitorStatsScreen> {
  int? visitorsCount;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVisitorStats();
  }

  Future<void> loadVisitorStats() async {
    final count = await BoothApi.getVisitorStats();
    setState(() {
      visitorsCount = count;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        appBar: AppBar(title: Text('إحصائيات الزوار')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('إحصائيات الزوار')),
      body: Center(
        child: Text(
          'عدد الزوار: $visitorsCount',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

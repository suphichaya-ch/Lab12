import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class PostStatsScreen extends StatelessWidget {
  const PostStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();
    final posts = postProvider.posts;

    // คำนวณข้อมูล
    int total = posts.length;
    int marketCount = posts.where((p) => p.category == 'ตลาดนัด').length;
    int meritCount = posts.where((p) => p.category == 'งานบุญ').length;
    int meetingCount = posts.where((p) => p.category == 'ประชุม').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("สถิติภาพรวมกิจกรรม", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("สรุปกิจกรรม", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatBox("ทั้งหมด", total.toString(), Colors.blueAccent, Icons.all_inclusive),
                const SizedBox(width: 12),
                _buildStatBox("ตลาดนัด", marketCount.toString(), Colors.pinkAccent, Icons.storefront),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatBox("งานบุญ", meritCount.toString(), Colors.orangeAccent, Icons.temple_hindu),
                const SizedBox(width: 12),
                _buildStatBox("อื่นๆ", (total - marketCount - meritCount).toString(), Colors.grey, Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 32),
            const Text("สัดส่วนกิจกรรม", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildChartRow("ตลาดนัด", marketCount, total, Colors.pinkAccent),
            _buildChartRow("งานบุญ", meritCount, total, Colors.orangeAccent),
            _buildChartRow("ประชุม", meetingCount, total, Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartRow(String label, int count, int total, Color color) {
    double progress = total == 0 ? 0 : count / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(label, style: const TextStyle(fontWeight: FontWeight.w600)), Text("$count รายการ")],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: color,
            minHeight: 12,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
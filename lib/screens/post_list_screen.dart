import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import 'post_form_screen.dart';
import 'post_stats_screen.dart'; // 1. อย่าลืมสร้างและ Import ไฟล์สถิติที่ผมให้ก่อนหน้า

class PostListScreen extends StatelessWidget {
  const PostListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.watch<PostProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD), 
      appBar: AppBar(
        title: const Text("กิจกรรมชุมชน", 
          style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.w900, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          // 2. เพิ่มปุ่มไปหน้าสถิติ
          IconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PostStatsScreen())), 
            icon: const Icon(Icons.bar_chart, color: Colors.blueAccent)
          ),
          // 3. เพิ่มปุ่มตัวกรอง
          IconButton(
            onPressed: () => _showFilterSheet(context), 
            icon: const Icon(Icons.filter_list, color: Colors.blueAccent)
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ค้นหากิจกรรมหรือข่าวสาร...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: postProvider.posts.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: postProvider.posts.length,
                    itemBuilder: (context, index) {
                      final post = postProvider.posts[index];
                      return _buildModernCard(context, post, index);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PostFormScreen())),
        label: const Text("สร้างกิจกรรมใหม่", style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.celebration_rounded),
        backgroundColor: Colors.pinkAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // --- ฟังก์ชันเสริมสำหรับตัวกรอง (Filter) ---
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(32),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("กรองกิจกรรม", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              const Text("หมวดหมู่"),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ["ทั้งหมด", "ตลาดนัด", "งานบุญ", "ประชุม", "กีฬา"].map((cat) {
                  return ActionChip(
                    label: Text(cat),
                    onPressed: () => Navigator.pop(context),
                    backgroundColor: Colors.blue[50],
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: const Text("ตกลง", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available_outlined, size: 100, color: Colors.blue[50]),
          const SizedBox(height: 16),
          Text("ยังไม่มีกิจกรรมในเร็วๆ นี้", style: TextStyle(color: Colors.grey[400], fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildModernCard(BuildContext context, post, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getCategoryColor(post.category).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(post.category).withOpacity(0.1), 
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Icon(_getIcon(post.category), color: _getCategoryColor(post.category), size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                      Text(post.category, style: TextStyle(color: _getCategoryColor(post.category), fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                  child: const Text("เปิดรับสมัคร", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(post.detail, style: TextStyle(color: Colors.grey[600], height: 1.4)),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text("เร็วๆ นี้", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                  onPressed: () {
                    // 4. แก้จาก index เป็น id เพราะเราใช้ SQLite แล้ว
                    if (post.id != null) {
                      context.read<PostProvider>().deletePost(post.id!);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'ตลาดนัด': return Icons.storefront_rounded;
      case 'งานบุญ': return Icons.temple_hindu_rounded;
      case 'ประชุม': return Icons.groups_rounded;
      case 'กีฬา': return Icons.sports_soccer_rounded;
      default: return Icons.event_note_rounded;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'ตลาดนัด': return Colors.pinkAccent;
      case 'งานบุญ': return Colors.orangeAccent;
      case 'ประชุม': return Colors.blueAccent;
      case 'กีฬา': return Colors.greenAccent;
      default: return Colors.purpleAccent;
    }
  }
}
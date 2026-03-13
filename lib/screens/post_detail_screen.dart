import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/community_post.dart';
import '../providers/post_provider.dart';

class PostDetailScreen extends StatelessWidget {
  final CommunityPost post;
  final int index; // เพิ่ม index เข้ามาเพื่อให้ลบข้อมูลได้ถูกต้อง

  const PostDetailScreen({super.key, required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text('รายละเอียดรายงาน', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // ปุ่มลบดีไซน์ใหม่
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ส่วนแสดง Tag หมวดหมู่
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                post.category,
                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // หัวข้อ
            Text(
              post.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF2D3142)),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            // รายละเอียด
            const Text(
              'รายละเอียดปัญหา:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              post.detail,
              style: const TextStyle(fontSize: 18, height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณต้องการลบรายงานนี้ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              // ลบข้อมูลโดยใช้ index แทน id
              context.read<PostProvider>().deletePost(index);
              Navigator.pop(ctx); // ปิด Dialog
              Navigator.pop(context); // กลับหน้า List
            },
            child: const Text('ลบข้อมูล', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
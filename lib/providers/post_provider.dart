import 'package:flutter/material.dart';
import '../models/community_post.dart';
import '../database/database_helper.dart'; // เช็คว่า path นี้ถูกต้องนะครับ

class PostProvider extends ChangeNotifier {
  List<CommunityPost> _posts = [];
  List<CommunityPost> get posts => _posts;

  // ดึงข้อมูลทั้งหมด
  Future<void> loadPosts() async {
    final data = await DatabaseHelper.instance.getPosts(); // เปลี่ยนเป็น getPosts ตามมาตรฐานเดิมของคุณ
    if (data != null) {
      _posts = data.map((item) => CommunityPost.fromMap(item)).toList();
    } else {
      _posts = [];
    }
    notifyListeners();
  }

  // เพิ่มข้อมูล
  Future<void> addPost(CommunityPost post) async {
    await DatabaseHelper.instance.insertPost(post.toMap());
    await loadPosts(); // โหลดใหม่ทันทีหลังจากเพิ่ม
  }

  // ลบข้อมูล
  Future<void> deletePost(int id) async {
    await DatabaseHelper.instance.deletePost(id);
    await loadPosts(); // โหลดใหม่ทันทีหลังจากลบ
  }
}
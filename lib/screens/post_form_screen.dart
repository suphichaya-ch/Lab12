import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../models/community_post.dart';

class PostFormScreen extends StatefulWidget {
  const PostFormScreen({super.key});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _detailController = TextEditingController();
  
  // 1. เปลี่ยนค่าเริ่มต้นหมวดหมู่ให้ตรงกับระบบกิจกรรม
  String _category = "ทั่วไป";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        // 2. เปลี่ยนชื่อ Title ให้เข้ากับระบบกิจกรรม
        title: const Text("สร้างกิจกรรมใหม่", 
          style: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection("รายละเอียดกิจกรรม", Icons.celebration_rounded),
              const SizedBox(height: 20),
              
              _buildLabel("ชื่อกิจกรรมหรือหัวข้อข่าวสาร"),
              _buildTextField(_titleController, "เช่น ตลาดนัดวันหยุด, ประชุมหมู่บ้าน"),
              
              const SizedBox(height: 24),
              
              _buildLabel("รายละเอียดกิจกรรม"),
              _buildTextField(_detailController, "ระบุวัน เวลา สถานที่ และสิ่งที่น่าสนใจ...", maxLines: 5),
              
              const SizedBox(height: 24),
              
              _buildLabel("ประเภทกิจกรรม"),
              _buildDropdown(),
              
              const SizedBox(height: 40),
              
              // 3. ปรับสีปุ่มเป็น PinkAccent เพื่อให้สดใสเหมือนหน้ากิจกรรม
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _savePost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  child: const Text("ยืนยันการเพิ่มกิจกรรม", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.pinkAccent, size: 20),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(color: Colors.pinkAccent, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF4F5E7B))),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
        ),
        validator: (v) => v!.isEmpty ? "กรุณากรอกข้อมูลในช่องนี้" : null,
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _category,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.pinkAccent),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          onChanged: (v) => setState(() => _category = v!),
          // 4. เปลี่ยนรายการหมวดหมู่ให้ตรงกับหน้า List และ Stats
          items: ["ตลาดนัด", "งานบุญ", "ประชุม", "กีฬา", "ทั่วไป"].map((String value) {
            return DropdownMenuItem<String>(
              value: value, 
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      // 5. บันทึกลง SQLite ผ่าน Provider (โค้ดนี้จะดึง id มาจากฐานข้อมูลอัตโนมัติ)
      context.read<PostProvider>().addPost(CommunityPost(
        title: _titleController.text,
        detail: _detailController.text,
        category: _category,
      ));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("แชร์ข่าวสารในชุมชนเรียบร้อยแล้ว!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    }
  }
}
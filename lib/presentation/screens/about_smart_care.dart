import 'package:flutter/material.dart';
class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("حول التطبيق")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Image.network('https://cdn-icons-png.flaticon.com/512/822/822118.png', height: 100), // أيقونة تجريبية
            SizedBox(height: 20),
            Text(
              "تطبيق بنك الدم الذكي",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              "هذا التطبيق يهدف لتقليل الفجوة بين المتبرعين والمحتاجين للدم. تم تطويره بكل حب لدعم العمل الإنساني.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            Spacer(),
            Text("إصدار التطبيق 1.0.0", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
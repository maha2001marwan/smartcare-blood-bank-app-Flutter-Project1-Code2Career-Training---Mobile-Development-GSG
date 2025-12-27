import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/screens/login_screen.dart';
import 'package:my_flutter_app/presentation/screens/notifications.dart';
import 'package:provider/provider.dart';
import 'about_smart_care.dart';
import '../provider/blood_provider.dart'; // ✅ استيراد BloodProvider

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodProvider>(context); // ✅ تصحيح: BloodProvider وليس AppProvider

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("ملفي الشخصي", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.redAccent,
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    provider.userName, // ✅ استخدام userName من BloodProvider
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text("متبرع دائم", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildProfileOption(
              icon: Icons.notifications_active_outlined,
              title: "التنبيهات",
              subtitle: "إشعارات حالات التبرع القريبة",
              color: Colors.orange,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  NotificationsScreen()));
              },
            ),
            _buildProfileOption(
              icon: Icons.info_outline,
              title: "حول التطبيق",
              subtitle: "معلومات عن المطور والأهداف",
              color: Colors.blue,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  AboutAppScreen()));
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: "تسجيل الخروج",
              subtitle: "العودة لشاشة البداية",
              color: Colors.red,
              onTap: () {
                provider.logout();
                Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  LoginScreen(),
                                ),
                              );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
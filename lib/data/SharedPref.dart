import 'package:my_flutter_app/data/models/donor.dart';
import 'package:my_flutter_app/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPref {
  // ✅ حفظ بيانات المستخدم الكاملة
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_blood', user.bloodType);
    await prefs.setString('user_phone', user.phone);
    await prefs.setString('user_city', user.city);
    await prefs.setString('user_password', user.password);
    await prefs.setBool('user_is_donor', user.isDonor);
    await prefs.setBool('is_logged_in', true);
    
    // حفظ User ككامل object
    await prefs.setString('user_data', json.encode(user.toMap()));
    
    print('✅ User saved: ${user.name}');
  }

  // ✅ جلب بيانات المستخدم الكاملة
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // أولاً: تحقق إذا مسجل دخول
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      if (!isLoggedIn) {
        print('❌ User not logged in');
        return null;
      }
      
      // ثانياً: حاول جلب البيانات من الـ object الكامل
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final Map<String, dynamic> data = json.decode(userData);
        final user = User.fromMap(data);
        print('✅ User loaded from full data: ${user.name}');
        return user;
      }
      
      // ثالثاً: إذا فشل، جلب البيانات من الحقول المنفصلة
      final id = prefs.getString('user_id');
      if (id == null) {
        print('❌ No user id found');
        return null;
      }
      
      final user = User(
        id: id,
        name: prefs.getString('user_name') ?? 'مستخدم',
        email: prefs.getString('user_email') ?? '',
        bloodType: prefs.getString('user_blood') ?? 'O+',
        phone: prefs.getString('user_phone') ?? '',
        city: prefs.getString('user_city') ?? '',
        password: prefs.getString('user_password') ?? '',
        isDonor: prefs.getBool('user_is_donor') ?? false,
      );
      
      print('✅ User loaded from separate fields: ${user.name}');
      return user;
      
    } catch (e) {
      print('❌ Error loading user: $e');
      return null;
    }
  }

  // ✅ تحقق إذا كان مسجل دخول
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    print('🔍 isLoggedIn: $isLoggedIn');
    return isLoggedIn;
  }

  // ✅ تحديث حقل isDonor فقط
  static Future<void> updateIsDonor(bool isDonor) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // تحديث الحقل المنفصل
      await prefs.setBool('user_is_donor', isDonor);
      
      // تحديث الـ user_data الكامل
      final userData = prefs.getString('user_data');
      if (userData != null) {
        Map<String, dynamic> data = json.decode(userData);
        data['isDonor'] = isDonor;
        await prefs.setString('user_data', json.encode(data));
      }
      
      print('✅ isDonor updated to: $isDonor');
    } catch (e) {
      print('❌ Error updating isDonor: $e');
    }
  }

  // ✅ حفظ إشعارات
  static Future<void> saveNotification(String title, String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // جلب الإشعارات القديمة
      List<String> notifications = prefs.getStringList('notifications') ?? [];
      
      // إضافة الإشعار الجديد
      final notification = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title,
        'message': message,
        'time': DateTime.now().toString(),
        'read': false,
      };
      
      notifications.add(json.encode(notification));
      
      // حفظ فقط آخر 50 إشعار
      if (notifications.length > 50) {
        notifications = notifications.sublist(notifications.length - 50);
      }
      
      await prefs.setStringList('notifications', notifications);
      
      print('✅ Notification saved: $title');
    } catch (e) {
      print('❌ Error saving notification: $e');
    }
  }

  // ✅ جلب الإشعارات
  static Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('notifications') ?? [];
      
      return notifications.map((item) {
        return json.decode(item) as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('❌ Error getting notifications: $e');
      return [];
    }
  }

  // ✅ تسجيل الخروج
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', false);
      print('✅ User logged out');
    } catch (e) {
      print('❌ Error logging out: $e');
    }
  }
}
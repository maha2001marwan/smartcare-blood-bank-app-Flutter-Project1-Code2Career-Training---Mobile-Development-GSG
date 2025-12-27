import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/data/models/donor.dart';

class ApiService {
  // الرابط الأساسي للـ API
  static const String baseUrl = 'https://dummyjson.com';

  // جلب جميع المتبرعين
  static Future<List<Donor>> fetchDonors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> users = data['users'];
        
        return users.map((user) => Donor.fromJson(user)).toList();
      } else {
        throw Exception('فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      print('خطأ في API: $e');
      return [];
    }
  }

  // جلب المتبرعين حسب فصيلة الدم
  static Future<List<Donor>> fetchDonorsByBloodType(String bloodType) async {
    final allDonors = await fetchDonors();
    if (bloodType == 'الكل') return allDonors;
    return allDonors.where((donor) => donor.bloodType == bloodType).toList();
  }
}
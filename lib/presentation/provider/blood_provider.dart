import 'package:flutter/material.dart';
import 'package:my_flutter_app/data/SharedPref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/donor.dart';
import '../../data/models/user.dart';
import '../../data/api_data.dart';
import 'dart:convert';

class BloodProvider with ChangeNotifier {
  List<Donor> _donors = [];
  List<Donor> _filteredDonors = [];
  String _selectedBloodType = 'الكل';
  bool _isLoading = false;
  User? _currentUser;
  List<Map<String, dynamic>> _notifications = [];

  // Getters
  List<Donor> get donors => _filteredDonors;
  bool get isLoading => _isLoading;
  String get selectedBloodType => _selectedBloodType;
  User? get currentUser => _currentUser;
  List<Map<String, dynamic>> get notifications => _notifications;
  String get userName => _currentUser?.name ?? 'زائر';

  // ✅ أضف هذه الدوال الجديدة

  Future<void> registerUser(User user) async {
    try {
      // حفظ المستخدم
      await SharedPref.saveUser(user);
      
      // تحديث المستخدم الحالي
      _currentUser = user;
      
      // إضافة إشعار ترحيبي
      await _addWelcomeNotification();
      
      // إذا كان متبرعاً، أضفه للقائمة
      if (user.isDonor) {
        await _addUserToDonors();
      }
      
      print('✅ User registered: ${user.name}');
      notifyListeners();
      
    } catch (e) {
      print('❌ Error registering user: $e');
      rethrow;
    }
  }

  Future<void> _addWelcomeNotification() async {
    if (_currentUser == null) return;
    
    try {
      final welcomeNotification = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'مرحباً بك! 👋',
        'message': 'تم إنشاء حسابك بنجاح. مرحباً بك ${_currentUser!.name}',
        'time': DateTime.now().toString(),
        'read': false,
      };
      
      _notifications.insert(0, welcomeNotification);
      await _saveNotifications();
      
      print('✅ Welcome notification added');
    } catch (e) {
      print('❌ Error adding welcome notification: $e');
    }
  }

  Future<void> _addUserToDonors() async {
    if (_currentUser == null) return;
    
    try {
      final donor = _currentUser!.toDonor();
      
      // تحقق إذا المتبرع موجود مسبقاً
      if (!_donors.any((d) => d.id == donor.id)) {
        _donors.insert(0, donor);
        _filteredDonors.insert(0, donor);
        
        print('✅ User added to donors list: ${donor.name}');
        notifyListeners();
      }
    } catch (e) {
      print('❌ Error adding user to donors: $e');
    }
  }

  // ✅ أضف دالة makeUserDonor
  Future<void> makeUserDonor() async {
    if (_currentUser == null) return;
    
    try {
      // تحديث المستخدم
      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        bloodType: _currentUser!.bloodType,
        phone: _currentUser!.phone,
        city: _currentUser!.city,
        password: _currentUser!.password,
        isDonor: true,
      );
      
      // حفظ في SharedPreferences
      await SharedPref.updateIsDonor(true);
      
      // إضافة لقائمة المتبرعين
      await _addUserToDonors();
      
      // إضافة إشعار
      addNotification(
        title: 'مبروك! 🎉',
        message: 'أصبحت الآن متبرعاً مسجلاً في قائمة المتبرعين',
        type: 'success'
      );
      
      print('✅ User is now a donor: ${_currentUser!.name}');
      notifyListeners();
      
    } catch (e) {
      print('❌ Error making user donor: $e');
      rethrow;
    }
  }

  // ✅ تحديث initializeApp
  Future<void> initializeApp() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('🚀 Starting app initialization...');
      
      // 1. تحميل بيانات المستخدم
      await _loadUserData();
      
      // 2. إذا كان مسجلاً، أضف إشعار ترحيبي
      if (_currentUser != null) {
        // إضافة إشعار إذا لم تكن هناك إشعارات
        if (_notifications.isEmpty) {
          final notification = {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'title': 'مرحباً بعودتك!',
            'message': 'تم تسجيل دخولك بنجاح. مرحباً بك ${_currentUser!.name} 👋',
            'time': DateTime.now().toString(),
            'read': false,
          };
          _notifications.insert(0, notification);
        }
      }
      
      // 3. تحميل المتبرعين
      await _loadDonorsFromApi();
      
      // 4. تحميل الإشعارات
      await _loadNotifications();
      
      // 5. إذا كان المستخدم متبرعاً، تأكد من وجوده في القائمة
      if (_currentUser?.isDonor ?? false) {
        await _addUserToDonors();
      }
      
      print('✅ App initialized successfully');
      
    } catch (e) {
      print('❌ Error initializing app: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ تحديث _loadUserData
  Future<void> _loadUserData() async {
    try {
      _currentUser = await SharedPref.getUser();
      
      if (_currentUser != null) {
        print('👤 User loaded: ${_currentUser!.name}');
        print('👤 User is donor: ${_currentUser!.isDonor}');
        print('👤 User email: ${_currentUser!.email}');
      } else {
        print('👤 No user logged in');
      }
    } catch (e) {
      print('❌ Error loading user: $e');
      _currentUser = null;
    }
  }

  // ✅ تحديث loginUser
  Future<void> loginUser(User user) async {
    try {
      // حفظ المستخدم
      await SharedPref.saveUser(user);
      
      // تحديث المستخدم الحالي
      _currentUser = user;
      
      // إضافة إشعار ترحيبي
      addNotification(
        title: 'مرحباً بعودتك ${user.name}',
        message: 'تم تسجيل دخولك بنجاح',
        type: 'success'
      );
      
      // إذا كان متبرعاً، أضفه للقائمة
      if (user.isDonor) {
        await _addUserToDonors();
      }
      
      print('✅ User logged in: ${user.name}');
      notifyListeners();
      
    } catch (e) {
      print('❌ Error logging in: $e');
      rethrow;
    }
  }

  // ✅ الباقي من الكود الحالي يبقى كما هو...

  // ... باقي الدوال الحالية تبقى كما هي ...

  // الدوال الحالية الباقية
  Future<void> fetchDonors() async {
    return _loadDonorsFromApi();
  }

  Future<void> _loadDonorsFromApi() async {
    try {
      _isLoading = true;
      notifyListeners();

      _donors = await ApiService.fetchDonors();
      _filteredDonors = List.from(_donors);
      print('Donors loaded: ${_donors.length}');
      
      await _cacheDonors();
    } catch (e) {
      print('Error loading donors from API: $e');
      await _loadCachedDonors();
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _cacheDonors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final donorsJson = _donors.map((donor) => donor.toMap()).toList();
      await prefs.setString('cached_donors', json.encode(donorsJson));
      print('Donors cached successfully');
    } catch (e) {
      print('Error caching donors: $e');
    }
  }

  Future<void> _loadCachedDonors() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cached_donors');
      
      if (cachedData != null) {
        final List<dynamic> donorsList = json.decode(cachedData);
        _donors = donorsList.map((item) => Donor.fromJson(item)).toList();
        _filteredDonors = List.from(_donors);
        print('Loaded ${_donors.length} donors from cache');
      }
    } catch (e) {
      print('Error loading cached donors: $e');
    }
  }

  void filterDonors(String bloodType) {
    _selectedBloodType = bloodType;
    
    if (bloodType == 'الكل') {
      _filteredDonors = List.from(_donors);
    } else {
      _filteredDonors = _donors.where((donor) => donor.bloodType == bloodType).toList();
    }
    
    _saveSearchHistory(bloodType);
    notifyListeners();
  }

  void filterDonorsByBloodType(String bloodType) {
    filterDonors(bloodType);
  }

  void searchDonors(String query) {
    if (query.isEmpty) {
      filterDonors(_selectedBloodType);
    } else {
      _filteredDonors = _donors.where((donor) {
        return donor.name.toLowerCase().contains(query.toLowerCase()) ||
               donor.city.toLowerCase().contains(query.toLowerCase()) ||
               donor.bloodType.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    
    notifyListeners();
  }

  Future<void> logout() async {
    await SharedPref.logout();
    _currentUser = null;
    
    addNotification(
      title: 'تم تسجيل الخروج',
      message: 'نتمنى لك يوماً سعيداً',
      type: 'info'
    );
    
    notifyListeners();
  }

  Future<void> fetchDonorsFromAPI() async {
    await _loadDonorsFromApi();
  }

  void addNotification({required String title, required String message, String type = 'info'}) {
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'message': message,
      'type': type,
      'time': DateTime.now().toString(),
      'read': false,
    };
    
    _notifications.insert(0, notification);
    _saveNotifications();
    notifyListeners();
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notifications', json.encode(_notifications));
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }

  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('notifications');
      
      if (data != null) {
        final List<dynamic> notificationsList = json.decode(data);
        _notifications = notificationsList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }
  void markNotificationAsRead(String id) {
  final index = _notifications.indexWhere((n) => n['id'] == id);
  if (index != -1) {
    _notifications[index]['read'] = true;
    _saveNotifications();
    notifyListeners();
  }
}

// حذف إشعار
void removeNotification(String id) {
  _notifications.removeWhere((n) => n['id'] == id);
  _saveNotifications();
  notifyListeners();
}

// مسح جميع الإشعارات المقروءة
void clearAllNotifications() {
  _notifications.removeWhere((n) => n['read'] == true);
  _saveNotifications();
  notifyListeners();
}

  Future<void> _saveSearchHistory(String bloodType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> history = prefs.getStringList('search_history') ?? [];
      
      if (!history.contains(bloodType) && bloodType != 'الكل') {
        history.insert(0, bloodType);
        if (history.length > 5) history.removeLast();
        await prefs.setStringList('search_history', history);
      }
    } catch (e) {
      print('Error saving search history: $e');
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList('search_history') ?? [];
      print('Search history loaded: $history');
    } catch (e) {
      print('Error loading search history: $e');
    }
  }

  Map<String, int> getDonorStats() {
    final Map<String, int> stats = {};
    
    for (final donor in _donors) {
      stats[donor.bloodType] = (stats[donor.bloodType] ?? 0) + 1;
    }
    
    return stats;
  }

  List<Donor> getCompatibleDonors() {
    if (_currentUser == null) return [];
    
    return _donors.where((donor) {
      return donor.bloodType == _currentUser!.bloodType;
    }).toList();
  }
}
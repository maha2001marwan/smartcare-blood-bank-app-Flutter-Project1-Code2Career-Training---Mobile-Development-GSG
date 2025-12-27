import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/screens/navigation_screens.dart';
import 'package:my_flutter_app/presentation/screens/notifications.dart';
import 'package:provider/provider.dart';
import '../provider/blood_provider.dart';
import '../widgets/donor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BloodProvider>(context, listen: false).initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodProvider>(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // شريط التطبيق الحديث
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: false, floating: true,
              centerTitle: true,
              title: const Text(
                'الرئيسية',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: Badge(
                    backgroundColor: Colors.redAccent,
                    label: Text(
                      provider.notifications.length.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black87,
                      size: 26,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  NotificationsScreen(),
                      ),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(10),
                child: Container(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
            ),
          ];
        },
        body: provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                  strokeWidth: 2.5,
                ),
              )
            : SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // بطاقة الترحيب الحديثة
                      _buildModernWelcomeCard(provider),
                      
                      const SizedBox(height: 24),
                      
                      // بطاقة الإحصائيات الحديثة
                      _buildModernStatsSection(provider),
                      
                      const SizedBox(height: 24),
                      
                      // القائمة السريعة الحديثة
                      _buildModernQuickActions(),
                      
                      const SizedBox(height: 24),
                      
                      // قائمة المتبرعين المتوافقين
                      _buildModernCompatibleDonors(provider),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // بطاقة الترحيب الحديثة
  Widget _buildModernWelcomeCard(BloodProvider provider) {
    final user = provider.currentUser;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Colors.red.shade600,
            Colors.redAccent,
            Colors.red.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // الخلفية الزخرفية
          Positioned(
            right: 0,
            top: 0,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.bloodtype,
                size: 120,
                color: Colors.white,
              ),
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة والاسم
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.bloodtype_rounded,
                        color: Colors.redAccent,
                        size: 36,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user != null 
                              ? 'مرحباً، ${user.name} 👋' 
                              : 'مرحباً، زائر 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        
                        const SizedBox(height: 6),
                        
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.bloodtype_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user != null
                                    ? 'فصيلة دمك: ${user.bloodType}'
                                    : 'سجل الدخول الآن',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // شارة المتبرع أو زر الانضمام
              if (user != null && !user.isDonor)
                GestureDetector(
                  onTap: () {
                    _showBecomeDonorDialog(context, provider);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.add_circle_outlined,
                                color: Colors.redAccent,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'انضم كمتبرع',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'ساعد في إنقاذ حياة',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white.withOpacity(0.7),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                )
              else if (user?.isDonor ?? false)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'متبرع مسجل',
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // نص تحفيزي
              Text(
                '"قطرة دم يمكنها إنقاذ حياة"',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // بطاقة الإحصائيات الحديثة
  Widget _buildModernStatsSection(BloodProvider provider) {
    final stats = provider.getDonorStats();
    final totalDonors = provider.donors.length;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'إحصائيات المتبرعين',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${totalDonors}+',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // بطاقة الإحصائيات
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: [
              // الصف العلوي
              Row(
                children: [
                  _buildModernStatItem(
                    icon: Icons.people_alt_rounded,
                    value: totalDonors.toString(),
                    label: 'إجمالي المتبرعين',
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 16),
                  _buildModernStatItem(
                    icon: Icons.emergency_rounded,
                    value: '12',
                    label: 'طلبات اليوم',
                    color: Colors.orange,
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // قسم توزيع فصائل الدم
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.pie_chart_outline_rounded,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'توزيع فصائل الدم',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // فصائل الدم
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: stats.entries.map((entry) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _getBloodColor(entry.key).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getBloodColor(entry.key).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bloodtype,
                              color: _getBloodColor(entry.key),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              entry.key,
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${entry.value}',
                              style: TextStyle(
                                color: _getBloodColor(entry.key),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // عنصر إحصائي حديث
  Widget _buildModernStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // القائمة السريعة الحديثة
  Widget _buildModernQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإجراءات السريعة',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 16),
        
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildModernActionCard(
              title: 'طلب متبرع',
              subtitle: 'إضافة طلب جديد',
              icon: Icons.add_circle_rounded,
              color: Colors.redAccent,
              iconColor: Colors.white,
              index: 2,
            ),
            _buildModernActionCard(
              title: 'بحث متقدم',
              subtitle: 'ابحث عن متبرعين',
              icon: Icons.search_rounded,
              color: Colors.blue,
              iconColor: Colors.white,
              index: 1,
            ),
            _buildModernActionCard(
              title: 'موعد تبرعي',
              subtitle: 'إدارة مواعيدك',
              icon: Icons.calendar_today_rounded,
              color: Colors.green,
              iconColor: Colors.white,
              index: 0,
            ),
            _buildModernActionCard(
              title: 'نصائح صحية',
              subtitle: 'إرشادات مهمة',
              icon: Icons.health_and_safety_rounded,
              color: Colors.orange,
              iconColor: Colors.white,
              index: 3,
            ),
          ],
        ),
      ],
    );
  }

  // بطاقة إجراء سريع حديثة
  Widget _buildModernActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required int index,
  }) {
    return InkWell(
      onTap: () => _navigateToScreen(index),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color.withOpacity(0.05),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 26,
                  ),
                ),
              ),
              
              const Spacer(),
              
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // قائمة المتبرعين المتوافقين
  Widget _buildModernCompatibleDonors(BloodProvider provider) {
    final compatibleDonors = provider.donors
        .where((donor) => donor.bloodType == provider.currentUser?.bloodType)
        .take(3)
        .toList();
    
    if (compatibleDonors.isEmpty) {
      return Container();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'متبرعون متوافقون معك',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (compatibleDonors.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const NavigationScreens(initialIndex: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'عرض الكل',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.redAccent,
                        size: 14,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        ...compatibleDonors.map((donor) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DonorCard(donor: donor),
          );
        }).toList(),
      ],
    );
  }

  // دالة التنقل للشاشات
  void _navigateToScreen(int index) {
    if (index == 0) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => NavigationScreens(initialIndex: index),
      ),
    );
  }

  // نافذة تأكيد التسجيل كمتبرع (نفس الكود)
  void _showBecomeDonorDialog(BuildContext context, BloodProvider provider) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(Icons.bloodtype_rounded, color: Colors.red),
              SizedBox(width: 10),
              Text('انضم كمتبرع'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'بأنضمامك كمتبرع:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Expanded(child: Text('سيظهر اسمك في قائمة المتبرعين')),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Expanded(child: Text('يمكن للآخرين التواصل معك عند الحاجة')),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 8),
                  Expanded(child: Text('ستتلقى إشعارات بالحالات الطارئة')),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'هل أنت متأكد من رغبتك في الانضمام؟',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('لاحقاً', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await provider.makeUserDonor();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تمت إضافتك إلى قائمة المتبرعين بنجاح!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('حدث خطأ: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('نعم، انضم الآن'),
            ),
          ],
        ),
      ),
    );
  }

  // الحصول على لون حسب فصيلة الدم
  Color _getBloodColor(String bloodType) {
    switch (bloodType) {
      case 'A+': return Colors.red[800]!;
      case 'B+': return Colors.blue[800]!;
      case 'AB+': return Colors.purple[800]!;
      case 'O+': return Colors.green[800]!;
      case 'A-': return Colors.red[400]!;
      case 'B-': return Colors.blue[400]!;
      case 'AB-': return Colors.purple[400]!;
      case 'O-': return Colors.green[400]!;
      default: return Colors.grey;
    }
  }
}
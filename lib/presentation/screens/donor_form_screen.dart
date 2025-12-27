import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/text_field%20.dart';
import 'package:provider/provider.dart';
import '../provider/blood_provider.dart';

class BloodRequestForm extends StatefulWidget {
  const BloodRequestForm({super.key});

  @override
  State<BloodRequestForm> createState() => _BloodRequestFormState();
}

class _BloodRequestFormState extends State<BloodRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _hospitalLocationController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _urgencyLevelController = TextEditingController();
  final TextEditingController _additionalNotesController = TextEditingController();
  
  bool _isLoading = false;
  
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> _urgencyLevels = ['عاجل جداً', 'عاجل', 'متوسط', 'غير عاجل'];

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalLocationController.dispose();
    _contactNumberController.dispose();
    _bloodTypeController.dispose();
    _urgencyLevelController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // محاكاة عملية الإرسال
      await Future.delayed(const Duration(seconds: 2));
      
      // الحصول على البروفايدر
      final provider = Provider.of<BloodProvider>(context, listen: false);
      
      // إضافة إشعار جديد
      provider.addNotification(
        title: 'طلب دم عاجل 🚨',
        message: 'طلب دم لفصيلة ${_bloodTypeController.text} لـ ${_patientNameController.text}',
        type: 'warning'
      );
      
      // إظهار رسالة نجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'تم نشر طلبك بنجاح! سيتم إشعار المتبرعين المناسبين.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      
      // مسح الحقول بعد النجاح
      _formKey.currentState!.reset();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // شريط التطبيق الحديث
              SliverAppBar(
                actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ], leading: Container(), 
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: false,
                floating: true,
                centerTitle: true,
                title: const Text(
                  'طلب دم عاجل',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(10),
                  child: Container(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),

              // شريط الرأس مع صورة وأيقونة
              SliverToBoxAdapter(
                child: _buildHeaderSection(),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات عامة
                  _buildSectionTitle('معلومات الطلب'),
                  
                  // اسم المريض
                  ModernTextField(
                    controller: _patientNameController,
                    labelText: 'اسم المريض',
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المريض';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // فصيلة الدم المطلوبة
                  ModernTextField(
                    controller: _bloodTypeController,
                    labelText: 'فصيلة الدم المطلوبة',
                    prefixIcon: Icons.bloodtype_outlined,
                    isDropdown: true,
                    dropdownItems: _bloodTypes,
                    onDropdownChanged: (value) {
                      _bloodTypeController.text = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء اختيار فصيلة الدم';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // مستوى العجلة
                  ModernTextField(
                    controller: _urgencyLevelController,
                    labelText: 'مستوى العجلة',
                    prefixIcon: Icons.warning_amber_rounded,
                    isDropdown: true,
                    dropdownItems: _urgencyLevels,
                    onDropdownChanged: (value) {
                      _urgencyLevelController.text = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء اختيار مستوى العجلة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // معلومات الاتصال
                  _buildSectionTitle('معلومات الاتصال'),
                  
                  // موقع المستشفى
                  ModernTextField(
                    controller: _hospitalLocationController,
                    labelText: 'موقع المستشفى',
                    prefixIcon: Icons.location_on_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال موقع المستشفى';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // رقم التواصل
                  ModernTextField(
                    controller: _contactNumberController,
                    labelText: 'رقم التواصل',
                    prefixIcon: Icons.phone_iphone_rounded,
                    prefixText: '+970 ',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم التواصل';
                      }
                      if (value.length < 9) {
                        return 'رقم التواصل يجب أن يكون 9 أرقام على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // ملاحظات إضافية
                  _buildSectionTitle('ملاحظات إضافية'),
                  
                  ModernTextField(
                    controller: _additionalNotesController,
                    labelText: 'ملاحظات إضافية (اختياري)',
                    prefixIcon: Icons.note_outlined,
                  ),

                  const SizedBox(height: 40),

                  // زر الإرسال
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send_rounded, size: 22),
                                SizedBox(width: 12),
                                Text(
                                  'نشر الطلب الآن',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ملاحظات مهمة
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'سيتم إشعار جميع المتبرعين المناسبين فور نشر الطلب.',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // قسم العنوان
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.shade50,
            Colors.red.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.sos_rounded,
                color: Colors.redAccent,
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'طلب استغاثة عاجل',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'املأ المعلومات التالية بدقة ليتم إشعار المتبرعين المناسبين في أقرب وقت',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // عنوان القسم
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
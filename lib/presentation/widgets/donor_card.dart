import 'package:flutter/material.dart';
import '../../data/models/donor.dart';

class DonorCard extends StatelessWidget {
  final Donor donor;
  final VoidCallback? onCallPressed;

  const DonorCard({
    super.key,
    required this.donor,
    this.onCallPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(donor.imageUrl),
          backgroundColor: Colors.grey[200],
        ),
        title: Text(
          donor.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('فصيلة الدم: ${donor.bloodType}'),
            Text('المدينة: ${donor.city}'),
            Text('آخر تبرع: ${donor.lastDonation}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.phone, color: Colors.green),
          onPressed: onCallPressed ?? () {
            // عند الضغط على الهاتف
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('الاتصال'),
                content: Text('هل تريد الاتصال بـ ${donor.name}؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // هنا يمكن إضافة كود الاتصال الفعلي
                    },
                    child: const Text('اتصال'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
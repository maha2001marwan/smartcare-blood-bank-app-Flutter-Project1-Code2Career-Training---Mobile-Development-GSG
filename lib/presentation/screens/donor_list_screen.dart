import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/blood_provider.dart';
import '../widgets/donor_card.dart';

class DonorsListScreen extends StatefulWidget {
  const DonorsListScreen({super.key});
  @override
  State<DonorsListScreen> createState() => _DonorsListScreenState();
}

class _DonorsListScreenState extends State<DonorsListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BloodProvider>(context, listen: false).fetchDonors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BloodProvider>(context); // ✅ تصحيح: BloodProvider وليس AppProvider
    final List<String> bloodTypes = ['الكل', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "البحث عن متبرع",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bloodTypes.length,
              itemBuilder: (context, index) {
                bool isSelected = provider.selectedBloodType == bloodTypes[index];
                return GestureDetector(
                  onTap: () => provider.filterDonorsByBloodType(bloodTypes[index]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.redAccent),
                    ),
                    child: Center(
                      child: Text(
                        bloodTypes[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.donors.isEmpty // ✅ تصحيح: donors وليس filteredDonors
                    ? const Center(child: Text('لا يوجد متبرعون بهذه الفصيلة.'))
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchDonorsFromAPI(),
                        child: ListView.builder(
                          itemCount: provider.donors.length,
                          itemBuilder: (context, index) {
                            final donor = provider.donors[index];
                            return DonorCard(donor: donor);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
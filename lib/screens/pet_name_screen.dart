// lib/screens/pet_name_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class PetNameScreen extends StatefulWidget {
  const PetNameScreen({Key? key}) : super(key: key);

  @override
  State<PetNameScreen> createState() => _PetNameScreenState();
}

class _PetNameScreenState extends State<PetNameScreen> {
  String? selectedPetName;
  bool isDropdownOpen = false;
  
  final List<String> petNames = [
    'Discount Romeo',
    'Emotional Goldfish',
    'Walking Red Flag',
    'Clown in Disguise',
    'Expired Snack',
    'Human Typo',
    'Bargain Bin Prince',
    'Recycled Disappointment',
    'Clearance Casanova',
    'Knock-off Knight',
    'Budget Boyfriend',
    'Temporary Trash',
    'Plastic Prince',
    'Wannabe King',
    'Fake Fortune',
    'Discount Drama',
    'Clearance Clown',
    'Bargain Basement Boy',
    'Expired Energy',
    'Waste of WiFi',
  ];

  void _selectRandomPetName() {
    final random = Random();
    setState(() {
      selectedPetName = petNames[random.nextInt(petNames.length)];
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$text" to clipboard!'),
        backgroundColor: const Color(0xFFE85A4F),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
        title: const Text('Pet Name Generator'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Main Title
            const Text(
              'Give that excuse of a human a pet-name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 40),
            
            // Dropdown Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isDropdownOpen = !isDropdownOpen;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedPetName ?? 'Select for a pet-name.....',
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedPetName != null ? Colors.black87 : Colors.grey.shade600,
                            fontWeight: selectedPetName != null ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        Icon(
                          isDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.grey.shade700,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Suggestions Section
            const Text(
              'Here are a few suggestions for you;',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            
            // Pet Name Suggestions
            Expanded(
              child: ListView.builder(
                itemCount: petNames.take(6).length,
                itemBuilder: (context, index) {
                  final petName = petNames[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedPetName = petName;
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: selectedPetName == petName 
                                      ? const Color(0xFFE85A4F) 
                                      : Colors.grey.shade600,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  petName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedPetName == petName 
                                        ? const Color(0xFFE85A4F) 
                                        : Colors.black87,
                                    fontWeight: selectedPetName == petName 
                                        ? FontWeight.w600 
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (selectedPetName == petName)
                                IconButton(
                                  onPressed: () => _copyToClipboard(petName),
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 20,
                                    color: Color(0xFFE85A4F),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Random Generator Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: _selectRandomPetName,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFB347),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Generate Random Pet Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            // Copy Button (shown when pet name is selected)
            if (selectedPetName != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () => _copyToClipboard(selectedPetName!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE85A4F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.copy, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Copy "${selectedPetName!}"',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _selectRandomPetName,
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
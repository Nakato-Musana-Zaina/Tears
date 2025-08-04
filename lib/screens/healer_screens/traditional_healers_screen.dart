// lib/screens/healer_screens/traditional_healers_screen.dart

import 'package:flutter/material.dart';
import 'package:tears/services/healer_services.dart';
import 'package:tears/widgets/custom_fab.dart';
import '../../models/healer_model.dart';


class TraditionalHealersScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const TraditionalHealersScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<TraditionalHealersScreen> createState() => _TraditionalHealersScreenState();
}

class _TraditionalHealersScreenState extends State<TraditionalHealersScreen> {
  List<HealerModel> healers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHealers();
  }

  Future<void> _loadHealers() async {
    try {
      final data = await HealerService.getHealersByType('traditional');
      if (mounted) {
        setState(() {
          healers = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load traditional healers: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Traditional Healers"),
        backgroundColor: Color(0xFF590201),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Looking for more healers...")),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(color: Color(0xFF590201)),
      );
    }
    if (healers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied, size: 40, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              "No traditional healers found.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      itemCount: healers.length,
      separatorBuilder: (context, index) => Divider(indent: 80, endIndent: 16),
      itemBuilder: (context, index) {
        final healer = healers[index];
        return _buildHealerCard(healer);
      },
    );
  }

  Widget _buildHealerCard(HealerModel healer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Starting chat with ${healer.name}...")),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  backgroundColor: Color(0xFFF8D56C),
                  radius: 32,
                  child: Text(
                    healer.name[0].toUpperCase(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        healer.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${healer.specialty} • ${healer.contact}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFF590201),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Traditional",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chat, color: Color(0xFFFEC106)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
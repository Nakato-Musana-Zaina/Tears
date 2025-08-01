import 'package:flutter/material.dart';
import 'package:volume_key_board/volume_key_board.dart'; // Updated import
import 'package:volume_key_board/volume_key_board.dart' as _volumeKeyBoard;
import '../widgets/thought_circle.dart';
import '../widgets/analytics_graph.dart';
import '../widgets/savage_message_card.dart';
import '../models/message_model.dart';
import '../services/thought_service.dart';
import '../services/message_service.dart';
import 'dart:async'; // for StreamSubscription

class HomeScreen extends StatefulWidget {
  final dynamic isDarkMode;
  
  final dynamic toggleTheme;

  const HomeScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int thoughtCount = 0;
  List<int> weeklyData = [];
  List<MessageModel> latestMessages = [];
  String motivationalMessage = '';
  bool isLoading = true;
  String selectedTimeRange = 'Weekly';

  final int userId = 1; // Set your user ID here

  late final VolumeKeyBoard _volumeKeyBoard; // For volume buttons

 


  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final stats = await ThoughtService.getThoughtStats(userId);
      final weeklyCount = await ThoughtService.getWeeklyThoughtCount(userId);
      final messages = await MessageService.getAllMessages();
      final motivation = await ThoughtService.getMotivationalMessage(userId);

      setState(() {
        thoughtCount = stats['today'] ?? 0;
        weeklyData = [weeklyCount]; // Correct assignment
        latestMessages = messages.take(3).toList();
        motivationalMessage = motivation;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading data: $e');
    }
  }

  Future<void> _logThought() async {
    final success = await ThoughtService.logThought(userId);
    if (success) {
      setState(() => thoughtCount++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thought logged successfully!')),
      );
    } else {
      // Optional: handle failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log thought')),
      );
    }
  }

  Future<void> fetchThoughtStatsForRange(String range) async {
    setState(() {
      selectedTimeRange = range;
    });
    // Implement backend call if needed for range-specific data
  }

  Widget buildAnalyticsDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Analytics Range: ', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedTimeRange,
          items: ['Weekly', 'Monthly', 'Yearly']
              .map((label) => DropdownMenuItem(
                    child: Text(label),
                    value: label,
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              fetchThoughtStatsForRange(value);
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: 40),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _logThought();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error increasing thought count: $e')),
            );
          }
        },
        tooltip: 'Increase Thought Count',
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Here\'s the number of times that you have thought about the Discount Romeo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ThoughtCircle(
                          count: thoughtCount,
                          onTap: _logThought,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildAnalyticsDropdown(),
                      const SizedBox(height: 16),
                      const Text(
                        'Weekly thought analytics',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: AnalyticsGraph(weeklyData: weeklyData),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Latest Savage Roasting Messages',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...latestMessages.map((message) => SavageMessageCard(
                        message: message,
                        onFavorite: () => _toggleFavorite(message),
                        onCopy: () => _copyMessage(message.text),
                      )),
                      const SizedBox(height: 16),
                      if (motivationalMessage.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFB347), Color(0xFFE85A4F)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            motivationalMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _toggleFavorite(MessageModel message) async {
    final success = await MessageService.toggleFavorite(message.id);
    if (success) {
      setState(() {
        final index = latestMessages.indexWhere((m) => m.id == message.id);
        if (index >= 0) {
          latestMessages[index] =
              message.copyWith(isFavorite: !message.isFavorite);
        }
      });
    }
  }

  void _copyMessage(String text) {
    // Copy to clipboard logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Message copied to clipboard!')),
    );
  }
}

// class _volumeKeyBoard {
// }


// class _handleVolumeButtonPress {
// }
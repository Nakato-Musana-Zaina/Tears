// // 📁 lib/widgets/savage_message_card.dart
// import 'package:flutter/material.dart';
// import '../models/message_model.dart';

// class SavageMessageCard extends StatelessWidget {
//   final MessageModel message;
//   final VoidCallback? onFavorite;
//   final VoidCallback? onCopy;

//   const SavageMessageCard({
//     Key? key,
//     required this.message,
//     this.onFavorite,
//     this.onCopy,
//   }) : super(key: key);

//   Color _getCategoryColor() {
//     switch (message.category.toLowerCase()) {
//       case 'good':
//         return const Color(0xFF4CAF50);
//       case 'blasting':
//         return const Color(0xFFE85A4F);
//       case 'peaceful':
//         return const Color(0xFF2196F3);
//       default:
//         return const Color(0xFF8B1538);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: _getCategoryColor(), width: 1),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade200,
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _getCategoryColor().withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     message.category.toUpperCase(),
//                     style: TextStyle(
//                       color: _getCategoryColor(),
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     if (onCopy != null)
//                       IconButton(
//                         onPressed: onCopy,
//                         icon: const Icon(Icons.copy, size: 20),
//                         color: Colors.grey.shade600,
//                       ),
//                     if (onFavorite != null)
//                       IconButton(
//                         onPressed: onFavorite,
//                         icon: Icon(
//                           message.isFavorite ? Icons.favorite : Icons.favorite_border,
//                           size: 20,
//                         ),
//                         color: message.isFavorite ? Colors.red : Colors.grey.shade600,
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               message.text,
//               style: const TextStyle(
//                 fontSize: 16,
//                 height: 1.4,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// lib/widgets/savage_message_card.dart
import 'package:flutter/material.dart';
import '../models/message_model.dart';

class SavageMessageCard extends StatelessWidget {
  final MessageModel message;
  final VoidCallback? onFavorite;
  final VoidCallback? onCopy;

  const SavageMessageCard({
    Key? key,
    required this.message,
    this.onFavorite,
    this.onCopy,
  }) : super(key: key);

  Color _getCategoryColor() {
    switch (message.category.toLowerCase()) {
      case 'good':
        return const Color(0xFF4CAF50);
      case 'blasting':
        return const Color(0xFFE85A4F);
      case 'peaceful':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF8B1538);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCategoryColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    message.category.toUpperCase(),
                    style: TextStyle(
                      color: _getCategoryColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: onCopy,
                      tooltip: 'Copy Message',
                      color: Colors.grey.shade600,
                    ),
                    IconButton(
                      icon: Icon(
                        message.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: message.isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: onFavorite,
                      tooltip: 'Favorite',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message.text,
              style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
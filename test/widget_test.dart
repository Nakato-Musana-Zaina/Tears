// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tears/main.dart';

void main() {
  testWidgets('Tears app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TearsApp());

    // Verify that our app loads with the correct title
    expect(find.text('Tears - Thought Tracker'), findsOneWidget);
    
    // Verify that the thought counter starts at 0 (will be updated from API)
    expect(find.textContaining('Thoughts: '), findsOneWidget);
    
    // Verify that the psychology icon is present
    expect(find.byIcon(Icons.psychology), findsOneWidget);
    
    // Verify that the analytics buttons are present
    expect(find.text('This Week'), findsOneWidget);
    expect(find.text('This Month'), findsOneWidget);
    expect(find.text('This Year'), findsOneWidget);
    
    // Verify that the monitor button is present
    expect(find.text('Monitor'), findsOneWidget);
  });

  testWidgets('Analytics buttons work correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TearsApp());

    // Tap the 'This Week' button
    await tester.tap(find.text('This Week'));
    await tester.pump();

    // Tap the 'This Month' button
    await tester.tap(find.text('This Month'));
    await tester.pump();

    // Tap the 'This Year' button
    await tester.tap(find.text('This Year'));
    await tester.pump();

    // All buttons should still be present after tapping
    expect(find.text('This Week'), findsOneWidget);
    expect(find.text('This Month'), findsOneWidget);
    expect(find.text('This Year'), findsOneWidget);
  });

  testWidgets('Monitor button works correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(TearsApp());

    // Tap the monitor button
    await tester.tap(find.text('Monitor'));
    await tester.pump();

    // The button should still be present after tapping
    expect(find.text('Monitor'), findsOneWidget);
  });
}




// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:tears/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }

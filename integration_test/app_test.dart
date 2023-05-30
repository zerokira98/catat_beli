// // // This is a basic Flutter widget test.
// // //
// // // To perform an interaction with a widget in your test, use the WidgetTester
// // // utility that Flutter provides. For example, you can send tap and scroll
// // // gestures. You can also use WidgetTester to find child widgets in the widget
// // // tree, read text, and verify that the values of widget properties are correct.
// // import 'package:catatbeli/page/sidebar/sidebar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:catatbeli/main.dart' as app;
// // import 'package:kasir/main.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   group('end-to-end test', () {
//     testWidgets('search widget', (tester) async {
//       await app.main();
//       await tester.pumpAndSettle();

//       // Verify the counter starts at 0.
//       expect(find.text('load'), findsOneWidget);

//       final Finder fab = find.byWidget(Text('load'));

//       await tester.pumpAndSettle();

//       // Verify the counter increments by 1.
//       expect(find.text('1.0'), findsOneWidget);
//     });
//   });
// }

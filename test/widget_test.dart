import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grieve_app/main.dart';

void main() {
  testWidgets('GrievanceApp loads login screen', (WidgetTester tester) async {
    // Build the Grievance app
    await tester.pumpWidget(GrievanceApp());

    // Verify Login screen shows up
    expect(find.text('Login'), findsOneWidget);

    // Verify the demo account instructions are visible
    expect(find.textContaining('Demo Admin'), findsOneWidget);
    expect(find.textContaining('Demo User'), findsOneWidget);
  });
}

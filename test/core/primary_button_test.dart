import 'package:ev_lookup/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final haptics = <String?>[];

  setUp(() {
    haptics.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      if (call.method == 'HapticFeedback.vibrate') {
        haptics.add(call.arguments as String?);
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Widget app({VoidCallback? onPressed}) => MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Go', onPressed: onPressed),
        ),
      );

  testWidgets('an enabled button gives light haptic feedback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(app(onPressed: () => taps++));

    await tester.tap(find.text('Go'));

    expect(taps, 1);
    expect(haptics, ['HapticFeedbackType.lightImpact']);
  });

  testWidgets('a disabled button gives no haptic feedback', (tester) async {
    await tester.pumpWidget(app());

    await tester.tap(find.text('Go'));

    expect(haptics, isEmpty);
  });
}

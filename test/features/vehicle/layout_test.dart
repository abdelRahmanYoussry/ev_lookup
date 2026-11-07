import 'package:ev_lookup/core/widgets/app_back_button.dart';
import 'package:ev_lookup/features/vehicle/domain/entities/vehicle.dart';
import 'package:ev_lookup/features/vehicle/presentation/screens/confirmation_screen.dart';
import 'package:ev_lookup/features/vehicle/presentation/widgets/plate_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void phoneSize(WidgetTester tester) {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('back button sits at the gutter and clears the title', (
    tester,
  ) async {
    phoneSize(tester);
    await tester.pumpWidget(
      MaterialApp(
        // The test font is one em wide per glyph, so a smaller title keeps
        // its width close to the real font.
        theme: ThemeData(
          textTheme: const TextTheme(
            titleMedium: TextStyle(fontSize: 8),
            titleLarge: TextStyle(fontWeight: FontWeight.w300),
          ),
        ),
        home: const ConfirmationScreen(
          vehicle: Vehicle(
            id: 'ev-1',
            make: 'Audi',
            model: 'Q8 e-tron 55 quattro',
            year: 2024,
            batteryKwh: 106,
            connector: 'CCS',
          ),
          registration: 'TF24LPO',
        ),
      ),
    );

    final back = tester.getRect(find.byType(AppBackButton));
    final title = tester.getRect(find.text('Is this your car?'));

    expect(back.left, 16);
    expect(back.right, lessThan(title.left));
    expect(title.center.dx, closeTo(180, 0.5));
    // The weight must come from the theme, not from a widget override.
    expect(
      tester
          .widget<Text>(find.text('Audi Q8 e-tron 55 quattro'))
          .style
          ?.fontWeight,
      FontWeight.w300,
    );
  });

  testWidgets('plate input keeps long text on one line and centred', (
    tester,
  ) async {
    phoneSize(tester);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlateInput(controller: controller, onSubmitted: (_) {}),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField),
      'TF24 LPO TF24 LPO TF24 LPO',
    );
    await tester.pump();

    final plate = tester.getRect(find.byType(PlateInput));
    final field = tester.getRect(find.byType(TextField));
    expect(tester.takeException(), isNull);
    expect(controller.text, 'TF24 LPO T');
    expect(plate.height, 68);
    expect(field.center.dy, closeTo(plate.center.dy, 0.5));
  });
}

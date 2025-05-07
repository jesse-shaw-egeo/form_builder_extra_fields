import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_builder_extra_fields/src/fields/form_builder_searchable_multiselect_dropdown.dart';

import 'form_builder_tester.dart';

void main() {
  const options = ['One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven'];
  const List<String> initialTextValues = ['One', 'Two'];
  const newTextValue = 'Three';
  const textFieldName = 'dropdown';
  final testWidgetKey = GlobalKey<FormBuilderFieldState>();
  List<String>? result;

  setUp(() => result = null);

  testWidgets('FormBuilderSearchableDropdown', (WidgetTester tester) async {
    final testWidget = FormBuilderSearchableMultiSelectDropdown<String>(
      key: testWidgetKey,
      name: textFieldName,
      initialValue: initialTextValues,
      items: options,
      dropdownBuilder: _customMultiSelectDropDown,
      onChanged: (query) => result = query,
    );

    await tester.pumpWidget(buildTestableFieldWidget(testWidget));

    expect(result, isNull);
    expect(formSave(), isTrue);
    expect(formFieldValue(textFieldName), initialTextValues);

    // check programmatic change
    // change the selection to the last option, this tests the on changed function
    testWidgetKey.currentState?.didChange([options.last]);
    // expect that we have one selection and that it is the last option
    expect(result?.length, equals(1));
    expect(result?.contains(options.last), true);

    // check manual change
    // Expect that the list of values is not being displayed
    final itemToSelect = find.text(newTextValue);
    expect(itemToSelect, findsNothing);

    // open the list of options
    var dropdownFinder = find.byKey(testWidgetKey);

    await tester.tap(dropdownFinder);
    await tester.pumpAndSettle();

    // expect the new item to be in the list
    expect(itemToSelect, findsOne);

    final listFinder = find.byType(Scrollable).last;
    expect(listFinder, findsOne);

    for (final initialTextValue in initialTextValues) {
      // find our initial items in the list and reselect them
      final initialItem = find.text(initialTextValue);

      await tester.scrollUntilVisible(initialItem, 500, scrollable: listFinder);
      expect(initialItem, findsOne);

      await tester.tap(initialItem);
      await tester.pumpAndSettle();
    }

    // select the new item
    await tester.tap(itemToSelect);
    await tester.pumpAndSettle();

    // press the ok button
    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    expect(formSave(), isTrue);
    expect(formFieldValue(textFieldName), equals([...initialTextValues, newTextValue]));

    testWidgetKey.currentState!.didChange(null);
    expect(formSave(), isTrue);
    expect(formFieldValue(textFieldName), isNull);
    expect(result, isNull);
  });
}

Widget _customMultiSelectDropDown(BuildContext context, List<String>? selectedItems) {
  if (selectedItems == null || selectedItems.isEmpty) {
    return const ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(),
      title: Text("No item selected"),
    );
  }

  return Wrap(
    children: selectedItems.map((e) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(e),
          ),
        ),
      );
    }).toList(),
  );
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Field for selecting value(s) from a searchable list
class FormBuilderSearchableMultiSelectDropdown<T> extends FormBuilderFieldDecoration<List<T>> {
  ///offline items list
  final List<T> items;

  ///selected item
  final T? selectedItem;

  ///selected items
  final List<T> selectedItems;

  ///called when a new items are selected
  //final ValueChanged<List<T>>? onChangedMultiSelection;

  ///to customize list of items UI
  final DropdownSearchBuilder<List<T>>? dropdownBuilder;

  ///to customize list of items UI in MultiSelection mode
  //final DropdownSearchBuilderMultiSelection<T>? dropdownBuilderMultiSelection;

  ///customize the fields the be shown
  final DropdownSearchItemAsString<T>? itemAsString;

  ///	custom filter function
  final DropdownSearchFilterFn<T>? filterFn;

  ///function that compares two object with the same type to detected if it's the selected item or not
  final DropdownSearchCompareFn<T>? compareFn;

  ///dropdownSearch input decoration
  final InputDecoration? dropdownSearchDecoration;

  /// style on which to base the label
  // final TextStyle? dropdownSearchBaseStyle;

  /// How the text in the decoration should be aligned horizontally.
  final TextAlign? dropdownSearchTextAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? dropdownSearchTextAlignVertical;

  final AutovalidateMode? autoValidateMode;

  /// An optional method to call with the final value when the form is saved via
  //final FormFieldSetter<List<T>>? onSavedMultiSelection;

  /// callback executed before applying value change
  final BeforeChange<List<T>>? onBeforeChange;

  /// callback executed before applying values changes
  //final BeforeChangeMultiSelection<T>? onBeforeChangeMultiSelection;

  ///define whatever we are in multi selection mode or single selection mode
  //final bool isMultiSelectionMode;

  ///called when a new item added on Multi selection mode
  final OnItemAdded<T>? popupOnItemAdded;

  ///called when a new item added on Multi selection mode
  final OnItemRemoved<T>? popupOnItemRemoved;

  ///widget used to show checked items in multiSelection mode
  final DropdownSearchPopupItemBuilder<T>? popupSelectionWidget;

  ///widget used to validate items in multiSelection mode
  final ValidationMultiSelectionBuilder<T?>? popupValidationMultiSelectionWidget;

  ///widget to add custom widget like addAll/removeAll on popup multi selection mode
  final ValidationMultiSelectionBuilder<T>? popupCustomMultiSelectionWidget;

  //final FormFieldValidator<List<T>>? validatorMultiSelection;

  ///function that returns item from API
  final DropdownSearchOnFind<T>? asyncItems;

  //
  final PopupPropsMultiSelection<T> popupProps;

  ///custom dropdown clear button icon properties
  final ClearButtonProps? clearButtonProps;

  /// style on which to base the label
  final TextStyle? dropdownSearchTextStyle;

  ///custom dropdown icon button properties
  final DropdownButtonProps? dropdownButtonProps;

  // Creates field for selecting value(s) from a searchable list
  FormBuilderSearchableMultiSelectDropdown({
    super.key,
    super.autovalidateMode,
    super.enabled,
    super.focusNode,
    super.onSaved,
    super.validator,
    super.decoration,
    required super.name,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.onReset,
    this.asyncItems,
    this.autoValidateMode,
    this.compareFn,
    this.dropdownSearchDecoration,
    this.dropdownSearchTextAlign,
    this.dropdownSearchTextAlignVertical,
    this.filterFn,
    this.itemAsString,
    this.items = const [],
    this.onBeforeChange,
    this.popupOnItemAdded,
    this.popupOnItemRemoved,
    this.popupSelectionWidget,
    this.selectedItems = const [],
    this.popupProps = const PopupPropsMultiSelection.menu(
      showSearchBox: true,
      fit: FlexFit.loose,
    ),
    this.clearButtonProps,
    this.dropdownSearchTextStyle,
    this.dropdownButtonProps,
    this.dropdownBuilder,
    this.selectedItem,
  })  : assert(T == String || compareFn != null),
        // onChangedMultiSelection = onChanged,
        // onSavedMultiSelection = onSaved,
        // onBeforeChangeMultiSelection = onBeforeChange,
        // validatorMultiSelection = validator,
        // dropdownBuilderMultiSelection = dropdownBuilder,
        // isMultiSelectionMode = true,
        // dropdownBuilder = null,
        // onBeforeChange = null,
        // selectedItem = null,
        // dropdownBuilder = null, // is in the super class
        // validator = null, // is in the super class
        // onSaved = null, // is in the super class
        // onChanged = null, // is in the super class
        // onBeforePopupOpening = null, // is in the super class
        popupCustomMultiSelectionWidget = null,
        popupValidationMultiSelectionWidget = null,
        super(
          builder: (field) {
            final state = field as FormBuilderSearchableMultiSelectDropdownState<T>;
            return DropdownSearch<T>.multiSelection(
              autoValidateMode: autoValidateMode,
              items: (filter, infiniteScrollProps) => asyncItems == null ? items : asyncItems(filter, infiniteScrollProps),
              decoratorProps: DropDownDecoratorProps(
                decoration: state.decoration,
                textAlign: dropdownSearchTextAlign,
                textAlignVertical: dropdownSearchTextAlignVertical,
                baseStyle: dropdownSearchTextStyle,
              ),
              suffixProps: DropdownSuffixProps(
                clearButtonProps: clearButtonProps ?? const ClearButtonProps(),
                dropdownButtonProps: dropdownButtonProps ?? const DropdownButtonProps(),
              ),
              enabled: state.enabled,
              filterFn: filterFn,
              itemAsString: itemAsString,
              compareFn: compareFn,
              popupProps: popupProps,
              onSaved: onSaved,
              onBeforeChange: onBeforeChange,
              onChanged: (value) {
                state.didChange(value);
              },
              dropdownBuilder: dropdownBuilder,
              selectedItems: state.value ?? [],
            );
          },
        );

  @override
  FormBuilderFieldDecorationState<FormBuilderSearchableMultiSelectDropdown<T>, List<T>> createState() => FormBuilderSearchableMultiSelectDropdownState<T>();
}

class FormBuilderSearchableMultiSelectDropdownState<T> extends FormBuilderFieldDecorationState<FormBuilderSearchableMultiSelectDropdown<T>, List<T>> {}

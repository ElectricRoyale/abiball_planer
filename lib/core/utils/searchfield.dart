library autocomplete_textfield;

import 'package:abiball_planer/core/managment/managerProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Widget AutoCompleteOverlayItemBuilder<T>(
    BuildContext context, T suggestion, bool selected, bool last);

typedef bool Filter<T>(T suggestion, String query);

typedef InputEventCallback<T>(T data);

typedef StringCallback(String data);

class AutoCompleteTextField<T> extends StatefulWidget {
  final List<T> suggestions;
  final Filter<T>? itemFilter;
  final Comparator<T>? itemSorter;
  final StringCallback? textChanged, textSubmitted;
  final ValueSetter<bool>? onFocusChanged;
  final InputEventCallback<T>? itemSubmitted;
  final AutoCompleteOverlayItemBuilder<T>? itemBuilder;
  final int suggestionsAmount;
  final GlobalKey<AutoCompleteTextFieldState<T>> textFieldKey =
      GlobalKey<AutoCompleteTextFieldState<T>>();
  final bool submitOnSuggestionTap, clearOnSubmit, unFocusOnItemSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int minLength;
  final InputDecoration decoration;
  final TextStyle? style;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextEditingController? controller;
  final Color? cursorColor;
  final double? cursorWidth;
  final Radius? cursorRadius;
  final bool? showCursor;
  final bool autofocus;
  final bool autocorrect;
  final FocusNode? focusNode;

  AutoCompleteTextField(
      {super.key,
      required this.itemSubmitted, //Callback on item selected, this is the item selected of type <T>//GlobalKey used to enable addSuggestion etc
      required this.suggestions, //widget.suggestions that will be displayed
      required this.itemBuilder, //Callback to build each item, return a Widget
      required this.itemSorter, //Callback to sort items in the form (a of type <T>, b of type <T>)
      required this.itemFilter, //Callback to filter item: return true or false depending on input text
      this.inputFormatters,
      this.focusNode,
      this.style,
      this.decoration = const InputDecoration(),
      this.textChanged, //Callback on input text changed, this is a string
      this.textSubmitted, //Callback on input text submitted, this is also a string
      this.onFocusChanged,
      this.cursorRadius,
      this.cursorWidth,
      this.cursorColor,
      this.showCursor,
      this.keyboardType = TextInputType.text,
      this.suggestionsAmount =
          5, //The amount of widget.suggestions to show, larger values may result in them going off screen
      this.submitOnSuggestionTap =
          true, //Call textSubmitted on suggestion tap, itemSubmitted will be called no matter what
      this.clearOnSubmit = true, //Clear autoCompleteTextfield on submit
      this.textInputAction = TextInputAction.done,
      this.textCapitalization = TextCapitalization.sentences,
      this.autocorrect =
          false, //set the autoroccection on the internal text input field
      this.minLength = 1,
      this.controller,
      this.autofocus = false,
      this.unFocusOnItemSubmitted = true});

  void clear() => textFieldKey.currentState!.clear();

  void addSuggestion(T suggestion) =>
      textFieldKey.currentState!.addSuggestion(suggestion);

  void removeSuggestion(T suggestion) =>
      textFieldKey.currentState!.removeSuggestion(suggestion);

  void updateSuggestions(List<T> suggestions) =>
      textFieldKey.currentState!.updateSuggestions(suggestions);

  void triggerSubmitted({submittedText}) =>
      textFieldKey.currentState!.triggerSubmitted(submittedText: submittedText);

  @override
  State<StatefulWidget> createState() => AutoCompleteTextFieldState<T>(
      suggestions,
      textChanged,
      textSubmitted,
      focusNode,
      onFocusChanged,
      itemSubmitted,
      itemBuilder,
      itemSorter,
      itemFilter,
      suggestionsAmount,
      submitOnSuggestionTap,
      clearOnSubmit,
      minLength,
      inputFormatters,
      textCapitalization,
      decoration,
      style,
      keyboardType,
      textInputAction,
      controller,
      cursorColor,
      cursorRadius,
      cursorWidth,
      showCursor,
      autofocus,
      unFocusOnItemSubmitted,
      autocorrect);
}

class AutoCompleteTextFieldState<T> extends State<AutoCompleteTextField> {
  final LayerLink _layerLink = LayerLink();

  List<T> suggestions;
  StringCallback? textChanged, textSubmitted;
  ValueSetter<bool>? onFocusChanged;
  InputEventCallback<T>? itemSubmitted;
  AutoCompleteOverlayItemBuilder<T>? itemBuilder;
  Comparator<T>? itemSorter;
  OverlayEntry? listSuggestionsEntry;
  List<T>? filteredSuggestions;
  Filter<T>? itemFilter;
  int suggestionsAmount;
  int minLength;
  bool submitOnSuggestionTap, clearOnSubmit, unFocusOnItemSubmitted;
  TextEditingController? controller;
  bool autofocus, showSuffix = false;
  FocusNode? focusNode;

  int selectedPosition = -1;
  Color? cursorColor;
  double? cursorWidth;
  Radius? cursorRadius;
  bool? showCursor;
  InputDecoration decoration;
  List<TextInputFormatter>? inputFormatters;
  TextCapitalization textCapitalization;
  TextStyle? style;
  TextInputType keyboardType;
  TextInputAction textInputAction;
  bool autocorrect;
  String currentText = "";

  AutoCompleteTextFieldState(
      this.suggestions,
      this.textChanged,
      this.textSubmitted,
      this.focusNode,
      this.onFocusChanged,
      this.itemSubmitted,
      this.itemBuilder,
      this.itemSorter,
      this.itemFilter,
      this.suggestionsAmount,
      this.submitOnSuggestionTap,
      this.clearOnSubmit,
      this.minLength,
      this.inputFormatters,
      this.textCapitalization,
      this.decoration,
      this.style,
      this.keyboardType,
      this.textInputAction,
      this.controller,
      this.cursorColor,
      this.cursorRadius,
      this.cursorWidth,
      this.showCursor,
      this.autofocus,
      this.unFocusOnItemSubmitted,
      this.autocorrect);

  void triggerSubmitted({submittedText}) {
    currentText = submittedText;
    selectedPosition = -1;

    updateOverlay(submittedText);

    listSuggestionsEntry!.remove();
    listSuggestionsEntry!.dispose();
    listSuggestionsEntry = null;

    controller!.text = submittedText ?? currentText;
    textSubmitted!(submittedText ?? currentText);

    if (unFocusOnItemSubmitted) {
      focusNode!.unfocus();
    }

    if (clearOnSubmit) {
      clear();
    }
  }

  void clear() {
    controller!.clear();
    currentText = "";
    updateOverlay();
    ManagerProvider.of(context).search(null);
    focusNode!.unfocus();
  }

  void addSuggestion(T suggestion) {
    suggestions.add(suggestion);
    updateOverlay(currentText);
  }

  void removeSuggestion(T suggestion) {
    suggestions.contains(suggestion)
        ? suggestions.remove(suggestion)
        : throw "List does not contain suggestion and therefore cannot be removed";
    updateOverlay(currentText);
  }

  void updateSuggestions(List<T> suggestions) {
    this.suggestions = suggestions;
    updateOverlay(currentText);
  }

  void updateOverlay([String? query]) {
    if (listSuggestionsEntry == null && filteredSuggestions != null) {
      final Size textFieldSize = (context.findRenderObject() as RenderBox).size;
      final width = textFieldSize.width;
      final height = textFieldSize.height;
      listSuggestionsEntry = OverlayEntry(builder: (context) {
        return Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, height),
            child: SizedBox(
              width: width,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: filteredSuggestions!.map((suggestion) {
                    bool selected = controller != null
                        ? filteredSuggestions!
                                .where((document) => document
                                    .toString()
                                    .toLowerCase()
                                    .contains(controller!.text.toLowerCase()))
                                .toList()
                                .indexOf(suggestion) ==
                            selectedPosition
                        : false;
                    return Row(children: [
                      Expanded(
                          child: InkWell(
                              child: itemBuilder!(
                                  context,
                                  suggestion,
                                  selected,
                                  filteredSuggestions!.indexOf(suggestion) ==
                                      filteredSuggestions!.length - 1),
                              onHover: (hovered) {
                                if (hovered) {
                                  selectedPosition =
                                      filteredSuggestions!.indexOf(suggestion);
                                  selected = filteredSuggestions!
                                          .where((document) => document
                                              .toString()
                                              .toLowerCase()
                                              .contains(controller!.text
                                                  .toLowerCase()))
                                          .toList()
                                          .indexOf(suggestion) ==
                                      selectedPosition;
                                  updateOverlay(currentText);
                                } else {
                                  selectedPosition = -1;
                                  selected = false;
                                  updateOverlay(currentText);
                                }
                              },
                              onTap: () {
                                if (!mounted) return;
                                setState(() {
                                  if (submitOnSuggestionTap) {
                                    String newText = suggestion.toString();
                                    controller!.text = newText;
                                    itemSubmitted!(suggestion);
                                    if (clearOnSubmit) {
                                      clear();
                                    }
                                  } else {
                                    String newText = suggestion.toString();
                                    controller!.text = newText;
                                    textChanged!(newText);
                                  }
                                  selectedPosition = -1;

                                  currentText = suggestion.toString();

                                  updateOverlay(suggestion.toString());

                                  listSuggestionsEntry!.remove();
                                  listSuggestionsEntry!.dispose();
                                  listSuggestionsEntry = null;
                                });
                              }))
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(listSuggestionsEntry!);
    }

    filteredSuggestions = getSuggestions(
        suggestions, itemSorter, itemFilter, suggestionsAmount, query);

    if (filteredSuggestions != null && filteredSuggestions!.isEmpty) {
      selectedPosition = -1;
    } else if (filteredSuggestions != null &&
        selectedPosition > filteredSuggestions!.length - 1) {
      selectedPosition = filteredSuggestions!.length - 1;
    }

    listSuggestionsEntry?.markNeedsBuild();
  }

  List<T> getSuggestions(List<T> suggestions, Comparator<T>? sorter,
      Filter<T>? filter, int maxAmount, String? query) {
    if (null == query || query.length < minLength) {
      return [];
    }

    suggestions = suggestions.where((item) => filter!(item, query)).toList();
    suggestions.sort(sorter);
    if (suggestions.length > maxAmount) {
      suggestions = suggestions.sublist(0, maxAmount);
    }
    return suggestions;
  }

  @override
  void dispose() {
    // if we created our own focus node and controller, dispose of them
    // otherwise, let the caller dispose of their own instances
    if (controller == null) {
      controller!.dispose();
    }
    super.dispose();
  }

  void suggestionIncrease() {
    setState(() {
      if (filteredSuggestions != null &&
          selectedPosition < filteredSuggestions!.length - 1) {
        selectedPosition++;
      }
    });
    updateOverlay(currentText);
  }

  void suggestionDecrease() {
    setState(() {
      if (selectedPosition > -1) selectedPosition--;
    });
    updateOverlay(currentText);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode ?? (focusNode = FocusNode()),
      onFocusChange: (hasFocus) {
        if (hasFocus && listSuggestionsEntry != null) {
          listSuggestionsEntry!.remove();
          listSuggestionsEntry!.dispose();
          listSuggestionsEntry = null;
        }
        if (onFocusChanged != null) {
          onFocusChanged!.call(hasFocus);
        }
      },
      child: Builder(
        builder: (context) => CompositedTransformTarget(
            link: _layerLink,
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowUp): () =>
                    suggestionDecrease(),
                const SingleActivator(LogicalKeyboardKey.arrowDown): () =>
                    suggestionIncrease(),
                const SingleActivator(LogicalKeyboardKey.escape): () =>
                    Focus.of(context).unfocus(),
              },
              child: TextField(
                inputFormatters: inputFormatters,
                textCapitalization: textCapitalization,
                decoration: decoration.copyWith(
                  suffixIcon: ExcludeFocusTraversal(
                    child: Visibility(
                      visible: showSuffix,
                      child: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 16,
                        ),
                        onPressed: () {
                          clear();
                          showSuffix = false;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ),
                style: style,
                cursorColor: cursorColor ?? Colors.black,
                showCursor: showCursor ?? true,
                cursorWidth: cursorWidth ?? 1,
                cursorRadius: cursorRadius ?? const Radius.circular(2.0),
                keyboardType: keyboardType,
                autofocus: autofocus,
                controller:
                    controller ?? (controller = TextEditingController()),
                textInputAction: textInputAction,
                autocorrect: autocorrect,
                onChanged: (newText) {
                  currentText = newText;
                  showSuffix = newText.isNotEmpty;
                  setState(() {});
                  updateOverlay(newText);

                  if (textChanged != null) {
                    textChanged!(newText);
                  }
                },
                onTap: () {
                  updateOverlay(currentText);
                },
                onSubmitted: (submittedText) => triggerSubmitted(
                    submittedText: selectedPosition == -1
                        ? submittedText
                        : filteredSuggestions!
                            .elementAt(selectedPosition)
                            .toString()),
              ),
            )),
      ),
    );
  }
}

import 'package:division/division.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/forms/widgets.dart';

import 'forms_bloc.dart';
import 'forms_event.dart';

class AppFormTextField extends StatefulWidget {
  final List<Validator> validators;
  final StringFormValue Function() initValue;
  final String fieldName;
  final TextEditingController controller;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextDirection textDirection;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final int maxLines;
  final int minLines;
  final bool expands;
  final bool readOnly;
  final ToolbarOptions toolbarOptions;
  final bool showCursor;
  final int maxLength;
  final bool maxLengthEnforced;
  final ValueChanged<String> onChanged;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onSubmitted;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final DragStartBehavior dragStartBehavior;

  final GestureTapCallback onTap;
  final InputCounterWidgetBuilder buildCounter;
  final ScrollPhysics scrollPhysics;
  final ScrollController scrollController;
  final FocusNode focusNode;

  const AppFormTextField({
    Key key,
    this.validators = const [],
    this.initValue,
    @required this.fieldName,
    this.controller,
    this.decoration = const InputDecoration(),
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.keyboardType,
    this.toolbarOptions,
    this.focusNode
  })  : assert(validators != null),
        assert(initValue != null),
        assert(fieldName != null),
        super(key: key);

  @override
  _AppFormTextFieldState createState() => _AppFormTextFieldState();
}

class _AppFormTextFieldState extends State<AppFormTextField> {
  bool get selectionEnabled => widget.enableInteractiveSelection;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller != null ? widget.controller : TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormField<String>(
      fieldName: widget.fieldName,
      initValue:
          widget.initValue == null ? () => StringFormValue() : widget.initValue,
      validators: widget.validators,
      builder: (context, state) {
        if (_controller.text != state.value.data) {
          _controller.text = state.value.data;
        }

        return TextField(
          
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          textInputAction: widget.textInputAction,
          style: widget.style,
          strutStyle: widget.strutStyle,
          textDirection: widget.textDirection,
          textAlign: widget.textAlign,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          toolbarOptions: widget.toolbarOptions,
          showCursor: widget.showCursor,
          obscureText: widget.obscureText,
          autocorrect: widget.autocorrect,
          maxLengthEnforced: widget.maxLengthEnforced,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          expands: widget.expands,
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          onEditingComplete: widget.onEditingComplete,
          inputFormatters: widget.inputFormatters,
          enabled: widget.enabled,
          cursorWidth: widget.cursorWidth,
          cursorRadius: widget.cursorRadius,
          cursorColor: widget.cursorColor,
          keyboardAppearance: widget.keyboardAppearance,
          scrollPadding: widget.scrollPadding,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          buildCounter: widget.buildCounter,
          textAlignVertical: widget.textAlignVertical,
          onSubmitted: widget.onSubmitted,
          dragStartBehavior: widget.dragStartBehavior,
          scrollPhysics: widget.scrollPhysics,
          scrollController: widget.scrollController,
          // controller: _controller,
          focusNode: state.focusNode,
          onChanged: (text) {
            BlocProvider.of<FormsBloc>(context).add(
              OnUpdateValue<String>(
                widget.fieldName,
                StringFormValue(text),
              ),
            );
            widget.onChanged(text);
          },
          decoration: widget.decoration.copyWith(
            errorText: state.errorMessage
                .map((it) => it.localize(context))
                .orElse(null),
          ),
        );
      },
    );
  }
}

class DivisionAppFormTextField extends StatefulWidget {
  final TextInputType keyboardType;
  final String placeholder;
  final bool obscureText;
  final int maxLines;
  final void Function(String) onChange;
  final void Function(bool focus) onFocusChange;
  final void Function(TextSelection, SelectionChangedCause) onSelectionChanged;
  final void Function() onEditingComplete;
  final List<Validator> validators;
  final StringFormValue Function() initValue;
  final String fieldName;
  final GestureClass gesture;
  final bool autoFocus;

  final TxtStyle style;
  final TxtStyle focusedStyle;
  final TxtStyle errorStyle;
  final TxtStyle errorFocusedStyle;
  final TxtStyle errorTextStyle;
  final TxtStyle errorNotPresentedTextStyle;

  const DivisionAppFormTextField({
    Key key,
    this.validators = const [],
    this.initValue,
    @required this.fieldName,
    this.keyboardType,
    this.placeholder,
    this.maxLines,
    this.onChange,
    this.onFocusChange,
    this.onSelectionChanged,
    this.onEditingComplete,
    @required this.style,
    this.focusedStyle,
    this.errorStyle,
    this.errorTextStyle,
    this.errorFocusedStyle,
    this.errorNotPresentedTextStyle,
    this.gesture,
    this.obscureText = false,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  _DivisionAppFormTextFieldState createState() =>
      _DivisionAppFormTextFieldState();
}

class _DivisionAppFormTextFieldState extends State<DivisionAppFormTextField> {
  String _text;
  bool _isFocused = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return AppFormField<String>(
      fieldName: widget.fieldName,
      initValue:
          widget.initValue == null ? () => StringFormValue() : widget.initValue,
      validators: widget.validators,
      builder: (context, state) {
        _hasError = state.errorMessage.isPresent;

        if (_text == null) {
          _text = state.value.data;
        }

        if (state.errorMessage.isPresent) {
          _errorMessage = state.errorMessage.value.localize(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                state.focusNode.requestFocus();
              },
              child: Txt(
                _text,
                style: _getStyle()
                  ..editable(
                    state.isEnabled,
//                    autoFocus: widget.autoFocus,
                    onChange: (text) {
                      if (widget.onFocusChange != null) {
                        widget?.onChange(text);
                      }

                      BlocProvider.of<FormsBloc>(context).add(
                        OnUpdateValue<String>(
                          widget.fieldName,
                          StringFormValue(text),
                        ),
                      );
                    },
                    onFocusChange: (hasFocus) {
                      if (hasFocus != _isFocused) {
                        setState(() => _isFocused = hasFocus);
                      }

                      if (widget.onFocusChange != null) {
                        widget.onFocusChange(hasFocus);
                      }
                    },
                    keyboardType: widget.keyboardType,
                    placeholder: widget.placeholder,
                    obscureText: widget.obscureText,
                    maxLines: widget.maxLines,
                    onSelectionChanged: widget.onSelectionChanged,
                    onEditingComplete: widget.onEditingComplete,
                    focusNode: state.focusNode,
                  ),
              ),
            ),
            GestureDetector(
              onTap: () {
                state.focusNode.requestFocus();
              },
              child: Txt(
                _errorMessage,
                style: _hasError
                    ? widget.errorTextStyle
                    : widget.errorNotPresentedTextStyle ?? _hide(),
              ),
            ),
          ],
        );
      },
    );
  }

  TxtStyle _hide() => (widget.errorTextStyle ?? TxtStyle())..opacity(0);

  TxtStyle _getStyle() {
    if (_hasError && _isFocused) {
      return widget.errorFocusedStyle ?? widget.errorStyle ?? widget.style;
    } else if (_hasError && !_isFocused) {
      return widget.errorStyle ?? widget.style;
    } else if (!_hasError && _isFocused) {
      return widget.focusedStyle ?? widget.style;
    } else {
      return widget.style;
    }
  }
}

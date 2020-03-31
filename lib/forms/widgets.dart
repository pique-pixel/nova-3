import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/validators.dart';

import 'bloc.dart';

class AppForm extends StatelessWidget {
  final bool validateOnUpdate;
  final bool validateOnFocusChange;
  final Duration onUpdateDebounceDuration;
  final Widget Function(BuildContext, FormsState) builder;
  final OnFormSubmitCallback onSubmit;

  const AppForm({
    Key key,
    this.builder,
    this.validateOnUpdate = false,
    this.validateOnFocusChange = true,
    this.onUpdateDebounceDuration = const Duration(microseconds: 300),
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormsBloc>(
      create: (context) => FormsBloc(
        validateOnUpdate: validateOnUpdate,
        validateOnFocusChange: validateOnFocusChange,
        onUpdateDebounceDuration: onUpdateDebounceDuration,
        onSubmit: onSubmit,
      ),
      child: BlocBuilder<FormsBloc, FormsState>(builder: builder),
    );
  }
}

class AppFormField<T> extends StatefulWidget {
  final Widget Function(BuildContext, AppFormFieldState) builder;
  final List<Validator> validators;
  final FormValue<T> Function() initValue;
  final String fieldName;

  const AppFormField({
    Key key,
    @required this.builder,
    this.validators = const [],
    this.initValue,
    this.fieldName,
  })  : assert(builder != null),
        assert(validators != null),
        assert(initValue != null),
        assert(fieldName != null),
        super(key: key);

  @override
  _AppFormFieldState createState() => _AppFormFieldState<T>();
}

class _AppFormFieldState<T> extends State<AppFormField> {
  FormValue<T> _value;
  FormsBloc _bloc;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    _value = widget.initValue();
    debugPrint('VALUE: $_value');
    _bloc = BlocProvider.of<FormsBloc>(context);
    _bloc.add(OnAddInput(widget.fieldName, _value, widget.validators));

    WidgetsBinding.instance.addPostFrameCallback((_) => _updateInputOffset());
  }

  _updateInputOffset() {
    final RenderBox renderBoxRed = _key.currentContext.findRenderObject();
    final position = renderBoxRed.localToGlobal(Offset.zero);

    _bloc.add(OnUpdateInputOffset(widget.fieldName, position));
  }

  @override
  void dispose() {
    if (_bloc != null) {
      _bloc.add(OnRemoveInput(
        fieldName: widget.fieldName,
        saveState: true,
      ));
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormsBloc, FormsState>(
      key: _key,
      builder: (context, state) {
        if (state.fieldStates.containsKey(widget.fieldName)) {
          return widget.builder(context, state.fieldStates[widget.fieldName]);
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}

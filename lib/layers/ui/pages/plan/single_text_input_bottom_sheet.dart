import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/forms/bloc.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/forms/fields.dart';
import 'package:rp_mobile/forms/forms_event.dart';
import 'package:rp_mobile/forms/validators.dart';
import 'package:rp_mobile/forms/widgets.dart';
import 'package:rp_mobile/layers/ui/fonts.dart';
import 'package:rp_mobile/layers/ui/widgets/base/divider.dart';
import 'package:rp_mobile/layers/ui/widgets/base/loading_indicator.dart';

abstract class SingleTextInputBottomSheetContent<B extends Bloc<dynamic, S>, S> extends StatefulWidget {
  const SingleTextInputBottomSheetContent({Key key}) : super(key: key);

  bool isLoadingState(S state);

  bool isFinishState(S state);

  String title(BuildContext context);

  B bloc(BuildContext context);

  void onSubmit(BuildContext context, String value);

  @override
  _SingleTextInputBottomSheetContentState createState() => _SingleTextInputBottomSheetContentState<B, S>();
}

class _SingleTextInputBottomSheetContentState<B extends Bloc<dynamic, S>, S> extends State<SingleTextInputBottomSheetContent<B, S>> {
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.bloc(context).listen((state) {
      if (context == null) {
        return;
      }

      if (widget.isFinishState(state)) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      onSubmit: (data) {
        final name = (data['name'] as StringFormValue)?.data ?? '';
        widget.onSubmit(context, name);
      },
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.title(context),
              style: TextStyle(
                color: Color(0xFF262626),
                fontSize: 16,
                fontWeight: NamedFontWeight.medium,
              ),
            ),
          ),
          SimpleDivider(color: Color(0xFFE4E4E4)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _BottomSheetTextInput(),
          ),
          SizedBox(height: 38),
          SizedBox(
            height: 54,
            width: double.infinity,
            child: Material(
              color: Color(0xFFF7464E),
              child: BlocBuilder<B, S>(
                builder: (context, state) {
                  if (widget.isLoadingState(state)) {
                    return _ButtonProgressIndicator();
                  } else {
                    return _BottomSheetCreatePlanButton();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingIndicator(
        radius: 10,
        tickWidth: 2,
        lengthFactor: 2.0,
      ),
    );
  }
}

class _BottomSheetCreatePlanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white24,
      highlightColor: Colors.white10,
      child: Center(
        child: Text(
          'Продолжить',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 16,
            fontWeight: NamedFontWeight.medium,
          ),
        ),
      ),
      onTap: () {
        BlocProvider.of<FormsBloc>(context).add(OnSubmit());
      },
    );
  }
}

class _BottomSheetTextInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AppFormTextField(
          fieldName: 'name',
          initValue: () => StringFormValue(''),
          validators: [RequiredValidator()],
          autofocus: true,
          keyboardType: TextInputType.text,
          onSubmitted: (value) {
            BlocProvider.of<FormsBloc>(context).add(OnSubmit());
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: _CancelButton(),
          ),
        ),
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CancelButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.0,
      width: 16.0,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          Icons.cancel,
          color: Color(0xFFB2B2B2),
          size: 16,
        ),
        onPressed: onPressed,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rp_mobile/layers/bloc/errors/bloc.dart';
import 'package:rp_mobile/layers/ui/widgets/base/app_error.dart';

class ErrorPage extends StatelessWidget {
  final Widget child;

  const ErrorPage({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ErrorsBloc, ErrorsState>(
      builder: (context, state) {
        if (state is ErrorPresentedState) {
          return AppErrorWidget(state.exception);
        } else if (state is NoErrorsState) {
          return SizedBox.shrink();
        } else {
          throw UnsupportedError('$state is not supported');
        }
      },
    );
  }
}

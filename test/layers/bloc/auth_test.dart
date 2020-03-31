import 'package:flutter_test/flutter_test.dart';
import 'package:rp_mobile/layers/bloc/auth/bloc.dart';

void main() {
  test('default initial state is correct', () async {
    final bloc = AuthBloc();
    expect(bloc.initialState, InitialAuthState());
    bloc.close();
  });

  test('route to login screen', () async {
    final bloc = AuthBloc();
    bloc.add(OnLoginButtonClick());

    await expectLater(
        bloc,
        emitsInOrder([
          InitialAuthState(),
          RouteLoginState(),
        ]),
      );

    bloc.close();
  });

  test('route to registration screen', () async {
    final bloc = AuthBloc();
    bloc.add(OnRegistrationButtonClick());

    await expectLater(
        bloc,
        emitsInOrder([
          InitialAuthState(),
          RouteRegistrationState(),
        ]),
      );

    bloc.close();
  });

  test('route to FAQ screen', () async {
    final bloc = AuthBloc();
    bloc.add(OnFAQButtonClick());

    await expectLater(
        bloc,
        emitsInOrder([
          InitialAuthState(),
          RouteFAQState(),
        ]),
      );

    bloc.close();
  });
}

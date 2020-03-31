import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:optional/optional.dart';
import 'package:rp_mobile/layers/services/auth.dart';
import 'package:rp_mobile/layers/services/session.dart';
import './bloc.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final SessionService sessionService;
  final AuthService authService;

  MenuBloc({@required this.sessionService, @required this.authService});

  @override
  MenuState get initialState {
    String imageUrl;
    String name;
    String twoLetters = 'VP';
    String id;
    Optional imageOptional = Optional.ofNullable(imageUrl);
    Optional nameOptional = Optional.ofNullable(name);
    Optional idOptional = Optional.ofNullable(id);
    Optional twoLettersOptional = Optional.ofNullable(twoLetters);
    return InitialMenuState(
      twoLetters: twoLettersOptional,
      name: nameOptional,
      id: idOptional,
      image: imageOptional,
    );
  }

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is OnUpdateMenuEvent) {
      yield* _updateProfileData();
    } else if (event is OnExitMenuEvent) {
      yield* _exitUserAccount();
    }
    if(event is OnUpdateCurrencyEvent){
      yield* _updateCurrency(event);
      yield* _updateProfileData();
    }
    if(event is OnUpdateLanguageEvent){
      yield* _updateLanguage(event);
      yield* _updateProfileData();
    }
  }

  Stream<MenuState> _updateProfileData() async* {
    String imageUrl =
        'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&h=500&q=80';
    String name = 'Vitaliy';
    String twoLetters = 'VP';
    String id = '4560987890';
    await Future.delayed(Duration(seconds: 1));
    Optional imageOptional = Optional.ofNullable(imageUrl);
    Optional nameOptional = Optional.ofNullable(name);
    Optional idOptional = Optional.ofNullable(id);
    Optional twoLettersOptional = Optional.ofNullable(twoLetters);
    yield UpdatedMenuState(
      image: imageOptional,
      id: idOptional,
      name: nameOptional,
      twoLetters: twoLettersOptional,
    );
  }

  Stream<MenuState> _exitUserAccount() async* {
    //TODO Here should be logout function
    print('TODO Here should be logout function');
  }

  Stream<MenuState> _updateCurrency(MenuEvent event)async*{
    if(event is OnUpdateCurrencyEvent)
    yield UpdateCurrencyState(event.selectedCurrency);
  }
  Stream<MenuState> _updateLanguage(MenuEvent event)async*{
    if(event is OnUpdateLanguageEvent)
    yield UpdateLanguageState(event.selectedLanguage);
  }
}

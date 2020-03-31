import 'package:equatable/equatable.dart';
import 'package:optional/optional.dart';

abstract class MenuState extends Equatable {
  const MenuState();
}

class InitialMenuState extends MenuState {
  final Optional image;
  final Optional twoLetters;
  final Optional name;
  final Optional id;

  InitialMenuState({this.image, this.twoLetters, this.name, this.id});

  @override
  List<Object> get props => [];
}

class UpdatedMenuState extends MenuState {
  final Optional image;
  final Optional twoLetters;
  final Optional name;
  final Optional id;

  UpdatedMenuState({this.twoLetters, this.image, this.name, this.id});

  @override
  List<Object> get props => [image, name, id];
}

class LoadingMenuState extends MenuState {
  @override
  List<Object> get props => [];
}

class UpdateCurrencyState extends MenuState{
  final String selectedCurrency;

  UpdateCurrencyState(this.selectedCurrency);
  @override
  List<Object> get props => [selectedCurrency];
}
class UpdateLanguageState extends MenuState{
  final String selectedLanguage;

  UpdateLanguageState(this.selectedLanguage);
  @override
  List<Object> get props => [selectedLanguage];
}
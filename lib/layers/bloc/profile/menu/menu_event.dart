import 'package:equatable/equatable.dart';
import 'package:optional/optional_internal.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();
}

class OnUpdateMenuEvent extends MenuEvent {
  @override
  List<Object> get props => null;
}

class OnExitMenuEvent extends MenuEvent {
  @override
  List<Object> get props => null;
}

class OnUpdateCurrencyEvent extends MenuEvent{
  final String selectedCurrency;

  OnUpdateCurrencyEvent(this.selectedCurrency);
  @override
  List<Object> get props => [selectedCurrency];
}
class OnUpdateLanguageEvent extends MenuEvent{
  final String selectedLanguage;

  OnUpdateLanguageEvent(this.selectedLanguage);
  @override
  List<Object> get props => [selectedLanguage];
}
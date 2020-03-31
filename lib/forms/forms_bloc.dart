import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:optional/optional_internal.dart';
import 'package:rp_mobile/forms/data.dart';
import 'package:rp_mobile/locale/localized_string.dart';
import 'package:rp_mobile/utils/collections.dart';
import 'package:rxdart/rxdart.dart';
import 'bloc.dart';

typedef OnFormSubmitCallback = Function(Map<String, FormValue>);

class FormsBloc extends Bloc<FormsEvent, FormsState> {
  final bool validateOnUpdate;
  final bool validateOnFocusChange;
  final Duration onUpdateDebounceDuration;
  final OnFormSubmitCallback onSubmit;

  FormsBloc({
    this.validateOnUpdate = true,
    this.validateOnFocusChange = true,
    this.onUpdateDebounceDuration = const Duration(milliseconds: 300),
    this.onSubmit,
  });

  @override
  Stream<FormsState> transformEvents(
    Stream<FormsEvent> events,
    Stream<FormsState> Function(FormsEvent event) next,
  ) {
    // NOTE(Andrey): Prevent events spamming
    //TODO conflict megre branch
//    final updateEvents = (events as Observable<FormsEvent>)
//        .where((event) => event is OnUpdateValue)
//        .groupBy((it) => (it as OnUpdateValue).fieldName)
//        .flatMap((it) => it.debounceTime(Duration(milliseconds: 300)))
//        .switchMap(next);
//
//    final otherEvents = (events as Observable<FormsEvent>)
//        .where((event) => event is! OnUpdateValue)
//        .asyncExpand(next);
//
//    return Observable.merge([updateEvents, otherEvents]);
    final updateEvents = (events as Stream<FormsEvent>)
        .where((event) => event is OnUpdateValue)
        .groupBy((it) => (it as OnUpdateValue).fieldName)
        .flatMap((it) => it.debounceTime(Duration(milliseconds: 300)))
        .switchMap(next);

    final otherEvents = (events as Stream<FormsEvent>)
        .where((event) => event is! OnUpdateValue)
        .asyncExpand(next);

    return Rx.merge([updateEvents, otherEvents]);
  }

  @override
  FormsState get initialState => FormsState();

  AppFormFieldState _cloneFieldState<T>(
    String fieldName, {
    FormValue<T> value,
    Optional<LocalizedString> errorMessage,
    bool isEnabled,
    Offset offset,
  }) {
//TODO conflict megre branch
    if (state.fieldStates.containsKey(fieldName)) {
      return state.fieldStates[fieldName].copyWith(
        value: value,
        errorMessage: errorMessage,
        isEnabled: isEnabled,
        offset: offset,
      );
    } else {
      return null;
    }
//    if(state.fieldStates[fieldName] == null){
//      return null;
//    }
//    return state.fieldStates[fieldName].copyWith(
//      value: value,
//      errorMessage: errorMessage,
//      isEnabled: isEnabled,
//      offset: offset,
//    );
  }

  @override
  Stream<FormsState> mapEventToState(FormsEvent event) async* {
    if (event is OnAddInput) {
      yield* _mapOnAddInput(event);
    } else if (event is OnRemoveInput) {
      //TODO conflict megre branch
      //yield* _mapOnRemoveInput(event);
    } else if (event is OnSubmit) {
      yield* _mapOnSubmit(event);
    } else if (event is OnUpdateValue) {
      yield* _mapOnUpdateValue(event);
    } else if (event is OnFieldError) {
      yield* _mapOnFieldError(event);
    } else if (event is OnFieldClearError) {
      yield* _mapOnFieldClearError(event);
    } else if (event is OnClearAllErrors) {
      yield* _mapOnClearAllErrors();
    } else if (event is OnValidateForm) {
      yield* _mapOnValidateForm();
    } else if (event is OnValidateField) {
      yield* _mapOnValidateField(event);
    } else if (event is OnUpdateInputOffset) {
      yield* _mapOnUpdateInputOffset(event);
    }
  }

  Stream<FormsState> _mapOnAddInput(OnAddInput event) async* {
    final focusNode = FocusNode();

    // focusNode.addListener(() {
    //   if (validateOnFocusChange && !focusNode.hasFocus) {
    //     this.add(
    //       OnValidateField(
    //         fieldName: event.fieldName,
    //         requestFocusOnError: false,
    //       ),
    //     );
    //   }
    // });

    yield state.copyWith(
      fieldStates: cloneMapAndAdd(
        state.fieldStates,
        event.fieldName,
        AppFormFieldState(
          value: _retrieveFieldValue(event.fieldName, event.value),
          validators: event.validators,
          focusNode: focusNode,
        ),
      ),
      removedFieldStates: cloneMapAndRemove(
        state.removedFieldStates,
        event.fieldName,
      ),
    );
  }

  FormValue _retrieveFieldValue(String fieldName, FormValue initialValue) {
    if (state.removedFieldStates.containsKey(fieldName)) {
      return state.removedFieldStates[fieldName].value;
    } else {
      return initialValue;
    }
  }

  Stream<FormsState> _mapOnRemoveInput(OnRemoveInput event) async* {
    if (event.saveState) {
      yield state.copyWith(
        fieldStates: cloneMapAndRemove(
          state.fieldStates,
          event.fieldName,
        ),
        removedFieldStates: cloneMapAndAdd(
          state.removedFieldStates,
          event.fieldName,
          state.fieldStates[event.fieldName],
        ),
      );
    } else {
      yield state.copyWith(
        fieldStates: cloneMapAndRemove(
          state.fieldStates,
          event.fieldName,
        ),
        removedFieldStates: cloneMapAndRemove(
          state.removedFieldStates,
          event.fieldName,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnSubmit(OnSubmit event) async* {
    yield* _mapOnValidateForm();

    if (_isValid()) {
      final states = state.fieldStates;
      final result = states.map((key, value) => MapEntry(key, value.value));

      if (onSubmit != null) {
        onSubmit(result);
      }
    }
  }

  bool _isValid() {
    final invalidFields =
        state.fieldStates.values.where((it) => it.errorMessage.isPresent);

    return invalidFields.length == 0;
  }

  Stream<FormsState> _mapOnValidateForm() async* {
    yield* _mapOnClearAllErrors();

    final sortedEntries = state.fieldStates.entries.toList();

    sortedEntries.sort(
      (a, b) => a.value.offset.dy.compareTo(b.value.offset.dy),
    );

    for (final entry in sortedEntries.reversed) {
      yield* _mapOnValidateField(OnValidateField(fieldName: entry.key));
    }
  }

  Stream<FormsState> _mapOnValidateField(OnValidateField event) async* {
    final fieldState = state.fieldStates[event.fieldName];

    for (final validator in fieldState.validators) {
      var isInvalid = !validator.isValid(fieldState.value);
      if (isInvalid) {
        yield* _mapOnFieldError(
          OnFieldError(
            fieldName: event.fieldName,
            error: validator.getValidationMessage(fieldState.value).value,
            requestFocus: event.requestFocusOnError,
          ),
        );
      } else {
        yield* _mapOnFieldClearError(OnFieldClearError(event.fieldName));
      }
    }
  }

  Stream<FormsState> _mapOnUpdateValue(OnUpdateValue event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      value: event.newValue,
    );

    if (fieldState == null) {
      return;
    }

    yield state.copyWith(
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );

    if (validateOnUpdate) {
      yield* _mapOnValidateField(
        OnValidateField(
          fieldName: event.fieldName,
          requestFocusOnError: false,
        ),
      );
    }
  }

  Stream<FormsState> _mapOnFieldError(OnFieldError event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      errorMessage: Optional.of(event.error),
    );

    if (fieldState == null) {
      return;
    }

    if (event.requestFocus) {
      fieldState.focusNode.requestFocus();
    }

    yield state.copyWith(
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );
  }

  Stream<FormsState> _mapOnFieldClearError(OnFieldClearError event) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      errorMessage: Optional.empty(),
    );

    if (fieldState == null) {
      return;
    }

    yield state.copyWith(
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );
  }

  Stream<FormsState> _mapOnClearAllErrors() async* {
    yield state.copyWith(
      fieldStates: state.fieldStates.map(
        (key, value) => MapEntry(
          key,
          value.copyWith(errorMessage: Optional.empty()),
        ),
      ),
    );
  }

  Stream<FormsState> _mapOnUpdateInputOffset(
    OnUpdateInputOffset event,
  ) async* {
    final fieldState = _cloneFieldState(
      event.fieldName,
      offset: event.offset,
    );

    if (fieldState == null) {
      return;
    }

    yield state.copyWith(
      fieldStates: cloneMapAndUpdate(
        state.fieldStates,
        event.fieldName,
        fieldState,
      ),
    );
  }
}

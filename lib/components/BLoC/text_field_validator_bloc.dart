import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TextFieldValidatorEvent {}

class TextFieldValidatorEventNoLength extends TextFieldValidatorEvent {}

class TextFieldValidatorEventEmpty extends TextFieldValidatorEvent {}

class TextFieldValidatorEventAreYouKidding extends TextFieldValidatorEvent {}

class TextFieldValidatorEventAlreadyUsed extends TextFieldValidatorEvent {}

class TextFieldValidatorEventCancel extends TextFieldValidatorEvent {}

class TextFieldValidatorEventNeedLetters extends TextFieldValidatorEvent {}

class TextFieldValidatorEventNeedOnlyLetters extends TextFieldValidatorEvent {}

class TextFieldValidatorBloc extends Bloc<TextFieldValidatorEvent, String?> {
  TextFieldValidatorBloc(String? initState) : super(initState) {
    on<TextFieldValidatorEventNoLength>(
        (event, emit) => emit("Need more characters"));
    on<TextFieldValidatorEventEmpty>(
        (event, emit) => emit("Must not be empty"));
    on<TextFieldValidatorEventAreYouKidding>(
        (event, emit) => emit("Are you kidding?"));
    on<TextFieldValidatorEventAlreadyUsed>(
        (event, emit) => emit("Already used"));
    on<TextFieldValidatorEventNeedLetters>(
        (event, emit) => emit("Need more letters"));
    on<TextFieldValidatorEventNeedOnlyLetters>(
        (event, emit) => emit("Need only letters"));
    on<TextFieldValidatorEventCancel>((event, emit) => emit(null));
  }
}

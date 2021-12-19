import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AvatarProps {
  const AvatarProps({this.title, this.color});
  final String? title;
  final Color? color;
}

class AvatarPropsValidatorBloc extends Bloc<AvatarProps, AvatarProps> {
  AvatarProps lastState;
  AvatarPropsValidatorBloc(AvatarProps initState)
      : lastState = initState,
        super(initState) {
    on<AvatarProps>((event, emit) {
      AvatarProps props = AvatarProps(
        title: event.title ?? lastState.title,
        color: event.color ?? lastState.color,
      );
      emit(props);
      lastState = props;
    });
  }
}

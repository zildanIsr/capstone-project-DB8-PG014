
import 'package:equatable/equatable.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';

class CommonState<T> extends Equatable {

  final T data;
  final StatusState state;
  final String? message;

  const CommonState({
    required this.data,
    this.state = StatusState.initial,
    this.message,
  });

  CommonState<T> copyWith({
    T? data,
    StatusState? state,
    String? message,
  }) {
    return CommonState<T>(
      data: data ?? this.data,
      state: state ?? this.state,
      message: message ?? this.message,
    );
  }

  @override 
  List<Object?> get props => [data, state, message];
  
}
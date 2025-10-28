enum StatusState {
  initial,
  loading,
  loaded,
  success,
  error
}

extension StatusStateExtension on StatusState {
  bool get isInitial => this == StatusState.initial;
  bool get isLoading => this == StatusState.loading;
  bool get isLoaded => this == StatusState.loaded;
  bool get isError => this == StatusState.error;
  bool get isSuccess => this == StatusState.success;
}
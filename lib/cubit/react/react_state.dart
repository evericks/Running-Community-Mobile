class ReactState<T> {
  final T data;
  final bool isLoading;
  final String error;

  ReactState({
    required this.data,
    this.isLoading = false,
    required this.error,
  });

  ReactState<T> copyWith({
    required T data,
    required bool isLoading,
    required String error,
  }) {
    return ReactState<T>(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }}
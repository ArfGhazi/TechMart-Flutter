/// Representasi hasil operasi yang hanya memiliki dua kemungkinan:
/// Success (berhasil) atau Failure (gagal).
sealed class Result<T, E> {
  const Result();
}

/// Hasil operasi berhasil dan membawa data.
final class Success<T, E> extends Result<T, E> {
  final T data;

  const Success({required this.data});
}

/// Hasil operasi gagal dan membawa informasi error.
final class Failure<T, E> extends Result<T, E> {
  final E error;

  const Failure({required this.error});
}

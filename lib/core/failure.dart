class Failure {
  final String message;

  const Failure({required this.message});

  @override
  String toString() => message;
}

class NetworkFailure extends Failure {
  const NetworkFailure({required String message}) : super(message: message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required String message}) : super(message: message);
}

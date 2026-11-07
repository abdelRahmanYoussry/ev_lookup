import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

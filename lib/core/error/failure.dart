import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class NotFoundFailure extends Failure {
  final String message;
  const NotFoundFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure();
}

class UnknownFailure extends Failure {
  const UnknownFailure();
}

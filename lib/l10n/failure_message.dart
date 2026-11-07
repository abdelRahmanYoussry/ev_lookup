import '../core/error/failure.dart';
import 'app_localizations.dart';

extension FailureMessage on AppLocalizations {
  String failureMessage(Failure failure) => switch (failure) {
    NetworkFailure() => networkError,
    NotFoundFailure() || UnknownFailure() => unknownError,
  };
}

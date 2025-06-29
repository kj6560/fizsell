part of 'scheme_bloc.dart';

@immutable
sealed class SchemeState {}

final class SchemeInitial extends SchemeState {}

class SubscriptionFailure extends SchemeState{
  final String message;
  SubscriptionFailure(this.message);
}

class LoadingSchemeList extends SchemeState {}

class LoadSchemeListSuccess extends SchemeState {
  final List<Scheme> response;

  LoadSchemeListSuccess(this.response);
}

class LoadSchemeListFailure extends SchemeState {
  final String error;

  LoadSchemeListFailure(this.error);
}

class LoadingSchemeDetails extends SchemeState {}

class LoadSchemeDetailsSuccess extends SchemeState {
  final Scheme response;

  LoadSchemeDetailsSuccess(this.response);
}

class LoadSchemeDetailsFailure extends SchemeState {
  final String error;

  LoadSchemeDetailsFailure(this.error);
}

class DeletingScheme extends SchemeState {}

class DeleteSchemeSuccess extends SchemeState {
  DeleteSchemeSuccess();
}

class DeleteSchemeFailure extends SchemeState {
  final String error;

  DeleteSchemeFailure(this.error);
}

class LoadingProductList extends SchemeState {
  LoadingProductList();
}

class LoadProductSuccess extends SchemeState {
  final List<Product> response;

  LoadProductSuccess(this.response);
}

class LoadProductListFailure extends SchemeState {
  final String error;

  LoadProductListFailure(this.error);
}

class CreatingNewScheme extends SchemeState {}

class SchemeCreateSuccess extends SchemeState {}

class SchemeCreateFailure extends SchemeState {
  final String error;

  SchemeCreateFailure(this.error);
}

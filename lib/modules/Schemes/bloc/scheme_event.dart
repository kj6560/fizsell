part of 'scheme_bloc.dart';

abstract class SchemeEvent extends Equatable {
  const SchemeEvent();

  @override
  List<Object> get props => [];
}

class LoadSchemeList extends SchemeEvent {
  const LoadSchemeList();
}

class LoadSchemeDetails extends SchemeEvent {
  final int scheme_id;
  const LoadSchemeDetails({required this.scheme_id});
}

class DeleteScheme extends SchemeEvent {
  final int scheme_id;
  const DeleteScheme({required this.scheme_id});
}

class LoadProductList extends SchemeEvent {
  const LoadProductList();
}

class CreateNewScheme extends SchemeEvent {
  final Map<String, dynamic> payload;
  const CreateNewScheme({required this.payload});
}

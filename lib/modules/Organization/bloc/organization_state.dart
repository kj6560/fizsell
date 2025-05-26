part of 'organization_bloc.dart';

abstract class OrganizationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrganizationInitial extends OrganizationState {}

class OrganizationLoading extends OrganizationState {}

class OrganizationSuccess extends OrganizationState {
  final String message;
  OrganizationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class OrganizationFailure extends OrganizationState {
  final String error;
  OrganizationFailure(this.error);

  @override
  List<Object?> get props => [error];
}

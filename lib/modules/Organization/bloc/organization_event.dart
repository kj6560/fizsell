part of 'organization_bloc.dart';

abstract class OrganizationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateOrganizationRequested extends OrganizationEvent {
  final Map<String, dynamic> orgData;

  CreateOrganizationRequested(this.orgData);

  @override
  List<Object?> get props => [orgData];
}

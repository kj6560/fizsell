part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class SubscriptionFailure extends HomeState{
  final String message;
  SubscriptionFailure(this.message);
}
final class LoadingHome extends HomeState {}

final class LoadSuccess extends HomeState {
  final HomeResponse response;
  LoadSuccess({required this.response});
}

final class LoadFailure extends HomeState {
  final String error;
  LoadFailure({required this.error});
}
final class ForceLogout extends HomeState{}
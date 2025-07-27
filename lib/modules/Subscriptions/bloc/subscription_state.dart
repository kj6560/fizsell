part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}

final class SubscriptionsLoading extends SubscriptionState {}

final class SubscriptionsLoaded extends SubscriptionState {
  final List<Subscription> response;

  SubscriptionsLoaded(this.response);
}

final class SubscriptionsLoadFailure extends SubscriptionState {
  final String message;

  SubscriptionsLoadFailure(this.message);
}

final class SubscriptionDetailLoaded extends SubscriptionState {
  final Subscription response;

  SubscriptionDetailLoaded(this.response);
}

final class CreateSubscriptionsLoading extends SubscriptionState {}

final class SubscriptionCreatedSuccessfuly extends SubscriptionState {
  final SubscriptionOrder order;

  SubscriptionCreatedSuccessfuly(this.order);
}

final class SubscriptionCreatedFailure extends SubscriptionState {
  final String msg;

  SubscriptionCreatedFailure(this.msg);
}

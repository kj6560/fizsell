part of 'subscription_bloc.dart';

@immutable
sealed class SubscriptionEvent {}

class LoadSubscriptionList extends SubscriptionEvent {}

class LoadSubscriptionDetail extends SubscriptionEvent {
  int id;

  LoadSubscriptionDetail(this.id);
}

class CreateNewSubscription extends SubscriptionEvent {
  int user_id;
  double amount;
  int plan_id;

  CreateNewSubscription(this.user_id, this.amount, this.plan_id);
}

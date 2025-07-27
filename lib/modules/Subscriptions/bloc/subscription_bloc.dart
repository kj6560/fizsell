import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fizsell/modules/Subscriptions/Dio/subscription_repository.dart';
import 'package:fizsell/modules/Subscriptions/models/Subscription.dart';
import 'package:fizsell/modules/Subscriptions/models/SubscriptionOrder.dart';
import 'package:meta/meta.dart';

import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';

part 'subscription_event.dart';

part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionRepository subsRepositoryImpl = SubscriptionRepository();

  SubscriptionBloc() : super(SubscriptionInitial()) {
    on<LoadSubscriptionList>(_loadSubscriptionList);
    on<LoadSubscriptionDetail>(_loadSubscriptionDetail);
    on<CreateNewSubscription>(_createSubscriptionOrder);
  }

  void _loadSubscriptionList(
    LoadSubscriptionList event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      emit(SubscriptionsLoading());
      final response = await subsRepositoryImpl.fetchSubscriptionList();

      if (response == null || response.data == null) {
        emit(SubscriptionsLoadFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      print(data);
      final List<Subscription> subscriptionList = subscriptionFromJson(
        jsonEncode(data),
      );

      if (response.statusCode == 401) {
        emit(SubscriptionsLoadFailure("Login failed."));
        return;
      }

      emit(SubscriptionsLoaded(subscriptionList));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(SubscriptionsLoadFailure("An error occurred."));
    }
    return;
  }

  void _loadSubscriptionDetail(
    LoadSubscriptionDetail event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      int id = event.id;
      emit(SubscriptionsLoading());
      print("detail: reached here");
      final response = await subsRepositoryImpl.fetchSubscriptionDetail(id);
      print("response: ${response}");
      if (response == null || response.data == null) {
        emit(SubscriptionsLoadFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      print(data);
      final Subscription subscription = Subscription.fromJson(data);

      if (response.statusCode == 401) {
        emit(SubscriptionsLoadFailure("Login failed."));
        return;
      }

      emit(SubscriptionDetailLoaded(subscription));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(SubscriptionsLoadFailure("An error occurred."));
    }
    return;
  }

  void _createSubscriptionOrder(
    CreateNewSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    try {
      int user_id = event.user_id;
      int plan_id = event.plan_id;
      double amount = event.amount;
      emit(CreateSubscriptionsLoading());
      print("create: reached here");
      final response = await subsRepositoryImpl.createSubscriptionOrder(
        user_id,
        plan_id,
        amount,
      );
      print("response: ${response}");
      if (response == null || response.data == null) {
        emit(SubscriptionsLoadFailure("No response from server"));
        return;
      }

      // Ensure data is always a Map<String, dynamic>
      final data =
          response.data['data'] is String
              ? jsonDecode(response.data['data'])
              : response.data['data'];
      print(data);
      final SubscriptionOrder subscription = SubscriptionOrder.fromJson(data);

      if (response.statusCode == 401) {
        emit(SubscriptionsLoadFailure("Login failed."));
        return;
      }

      emit(SubscriptionCreatedSuccessfuly(subscription));
    } catch (e, stacktrace) {
      print('Exception in bloc: $e');
      print('Stacktrace: $stacktrace');
      emit(SubscriptionsLoadFailure("An error occurred."));
    }
    return;
  }
}

library subscription_detail;

import 'dart:convert';

import 'package:fizsell/modules/Subscriptions/bloc/subscription_bloc.dart';
import 'package:fizsell/modules/Subscriptions/models/Subscription.dart';
import 'package:fizsell/modules/Subscriptions/models/SubscriptionOrder.dart';
import 'package:flutter/material.dart';
import 'package:fizsell/core/widgets/base_widget.dart';
import 'package:fizsell/modules/Subscriptions/views/SubscriptionDetailController.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../core/config/AppConstants.dart';
import '../../../core/config/config.dart';
import '../../../core/local/hive_constants.dart';
import '../../auth/models/User.dart';

part 'SubscriptionDetail.dart';

class Subscriptiondetailcontroller extends StatefulWidget {
  const Subscriptiondetailcontroller({super.key});

  @override
  State<Subscriptiondetailcontroller> createState() =>
      SubscriptiondetailcontrollerState();
}

class SubscriptiondetailcontrollerState
    extends State<Subscriptiondetailcontroller> {
  int plan_id = 0;
  late Razorpay _razorpay;

  void _getArguments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      if (route == null) {
        return;
      }

      final args = route.settings.arguments;
      if (args == null) {
        return;
      }
      if (args is Map<String, dynamic> && args.containsKey("id")) {
        String id = args["id"].toString();
        setState(() {
          plan_id = int.parse(id);
        });

        BlocProvider.of<SubscriptionBloc>(
          context,
        ).add(LoadSubscriptionDetail(plan_id));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Subscriptiondetail(this);
  }

  //create order
  //open checkout
  //handle
  //1. payment error
  //2. payment success
  //3. external wallet acces like phone pe
  // verify payment

  createOrder(Subscription plan) async {
    //create order
    try {
      String userString = await authBox.get(HiveKeys.userBox);
      User user = User.fromJson(jsonDecode(userString));
      print("${user.id},${plan.featureId},${plan.featurePrice}");
      BlocProvider.of<SubscriptionBloc>(context).add(
        CreateNewSubscription(
          user.id,
          double.parse(plan.featurePrice),
          plan_id,
        ),
      );
      // var orderID = await RemoteServices.createOrderID(
      //     requestId: requestId.value, amount: totalAmount.value * 100);
      // if (orderID != null) {
      //   print('controller: order response: $orderID');
      //
      //   openCheckout(orderID);
      // }
    } catch (e) {
      print('error creating order ID: $e');
    }
  }



  void openCheckout(SubscriptionOrder order) async {

    final double Amount = order.amount / 100;

    var options = {
      'key': AppConstants.razorpayKey,
      'amount': Amount,
      'name': 'UNIV',
      'description': 'Mentor Request',
      'order_id': orderId,
      "prefill": {
        "name":
        '${paymentConfirmationData.value?.user.firstName} ${paymentConfirmationData.value?.user.lastName}',
        "email": '${paymentConfirmationData.value?.user.email ?? ""}',
        "number": '${paymentConfirmationData.value?.user.number ?? ""}',
      },
      "notes": {"userId": "${userId.value}", "packageId": "${requestId.value}"},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
      _razorpay.on(
          Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
      _razorpay.on(
          Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  // void handlePaymentErrorResponse(PaymentFailureResponse response) {
  //   isPaymentLoading.value = 0;
  //   print('payment error response: $response');
  //
  //   MyDialogs.paymentMsgDialog(
  //     'Payment Failed',
  //     'If the amount was deducted, then automatic refund will be initiated within 7 working days. Please try again.',
  //     Get.context,
  //   );
  // }
  //
  // void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
  //   isPaymentLoading.value = 0;
  //   print('payment order ID: ${response.orderId}');
  //   print('payment ID: ${response.paymentId}');
  //   print('signature ID: ${response.signature}');
  //   paymentVerify(response.paymentId, response.signature);
  // }
  //
  // void handleExternalWalletSelected(ExternalWalletResponse response) {
  //   isPaymentLoading.value = 0;
  //   print('external wallet response: $response');
  //
  //   showAlertDialog(
  //       Get.context!, "External Wallet Selected", "${response.walletName}");
  // }
  //
  // paymentVerify(paymentID, signatureId) async {
  //   try {
  //     var response = await RemoteServices.verifyPaymentSignature(
  //         paymentId: paymentID,
  //         signatureId: signatureId,
  //         requestId: requestId.value);
  //     print('response in controller of razor pay hook: $response');
  //     if (response['error'] == false) {
  //       print('Payment verification successful');
  //       print('${response['message']}');
  //       MyDialogs.showMsgDialog(
  //           "Payment Successful", "${response['message']}", Get.context!, () {
  //         Get.until((route) => route.settings.name == '/bottom_nav');
  //
  //         bottomNavController?.selectedIndex.value = 0;
  //         bottomNavController?.onItemTapped(0);
  //         bottomNavController?.pageController.jumpToPage(0);
  //         if (!Get.isRegistered<AllMentorRequestController>()) {
  //           Get.put(AllMentorRequestController());
  //         }
  //         Get.toNamed('/all_mentor_requests');
  //         Get.find<AllMentorRequestController>().fetchAllMentorRequests();
  //       });
  //     } else {
  //       print('Payment verification failed');
  //       print('${response['message']}');
  //       MyDialogs.paymentMsgDialog(
  //         'Verification Failed',
  //         'Something went wrong.\nIf the amount was deducted, then automatic refund will be initiated within 7 working days. Please try again.',
  //         Get.context,
  //       );
  //     }
  //   } catch (e) {
  //     print('Error in razorHook api call: $e');
  //   }
  // }
  //
  // void showAlertDialog(BuildContext context, String title, String message) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return PopScope(
  //           canPop: false,
  //           child: SizedBox(
  //             width: double.infinity,
  //             height: double.infinity,
  //             child: Dialog(
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               elevation: 0,
  //               backgroundColor: AppConstants.primaryColor,
  //               child: Container(
  //                 padding: EdgeInsets.only(top: 20),
  //                 // margin: EdgeInsets.all(20),
  //                 decoration: BoxDecoration(
  //                   color: AppConstants.primaryColor,
  //                   shape: BoxShape.rectangle,
  //                   borderRadius: BorderRadius.circular(20),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black26,
  //                       blurRadius: 10.0,
  //                       spreadRadius: 1.0,
  //                       offset: const Offset(0.0, 0.0),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Container(
  //                       child: Image.asset(
  //                         'assets/images/logo_white_act.png',
  //                         height: 80,
  //                       ),
  //                     ),
  //                     Text(
  //                       title,
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                           fontSize: 18,
  //                           color: Colors.white,
  //                           fontWeight: FontWeight.bold),
  //                     ),
  //                     SizedBox(
  //                       height: 24,
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 20),
  //                       child: Text(
  //                         message,
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 24,
  //                     ),
  //                     GestureDetector(
  //                       onTap: () {
  //                         Get.back();
  //                       },
  //                       child: Container(
  //                         width: double.infinity,
  //                         height: 40,
  //                         decoration: BoxDecoration(
  //                           color: Color.fromARGB(185, 0, 128, 103),
  //                           borderRadius: BorderRadius.only(
  //                             bottomLeft: Radius.circular(20),
  //                             bottomRight: Radius.circular(20),
  //                           ),
  //                         ),
  //                         child: Center(
  //                             child: Text('OK',
  //                                 style: TextStyle(color: Colors.white))),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
}

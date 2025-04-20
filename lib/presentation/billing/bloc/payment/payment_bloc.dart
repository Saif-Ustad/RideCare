import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/stripe_service/stripe_customer.dart';
import '../../../../core/stripe_service/stripe_service.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../../../home/bloc/notification/notification_bloc.dart';
import '../../../home/bloc/notification/notification_event.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final StripeService stripeService;
  final StripeCustomer stripeCustomer;

  final NotificationBloc notificationBloc = GetIt.I<NotificationBloc>();

  PaymentBloc({required this.stripeService, required this.stripeCustomer})
    : super(PaymentInitial()) {
    on<StartPayment>(_onStartPayment);
  }

  Future<void> _onStartPayment(
    StartPayment event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      emit(PaymentLoading());

      String? customerId = await stripeCustomer.getCustomerByEmail(event.email);

      customerId ??= await stripeCustomer.createStripeCustomer(
        name: event.name,
        email: event.email,
      );

      final ephemeralKey = await stripeCustomer.createEphemeralKey(customerId!);

      if (ephemeralKey == null) {
        print("Ephemeral key creation failed.");
        return;
      }

      await stripeService.makePayment(
        amount: event.amount,
        customerId: customerId,
        ephemeralKeySecret: ephemeralKey,
      );
      emit(PaymentSuccess());

      final String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final NotificationEntity notification = NotificationEntity(
          title: "Payment Successful!",
          body:
              "₹${event.amount} has been paid via card. Thank you for choosing RideCare!",
          type: "Payment",
        );

        notificationBloc.add(
          AddNotificationEvent(userId: userId, notification: notification),
        );
      }
    } catch (e) {
      emit(PaymentFailed(e.toString()));
    }
  }
}

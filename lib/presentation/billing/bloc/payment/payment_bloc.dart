import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/stripe_service/stripe_customer.dart';
import '../../../../core/stripe_service/stripe_service.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final StripeService stripeService;
  final StripeCustomer stripeCustomer;

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
    } catch (e) {
      emit(PaymentFailed(e.toString()));
    }
  }
}

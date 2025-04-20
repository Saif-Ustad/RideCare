import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:ridecare/domain/usecases/address/get_user_addresses.dart';
import 'package:ridecare/domain/usecases/address/add_address.dart';
import 'package:ridecare/domain/usecases/address/update_address.dart';
import 'package:ridecare/domain/usecases/address/delete_address.dart';

import '../../../domain/entities/notification_entity.dart';
import '../../home/bloc/notification/notification_bloc.dart';
import '../../home/bloc/notification/notification_event.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetUserAddressesUseCase getUserAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;

  final NotificationBloc notificationBloc = GetIt.I<NotificationBloc>();

  AddressBloc({
    required this.getUserAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
  }) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await getUserAddressesUseCase(event.userId);
      emit(AddressLoaded(addresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onAddAddress(
    AddAddress event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    try {
      await addAddressUseCase(event.address);
      final updatedAddresses = await getUserAddressesUseCase(
        event.address.userId,
      );
      emit(AddressLoaded(updatedAddresses));

      final NotificationEntity notification = NotificationEntity(
        title: "Location Added",
        body:
            'Your location (${event.address.title} - ${event.address.address}) has been added successfully.',
        type: "Location Add",
      );

      notificationBloc.add(
        AddNotificationEvent(
          userId: event.address.userId,
          notification: notification,
        ),
      );
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    try {
      await updateAddressUseCase(event.address);
      final updatedAddresses = await getUserAddressesUseCase(
        event.address.userId,
      );
      emit(AddressLoaded(updatedAddresses));
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    if (state is! AddressLoaded) return;

    try {
      await deleteAddressUseCase(event.addressId);
      final currentAddresses = (state as AddressLoaded).addresses;
      if (currentAddresses.isNotEmpty) {
        final userId = currentAddresses.first.userId;
        final updatedAddresses = await getUserAddressesUseCase(userId);
        emit(AddressLoaded(updatedAddresses));
      } else {
        emit(AddressLoaded([]));
      }
    } catch (e) {
      emit(AddressError(e.toString()));
    }
  }
}

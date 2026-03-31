import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySubscription;

  ConnectivityBloc({required ConnectivityService connectivityService})
      : _connectivityService = connectivityService,
        super(ConnectivityState(isConnected: connectivityService.isConnected)) {
    _connectivityService.initialize();
    on<ConnectivityChangedEvent>(_onConnectivityChanged);
    on<CheckConnectivityEvent>(_onCheckConnectivity);

    // Listen to connectivity changes from service
    _connectivitySubscription =
        _connectivityService.connectionStatusStream.listen((isConnected) {
      add(ConnectivityChangedEvent(isConnected));
    });
    add(CheckConnectivityEvent());
  }

  void _onConnectivityChanged(
    ConnectivityChangedEvent event,
    Emitter<ConnectivityState> emit,
  ) {
    emit(state.copyWith(isConnected: event.isConnected, isChecking: false));
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivityEvent event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(state.copyWith(isChecking: true));

    final isConnected = await _connectivityService.checkConnectivity();

    emit(state.copyWith(isConnected: isConnected, isChecking: false));
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

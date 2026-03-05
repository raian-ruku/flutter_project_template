part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

/// Event triggered when connectivity status changes
class ConnectivityChangedEvent extends ConnectivityEvent {
  final bool isConnected;
  ConnectivityChangedEvent(this.isConnected);
}

/// Event to manually check connectivity status
class CheckConnectivityEvent extends ConnectivityEvent {}

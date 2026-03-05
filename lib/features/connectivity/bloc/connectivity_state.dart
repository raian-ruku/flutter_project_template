part of 'connectivity_bloc.dart';

class ConnectivityState {
  final bool isConnected;
  final bool isChecking;

  const ConnectivityState({this.isConnected = true, this.isChecking = false});

  ConnectivityState copyWith({bool? isConnected, bool? isChecking}) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

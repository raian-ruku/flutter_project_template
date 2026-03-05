
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that monitors connectivity state and shows
/// [NoConnectionPage] as an overlay when the device is offline.
///
/// This widget should wrap the entire app to provide global connectivity
/// monitoring across all pages.
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      buildWhen: (previous, current) =>
          previous.isConnected != current.isConnected,
      builder: (context, state) {
        return Stack(
          textDirection: .ltr,
          children: [
            // Main app content
            child,

            // No connection overlay
            if (!state.isConnected)
              Positioned.fill(child: const NoConnectionPage()),
          ],
        );
      },
    );
  }
}

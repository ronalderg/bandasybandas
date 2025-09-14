// lib/src/app/router/go_router_refresh_stream.dart
import 'dart:async';

import 'package:flutter/foundation.dart';

/// Una clase [ChangeNotifier] que escucha un [Stream] y notifica a sus
/// listeners cada vez que el stream emite un nuevo valor.
///
/// Esto es útil para integrar streams (como los de BLoC) con widgets o
/// clases que requieren un [Listenable], como el `refreshListenable` de GoRouter.
class GoRouterRefreshStream extends ChangeNotifier {
  /// Crea una instancia que escucha el [stream] proporcionado.
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:yumdoor/platform/connectivity/connectivity_service.dart';
import 'package:yumdoor/platform/token_store/secure_storage_token_store.dart';
import 'package:yumdoor/platform/wake_lock/wake_lock_service.dart';

import '../platform/contracts.dart';

// The web implementations in a real browser:
//   flutter test --platform chrome test/web/
// Headless Chrome may refuse the wake lock (denied); the contract allows it.

void main() {
  group('SecureStorageTokenStore', () {
    tokenStoreContract(SecureStorageTokenStore.new);
  });

  group('web WakeLockService', () => wakeLockContract(WakeLockService.new));

  group('web ConnectivityService', () {
    connectivityContract(ConnectivityService.new);
  });
}

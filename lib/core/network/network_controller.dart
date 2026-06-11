import 'dart:async';

import 'package:ai_chat_bot/core/network/network_info.dart';
import 'package:ai_chat_bot/core/widgets/app_snackbar.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  NetworkController(this._networkInfo);

  final NetworkInfo _networkInfo;

  final RxBool isConnected = true.obs;

  StreamSubscription<bool>? _connectionSubscription;
  bool _hasShownInitialState = false;
  bool _offlineSnackbarVisible = false;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _listenToConnectionChanges();
  }

  Future<void> _checkInitialConnection() async {
    final connected = await _networkInfo.isConnected;
    isConnected.value = connected;
    _hasShownInitialState = true;

    if (!connected) {
      _showOfflineSnackbar();
    }
  }

  void _listenToConnectionChanges() {
    _connectionSubscription = _networkInfo.onConnectionChange.listen((
      connected,
    ) {
      final wasConnected = isConnected.value;
      isConnected.value = connected;

      if (!connected) {
        _showOfflineSnackbar();
        return;
      }

      if (_offlineSnackbarVisible) {
        _hideOfflineSnackbar();
        return;
      }

      if (_hasShownInitialState && !wasConnected) {
        AppSnackbar.online();
      }
    });
  }

  void _showOfflineSnackbar() {
    if (_offlineSnackbarVisible) {
      return;
    }

    _offlineSnackbarVisible = true;
    AppSnackbar.offline();
  }

  void _hideOfflineSnackbar() {
    _offlineSnackbarVisible = false;

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    AppSnackbar.online();
  }

  @override
  void onClose() {
    _connectionSubscription?.cancel();
    super.onClose();
  }
}

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;

  Stream<bool> get onConnectionChange;
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({InternetConnection? internetConnection})
    : _internetConnection = internetConnection ?? InternetConnection();

  final InternetConnection _internetConnection;

  @override
  Future<bool> get isConnected {
    return _internetConnection.hasInternetAccess;
  }

  @override
  Stream<bool> get onConnectionChange {
    return _internetConnection.onStatusChange.map((status) {
      return status == InternetStatus.connected;
    }).distinct();
  }
}

import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectionInfo {
  Future<bool> get isConnected;
  Future<String?> get ipv4;
  Future<String?> get ipv6;
}

class ConnectionInfoImpl implements ConnectionInfo {
  final connectivity = Connectivity();
  final networkInfo = NetworkInfo();

  @override
  Future<bool> get isConnected async {
    var connectivityResult = await connectivity.checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }

  @override
  Future<String?> get ipv4 => networkInfo.getWifiIP();

  @override
  Future<String?> get ipv6 => networkInfo.getWifiIPv6();
}

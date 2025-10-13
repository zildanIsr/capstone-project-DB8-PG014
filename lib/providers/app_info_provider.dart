import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoProvider extends ChangeNotifier {
  String? _appName, _packageName, _version, _buildNumber;

  String? get appName => _appName;
  String? get packageName => _packageName;
  String? get version => _version;
  String? get buildNumber => _buildNumber;

  Future<void> initAppInformation() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _appName = packageInfo.appName;
    _packageName = packageInfo.packageName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

}
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

Future<bool> bioAuth() async {
  final LocalAuthentication localAuth = LocalAuthentication();
  try {
    final bool canAuthenticateWithBiometrics =
        await localAuth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await localAuth.isDeviceSupported();
    if (!canAuthenticate) {
      return true;
    }
    final List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    if (availableBiometrics.isEmpty) {
      return true;
    }

    const AuthenticationOptions options = AuthenticationOptions(
        biometricOnly: false, stickyAuth: true, useErrorDialogs: true);
    final bool authenticated = await localAuth.authenticate(
      localizedReason: 'Please authenticate to change your password',
      options: options,
    );
    if (!authenticated) {
      debugPrint('Authentication failed');
    }
    return authenticated;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

library shake;

import 'dart:async';
import 'dart:math';
import 'package:sensors/sensors.dart';

typedef Null PhoneShakeCallback();

class ShakeDetector {

  final PhoneShakeCallback onPhoneShake;

  final double shakeThresholdGravity;

  final int shakeSlopTimeMS;

  final int shakeCountResetTime;

  int mShakeTimestamp = DateTime.now().millisecondsSinceEpoch;
  int mShakeCount = 0;

  StreamSubscription streamSubscription;

  ShakeDetector.autoStart(
      {this.onPhoneShake,
        this.shakeThresholdGravity = 2.0,
        this.shakeSlopTimeMS = 5000,
        this.shakeCountResetTime = 3000}) {
    startListening();
  }

  void startListening() {
    streamSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      double x = event.x;
      double y = event.y;
      double z = event.z;

      double gX = x / 9.80665;
      double gY = y / 9.80665;
      double gZ = z / 9.80665;


      double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

      if (gForce > shakeThresholdGravity) {
        var now = DateTime.now().millisecondsSinceEpoch;

        if (mShakeTimestamp + shakeSlopTimeMS > now) {
          return;
        }

        if (mShakeTimestamp + shakeCountResetTime < now) {
          mShakeCount = 0;
        }

        mShakeTimestamp = now;
        mShakeCount++;

        onPhoneShake();
      }
    });
  }

  void stopListening() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
    }
  }
}
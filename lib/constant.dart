import 'package:flutter/material.dart';
import 'package:health/health.dart';

const FOOT_STEP = "assets/footstep.svg";
const GOAL = 1000;

final messengerKey = GlobalKey<ScaffoldMessengerState>();

const types = [
  HealthDataType.STEPS,
  HealthDataType.WEIGHT,
  HealthDataType.HEIGHT
];

const permissions = [
  HealthDataAccess.READ,
  HealthDataAccess.READ,
  HealthDataAccess.READ,
];

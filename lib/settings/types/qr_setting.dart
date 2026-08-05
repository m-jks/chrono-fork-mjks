import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/common/types/json.dart';
import 'package:flutter/material.dart';

class QrSetting extends Setting<String> {
  QrSetting(String name, String Function(BuildContext) getLocalizedName, String value)
      : super(name, getLocalizedName, value);

  @override
  Setting<String> copy() {
    return QrSetting(name, getLocalizedName, value);
  }

  @override
  void loadValueFromJson(Json json) {
    // Safely extract the saved QR string from JSON
    value = json['value'] as String? ?? "";
  }

  @override
  Json valueToJson() {
    return {'value': value};
  }
}
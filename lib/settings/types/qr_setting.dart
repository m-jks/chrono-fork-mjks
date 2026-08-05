import 'package:flutter/material.dart';
import 'package:clock_app/settings/types/setting.dart';
import 'package:clock_app/settings/types/setting_enable_condition.dart';
import 'package:clock_app/settings/utils/description.dart';

class QrSetting extends Setting<String> {
  QrSetting(
    String name,
    String Function(BuildContext) getLocalizedName,
    String defaultValue, {
    void Function(BuildContext, String)? onChange,
    String Function(BuildContext) getDescription = defaultDescription,
    bool isVisual = true,
    List<EnableConditionParameter> enableConditions = const [],
    List<String> searchTags = const [],
  }) : super(
          name,
          getLocalizedName,
          getDescription,
          defaultValue,
          onChange,
          enableConditions,
          searchTags,
          isVisual,
        );

  @override
  QrSetting copy() {
    return QrSetting(
      name,
      getLocalizedName,
      value as String,
      onChange: onChange,
      getDescription: getDescription,
      enableConditions: enableConditions,
      isVisual: isVisual,
      searchTags: searchTags,
    );
  }
}
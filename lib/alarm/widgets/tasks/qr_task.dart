import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clock_app/settings/types/setting_group.dart';
// Note: Adjust this import if your string setting class is named differently
import 'package:clock_app/settings/types/setting.dart'; 

class QrTask extends StatefulWidget {
  final Function() onSolve;
  final SettingGroup settings;

  const QrTask({
    Key? key,
    required this.onSolve,
    required this.settings,
  }) : super(key: key);

  @override
  State<QrTask> createState() => _QrTaskState();
}

class _QrTaskState extends State<QrTask> {
  late String targetQrString;
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    
    // Retrieve the saved QR code string from the task's settings.
    // Note: If 'StringSetting' doesn't exist in your app yet, we will 
    // need to create it for the setup phase!
    try {
      final qrSetting = widget.settings.settings.firstWhere(
        (s) => s.name == "Registered QR Code"
      );
      // Using dynamic here temporarily to grab the .value property 
      // based on how your other settings classes (like SliderSetting) work.
      targetQrString = (qrSetting as dynamic).value ?? "";
    } catch (e) {
      // Fallback for testing if the setting isn't hooked up yet
      targetQrString = "test_qr_code_123"; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Scan your registered QR Code to dismiss the alarm.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        
        // The scanner needs to be inside an Expanded or constrained box
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MobileScanner(
                // The controller lets us customize the camera behavior
                controller: MobileScannerController(
                  detectionSpeed: DetectionSpeed.normal,
                  facing: CameraFacing.back,
                ),
                onDetect: (capture) {
                  // Prevent multiple rapid triggers once it's already solved
                  if (_isSolved) return;

                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    // Check if the camera sees the QR code we saved during setup
                    if (barcode.rawValue == targetQrString) {
                      setState(() {
                        _isSolved = true;
                      });
                      
                      // This callback tells the app the task is complete and stops the alarm
                      widget.onSolve();
                      break; 
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
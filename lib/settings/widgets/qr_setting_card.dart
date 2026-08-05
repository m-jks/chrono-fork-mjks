import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:clock_app/settings/types/qr_setting.dart';
import 'package:clock_app/common/widgets/card_container.dart';

class QrSettingCard extends StatefulWidget {
  final QrSetting setting;

  const QrSettingCard({Key? key, required this.setting}) : super(key: key);

  @override
  State<QrSettingCard> createState() => _QrSettingCardState();
}

class _QrSettingCardState extends State<QrSettingCard> {
  
  // Opens the scanner screen and waits for a result
  Future<void> _openScanner() async {
    final String? scannedCode = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const QrSetupScannerScreen(),
      ),
    );

    // If the user successfully scanned a code, update the setting's value
    if (scannedCode != null && scannedCode.isNotEmpty) {
      setState(() {
        widget.setting.setValue(context, scannedCode);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCode = widget.setting.value.isNotEmpty;

    return CardContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.setting.getLocalizedName(context),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasCode ? "Registered: ${widget.setting.value}" : "No QR Code registered",
                    style: TextStyle(
                      color: hasCode ? Colors.green : Colors.redAccent,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FilledButton.icon(
              onPressed: _openScanner,
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(hasCode ? "Replace" : "Scan"),
            ),
          ],
        ),
      ),
    );
  }
}

/// A dedicated full-screen scanner for the setup phase
class QrSetupScannerScreen extends StatelessWidget {
  const QrSetupScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan to Register"),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              // Immediately pop the route and return the string data to the Card
              Navigator.of(context).pop(barcode.rawValue);
              break;
            }
          }
        },
      ),
    );
  }
}
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_tracking.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'package:portail_canalplustelecom_mobile/class/app.config.dart';
import 'package:portail_canalplustelecom_mobile/class/colors.dart';
import 'package:portail_canalplustelecom_mobile/class/devicebarcode.dart';
import 'package:portail_canalplustelecom_mobile/class/scanresult.dart';
import 'package:portail_canalplustelecom_mobile/prestaplus/widgets/scan.info.result.dart';

class MatrixScanScreen extends StatefulWidget {
  final Function(DeviceBarCodes)? onScanned;
  const MatrixScanScreen({
    super.key,
    this.onScanned,
  });

  @override
  State<StatefulWidget> createState() => _MatrixScanScreenState();
}

class _MatrixScanScreenState extends State<MatrixScanScreen>
    with WidgetsBindingObserver
    implements BarcodeTrackingListener {
  final DataCaptureContext _context = DataCaptureContext.forLicenseKey(
      ApplicationConfiguration.instance!.scandit.licenseKey);

  // Use the world-facing (back) camera.
  final Camera? _camera = Camera.defaultCamera;
  late BarcodeTracking _barcodeTracking;
  late DataCaptureView _captureView;
  bool _isPermissionMessageVisible = false;

  final ScaninfosResult scanResults = ScaninfosResult();

  _MatrixScanScreenState();

  void _checkPermission() {
    Permission.camera.request().isGranted.then((value) => setState(() {
          _isPermissionMessageVisible = !value;
          if (value) {
            _camera?.switchToDesiredState(FrameSourceState.on);
          }
        }));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Use the recommended camera settings for the BarcodeTracking mode.
    var cameraSettings = BarcodeTracking.recommendedCameraSettings;
    // Adjust camera settings - set Full HD resolution.
    cameraSettings.preferredResolution = VideoResolution.fullHd;

    _camera?.applySettings(cameraSettings);

    // Switch camera on to start streaming frames and enable the barcode tracking mode.
    // The camera is started asynchronously and will take some time to completely turn on.
    _checkPermission();

    // The barcode tracking process is configured through barcode tracking settings
    // which are then applied to the barcode tracking instance that manages barcode tracking.
    var captureSettings = BarcodeTrackingSettings();

    // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
    // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
    // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
    captureSettings.enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.upce,
      Symbology.code39,
      Symbology.code128,
    });

    // Create new barcode tracking mode with the settings from above.
    _barcodeTracking = BarcodeTracking.forContext(_context, captureSettings)
      // Register self as a listener to get informed of tracked barcodes.
      ..addListener(this);

    // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
    // camera preview. The view must be connected to the data capture context.
    _captureView = DataCaptureView.forContext(_context);

    // Add a barcode tracking overlay to the data capture view to render the tracked barcodes on
    // top of the video preview. This is optional, but recommended for better visual feedback.
    _captureView.addOverlay(
        BarcodeTrackingBasicOverlay.withBarcodeTrackingForViewWithStyle(
            _barcodeTracking,
            _captureView,
            BarcodeTrackingBasicOverlayStyle.legacy));

    // Set the default camera as the frame source of the context. The camera is off by
    // default and must be turned on to start streaming frames to the data capture context for recognition.
    if (_camera != null) {
      _context.setFrameSource(_camera!);
    }
    _camera?.switchToDesiredState(FrameSourceState.on);
    _barcodeTracking.isEnabled = true;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_isPermissionMessageVisible) {
      child = const Text('No permission to access the camera!',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black));
    } else {
      var bottomPadding = 48 + MediaQuery.of(context).padding.bottom;
      var containerPadding = defaultTargetPlatform == TargetPlatform.iOS
          ? EdgeInsets.fromLTRB(48, 48, 48, bottomPadding)
          : const EdgeInsets.all(48);
      child = Stack(children: [
        _captureView,
        Container(
          alignment: Alignment.bottomCenter,
          padding: containerPadding,
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => _showScanResults(context),
                  style: TextButton.styleFrom(
                      backgroundColor: lightColorScheme.primary,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side:
                              const BorderSide(color: Colors.white, width: 0))),
                  child: const Text(
                    'Terminer',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ))),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListenableBuilder(
              listenable: scanResults,
              builder: (context, child) {
                var result = DeviceBarCodes.fromScanResult(scanResults.results);
                return ScanInfosResultBubble(result: result);
              },
            ),
          ),
        )
      ]);
    }
    // ignore: deprecated_member_use
    return WillPopScope(
        child: Scaffold(body: child),
        onWillPop: () {
          dispose();
          return Future.value(true);
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _camera?.switchToDesiredState(FrameSourceState.off);
    }
  }

  // This function is called whenever objects are updated and it's the right place to react to
  // the tracking results.
  @override
  void didUpdateSession(
      BarcodeTracking barcodeTracking, BarcodeTrackingSession session) {
    for (final trackedBarcode in session.addedTrackedBarcodes) {
      scanResults.add(ScanResult(
          trackedBarcode.barcode.symbology, trackedBarcode.barcode.data ?? ''));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _barcodeTracking.removeListener(this);
    _barcodeTracking.isEnabled = false;
    _camera?.switchToDesiredState(FrameSourceState.off);
    _context.removeAllModes();
    super.dispose();
  }

  void _showScanResults(BuildContext context) {
    _barcodeTracking.isEnabled = false;
    widget.onScanned?.call(DeviceBarCodes.fromScanResult(scanResults.results));
    _resetScanResults();
  }

  void _resetScanResults() {
    scanResults.clear();
    _barcodeTracking.isEnabled = true;
  }
}

class ScanInfosResultBubble extends StatelessWidget {
  final DeviceBarCodes result;
  const ScanInfosResultBubble({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    var uderline = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(decoration: TextDecoration.underline);
    return Container(
      width: 250,
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Numdec", style: uderline),
          Text(result.numdec ?? "- - - - - - - - -"),
          Text("Adresse MAC", style: uderline),
          Text(result.adresseMAC ?? "- - - - - - - - -"),
          Text("numéro Serie", style: uderline),
          Text(result.numeroSerie ?? "- - - - - - - - -"),
          Text("ont Serial", style: uderline),
          Text(result.ontSerial ?? "- - - - - - - - -"),
        ],
      ),
    );
  }
}

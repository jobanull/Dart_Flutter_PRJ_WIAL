import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxList<List<String>> purchaseOrders = <List<String>>[].obs;

  final TextEditingController purchaseOrderController = TextEditingController();
  final TextEditingController totalItemController = TextEditingController();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  String qrText = '';

  String generateSalesOrderID() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'SO_$timestamp';
  }

  void disposeController() {
    qrController.dispose();
  }

  void onQRViewCreated(QRViewController control, String soId) async {
    qrController = control;
    qrController.scannedDataStream.listen((scanData) {
      qrText = scanData.code!;
      print(qrText);
      print(soId);
      if (qrText == soId) {
        Get.dialog(
          AlertDialog(
            title: Text('QR Code Verification'),
            content: Text('QR Code Sesuai dengan SO'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Get.dialog(
          AlertDialog(
            title: Text('QR Code Verification'),
            content: Text('QR Code Tidak Sesuai dengan SO'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  void _loadPurchaseOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    purchaseOrders.value =
        (prefs.getStringList('purchaseOrders') ?? []).map((item) {
      return item.split('|');
    }).toList();
  }

  void addPurchaseOrder(List<String> purchaseOrderData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    purchaseOrders.add(purchaseOrderData);
    List<String> flatPurchaseOrders = purchaseOrders.map((data) {
      return data.join('|');
    }).toList();
    prefs.setStringList('purchaseOrders', flatPurchaseOrders);
  }

  void removePurchaseOrder(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    purchaseOrders.removeAt(index);
    List<String> flatPurchaseOrders = purchaseOrders.map((data) {
      return data.join('|');
    }).toList();
    prefs.setStringList('purchaseOrders', flatPurchaseOrders);
  }

  @override
  void onInit() {
    super.onInit();
    _loadPurchaseOrders();
  }

  @override
  void onClose() {
    purchaseOrderController.dispose();
    totalItemController.dispose();
    super.onClose();
  }
}

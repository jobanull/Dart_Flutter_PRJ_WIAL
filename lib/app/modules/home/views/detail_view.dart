import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class PurchaseOrderDetailScreen extends StatefulWidget {
  final String purchaseOrder;
  final String totalItems;
  final String soId;

  PurchaseOrderDetailScreen(this.purchaseOrder, this.totalItems, this.soId);

  @override
  _PurchaseOrderDetailScreenState createState() =>
      _PurchaseOrderDetailScreenState();
}

class _PurchaseOrderDetailScreenState extends State<PurchaseOrderDetailScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  String qrText = '';

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  Future<Uint8List> buildPdf(PdfPageFormat format) async {
    // Create the Pdf document
    final pw.Document doc = pw.Document();

    // Add one page with centered text "Hello World"
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.ConstrainedBox(
            constraints: pw.BoxConstraints.expand(),
            child: pw.Column(
              children: [
                pw.SizedBox(
                  height: 100,
                ),
                pw.BarcodeWidget(
                    data: widget.soId,
                    color: PdfColor.fromHex("#000000"),
                    barcode: pw.Barcode.qrCode(),
                    width: 500,
                    height: 250),
              ],
            ),
          );
        },
      ),
    );

    // Build and return the final Pdf file data
    return await doc.save();
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });
    qrController.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
        if (qrText == widget.soId) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('QR Code Verification'),
              content: Text('QR Code matches Sales Order ID. It is TRUE.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('QR Code Verification'),
              content:
                  Text('QR Code does not match Sales Order ID. It is FALSE.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Order Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Purchase Order: ${widget.purchaseOrder}'),
            Text('Total Items: ${widget.totalItems}'),
            Text('SO ID: ${widget.soId}'),
            SizedBox(height: 20),
            Expanded(
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.green,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Printing.layoutPdf(onLayout: (PdfPageFormat format) {
            return buildPdf(format);
          });
        },
        child: Icon(Icons.picture_as_pdf),
      ),
    );
  }
}

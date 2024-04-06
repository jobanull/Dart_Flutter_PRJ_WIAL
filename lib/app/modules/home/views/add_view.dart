import 'package:flutter/material.dart';

class AddPurchaseOrderDialog extends StatefulWidget {
  @override
  _AddPurchaseOrderDialogState createState() => _AddPurchaseOrderDialogState();
}

class _AddPurchaseOrderDialogState extends State<AddPurchaseOrderDialog> {
  final TextEditingController _purchaseOrderController =
      TextEditingController();
  final TextEditingController _totalItemController = TextEditingController();

  String _generateSalesOrderID() {
    // Generate a unique sales order ID using current timestamp
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return 'SO_$timestamp';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Purchase Order'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _purchaseOrderController,
            decoration: InputDecoration(labelText: 'Purchase Order'),
          ),
          TextField(
            controller: _totalItemController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Total Items'),
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String purchaseOrder = _purchaseOrderController.text.trim();
            String totalItems = _totalItemController.text.trim();
            String soId = _generateSalesOrderID();
            Navigator.of(context).pop([purchaseOrder, totalItems, soId]);
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _purchaseOrderController.dispose();
    _totalItemController.dispose();
    super.dispose();
  }
}
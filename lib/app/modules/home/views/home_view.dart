import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wial/app/modules/home/views/detail_view.dart';

import '../controllers/home_controller.dart';
import 'add_view.dart';

class HomeView extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Order List'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.purchaseOrders.length,
            itemBuilder: (context, index) {
              String purchaseOrder = controller.purchaseOrders[index][0];
              String totalItems = controller.purchaseOrders[index][1];
              String soId = controller.purchaseOrders[index][2];
              return ListTile(
                title: Text(
                    'Purchase Order: $purchaseOrder\nTotal Items: $totalItems\nSO ID: $soId'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PurchaseOrderDetailScreen(
                        purchaseOrder,
                        totalItems,
                        soId,
                      ),
                    ),
                  );
                },
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<String> newPurchaseOrderData = await showDialog(
            context: context,
            builder: (context) => AddPurchaseOrderDialog(),
          );
          if (newPurchaseOrderData != null) {
            controller.addPurchaseOrder(newPurchaseOrderData);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

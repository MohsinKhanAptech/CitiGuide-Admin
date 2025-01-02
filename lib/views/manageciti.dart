// ignore_for_file: prefer_const_constructors

import 'package:citiguide_admin/controllers/Resturantcontroller.dart';
import 'package:citiguide_admin/controllers/addresturantcontroller.dart';
import 'package:citiguide_admin/controllers/hotelcontroller.dart';
import 'package:citiguide_admin/views/addResturant.dart';

import 'package:citiguide_admin/views/addhotel.dart';
import 'package:citiguide_admin/views/hotel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagecitiScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const ManagecitiScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final procontroller = Get.put(Resturantcontroller());
    final hprocontroller = Get.put(Hotelcontroller());

    // Fetch products when the screen is opened
    procontroller.fetchProducts(categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage City - $categoryName"),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          Obx(() {
            if (procontroller.products.isEmpty) {
              return const Center(child: Text("No data found."));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: procontroller.products.length,
              itemBuilder: (context, index) {
                var product = procontroller.products[index];
                var productId = product.id;
                var productData = product.data() as Map<String, dynamic>;

                return ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    child: Image(
                        image: NetworkImage(
                      productData['imageUrl'],
                    )),
                  ),
                  title: Text(productData['name']),
                  subtitle: Text("Price: \$${productData['price']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final newValues =
                              await showDialog<Map<String, dynamic>>(
                            context: context,
                            builder: (context) {
                              final nameController = TextEditingController(
                                  text: productData['name']);
                              final priceController = TextEditingController(
                                  text: productData['price'].toString());
                              return AlertDialog(
                                title: const Text("Edit Product"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: nameController,
                                      decoration: const InputDecoration(
                                        labelText: "Product Name",
                                      ),
                                    ),
                                    TextField(
                                      controller: priceController,
                                      decoration: const InputDecoration(
                                        labelText: "Product Price",
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final newName =
                                          nameController.text.trim();
                                      final newPrice = double.tryParse(
                                          priceController.text.trim());
                                      if (newName.isNotEmpty &&
                                          newPrice != null) {
                                        Navigator.pop(context, {
                                          'name': newName,
                                          'price': newPrice,
                                        });
                                      } else {
                                        Get.snackbar("Error",
                                            "Please provide valid details.");
                                      }
                                    },
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newValues != null) {
                            await procontroller.updateProduct(
                              categoryId,
                              productId,
                              newValues['name'],
                              newValues['price'],
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Product"),
                              content: const Text(
                                  "Are you sure you want to delete this product?"),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Delete"),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            await procontroller.deleteProduct(
                                categoryId, productId);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              //  var user = procontroller.userdata[index];
              Get.to(() => AddResturant(
                    mylist: categoryName,
                  ));
            },
            child: const Text("Add Resturant"),
          ),
          SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              //  var user = procontroller.userdata[index];
              Get.to(AddhotelScreen());
            },
            child: const Text("Add Hotel"),
          ),
        ],
      ),
    );
  }
}

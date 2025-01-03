// import 'package:ecomappadmin/controllers/categorycontroller.dart';
// import 'package:ecomappadmin/views/addcategoryscreen.dart';
// import 'package:ecomappadmin/views/addproductscree.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class DisplayCatScreen extends StatelessWidget {
//   const DisplayCatScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//       final homecon = Get.put(Categorycontroller());

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [

//             Obx(() {
//           if (homecon.isLoading.value == true) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (homecon.userdata.isEmpty) {
//             return const Text("There is no data");
//           }

//           return ListView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//               itemCount: homecon.userdata.length,
//               itemBuilder: (context, index) {
//                 var user = homecon.userdata[index];
//                 var docId = homecon.categories[index].id;
//                 // return InkWell(
//                 //   onTap: () {
//                 //     Get.to(() => AddProductScreen(
//                 //           list: user,
//                 //         ));
//                 //   },
//                 //   child: Container(
//                 //     height: 100,
//                 //     child: Card(
//                 //       child: Center(child: Text(user['name'])),
//                 //     ),
//                 //   ),
//                 // );

//                 return Row(
//                     children: [
//                       Text(user['name']),
//                       SizedBox(width: 10,),
//                 //       InkWell(
//                 //   onTap: () {
//                 //     Get.to(() => AddProductScreen(
//                 //           list: user,
//                 //         ));
//                 //   },
//                 //   child: Container(
//                 //     height: 100,
//                 //     child: Card(
//                 //       child: Center(child: Text("Add Product")),
//                 //     ),
//                 //   ),
//                 // ),

//                 ElevatedButton(onPressed: (){
//                    Get.to(() => AddProductScreen(
//                           list: user,
//                         ));
//                 }, child: Text("Add Product")),

//                     SizedBox(width: 10,),

//                     IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.green,)),

//                     SizedBox(width: 10,),

//                     IconButton(onPressed: () async {
//                                   await showDialog(
//                                     context: context,
//                                     builder: (context) => AlertDialog(
//                                       title: const Text("Delete Category"),
//                                       content: const Text("Are you sure you want to delete this category?"),
//                                       actions: [
//                                         TextButton(
//                                           onPressed: () => Navigator.pop(context, false),
//                                           child: const Text("Cancel"),
//                                         ),
//                                         TextButton(
//                                           onPressed: () => Navigator.pop(context, true),
//                                           child: const Text("Delete"),
//                                         ),
//                                       ],
//                                     ),
//                                   ).then((confirmed) async {
//                                     if (confirmed == true) {
//                                       await homecon.deleteCategory(docId);
//                                     }
//                                   });
//                                 },
//                                  icon: Icon(Icons.delete, color: Colors.red,)),

//                     ],
//                 );
//               });
//         }),

//         SizedBox(height: 50,),

//         ElevatedButton(onPressed: (){
//            Get.to(AddCategoryScreen());
//         }, child: Text("Create Category"))

//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:citiguide_admin/controllers/locationcontroller.dart';
import 'package:citiguide_admin/views/addlocationscreen.dart';
import 'package:citiguide_admin/views/manageciti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplaylocationScreen extends StatelessWidget {
  const DisplaylocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homecon = Get.put(mainscreencontroller());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (homecon.isLoading.value == true) {
                return const Center(child: CircularProgressIndicator());
              }
              if (homecon.userdata.isEmpty) {
                return const Text("There is no data");
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homecon.userdata.length,
                itemBuilder: (context, index) {
                  var user = homecon.userdata[index];
                  var docId = homecon.location[index].id;

                  return Row(
                    children: [
                      // Text(user['name']),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Get.to(() => AddProductScreen(
                          //       list: user,
                          //     ));

                          // Get.to(() => ManagecitiScreen(
                          //       categoryId: homecon
                          //           .location[index].id, // Pass the category ID
                          //       categoryName:
                          //           user['name'], // Pass the category name
                          //     ));
                        },
                        child: const Text("View City"),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.green),
                        onPressed: () async {
                          final newName = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              final controller =
                                  TextEditingController(text: user['name']);
                              return AlertDialog(
                                title: const Text("Edit Category"),
                                content: TextField(
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    hintText: "Enter new category name",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, controller.text),
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newName != null &&
                              newName.trim().isNotEmpty &&
                              newName != user['name']) {
                            await homecon.updateCategory(docId, newName.trim());
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Delete Category"),
                              content: const Text(
                                  "Are you sure you want to delete this category?"),
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
                            await homecon.deleteCategory(docId);
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  );
                },
              );
            }),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Get.to(AddlocationScreen());
              },
              child: const Text("Create City"),
            ),
          ],
        ),
      ),
    );
  }
}

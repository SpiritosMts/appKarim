import 'package:flutter/material.dart';
import 'package:gajgaji/_manager/bindings.dart';
import 'package:gajgaji/_manager/myVoids.dart';
import 'package:gajgaji/_models/product.dart';
import 'package:gajgaji/products/productsCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../_manager/firebaseVoids.dart';
import '../_manager/myLocale/myLocaleCtr.dart';
import '../_manager/myUi.dart';
import '../_manager/styles.dart';
import '../x_printPdfProducts/app-prod.dart';

//########################################################################
//########################################################################

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'.tr),
        bottom: appBarUnderline(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              Get.to(()=>PrintScreenProds());
            },
          ),
        ],
      ),

      body: GetBuilder<ProductsCtr>(
          initState: (_) {},
          dispose: (_) {},
          builder: (context) {
            return FutureBuilder<List<Product>>(
              future: getAlldocsModelsFromFb<Product>(productsColl, (json) => Product.fromJson(json)),
              builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Product> products = snapshot.data!;
                  prdCtr.productsList = products;
                  print('## productsList (${prdCtr.productsList.length}) updated ');

                  return (products.isNotEmpty)
                      ?  ListView.builder(
                    //physics: const NeverScrollableScrollPhysics(),
                    //itemExtent: 180,
                      padding: const EdgeInsets.only(top: 5,bottom:60, right: 15, left: 15,),
                      shrinkWrap: true,
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        Product prd = (products[index]);
                        return productCard(prd);
                      })

                    : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text('no products added yet'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.indieFlower(
                                  textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700),
                                )),
                          ),
                        );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  print('## loading snapshot ...');

                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white70),
                  );
                } else if (snapshot.hasError) {
                  print('## error(futureBuilder): ${snapshot.error}');
                  //String errorLocation = StackTrace.current.toString(); // Get the current stack trace
                  //print('## error location: $errorLocation'); // Log the error location
                  throw snapshot.error!; // Throw the error

                  return Center(
                    child: Text(
                      snapshotErrorMsg,
                      style: const TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "no data".tr,
                      style: const TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  );
                }
              },
            );
          }),

      /// add new prd
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: customFAB(
        text: 'New Product'.tr,
        onPressed: () {
          showAnimDialog(prdCtr.addProductDialog(isAdd: true));

        },
      ),
    );
  }
}


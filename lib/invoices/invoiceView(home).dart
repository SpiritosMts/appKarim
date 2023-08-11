import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:gajgaji/_manager/myUi.dart';
import 'package:gajgaji/_models/invoice.dart';
import 'package:gajgaji/invoices/addEditInvoice.dart';
import 'package:gajgaji/invoices/invoiceCtr.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../_manager/auth/profile_manage/settings.dart';
import '../_manager/bindings.dart';
import '../_manager/myVoids.dart';
import '../_manager/styles.dart';
import '../clients/clientssView.dart';
import '../graphs/graphsView.dart';
import '../products/productsView.dart';
import '../workers/workersView.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  @override
  void initState() {
    super.initState();
    //_advancedDrawerController.showDrawer();
  }
  //#################################################################"
  //#################################################################"*

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      openRatio: kIsWeb ? 0.25 : 0.7,
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 30.0,
                    bottom: 24.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/factory.png',
                  ),
                ),
                appNameText(),
                SizedBox(height: 8.h),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                  },
                  leading: Icon(Icons.description_rounded),
                  title: Text('Invoices'.tr), //invoices
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    Get.to(() => ProductsView());
                  },
                  leading: Icon(Icons.shopping_cart),
                  title: Text('Products'.tr),
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    Get.to(() => WorkersView());
                  },
                  leading: Icon(Icons.groups),
                  title: Text('Workers'.tr),
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    Get.to(() => ClientsView());
                  },
                  leading: Icon(Icons.group),
                  title: Text('Clients'.tr),
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    Get.to(() => GraphsView());
                  },
                  leading: Icon(Icons.ssid_chart),
                  title: Text('graphic study'.tr),
                ),
                ListTile(
                  onTap: () {
                    _advancedDrawerController.hideDrawer();
                    //Get.to(()=>Settings());
                    showLanguageDialog();
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Change Language'.tr),
                ),
                ListTile(
                  onTap: () {

                  },
                  leading: Icon(Icons.attach_money),
                  title:  GetBuilder<InvoicesCtr>(
                      id: 'societyCash',
                    builder: (ctr) {
                      return Text('${'Treasury'.tr}: ${formatNumberAfterComma2(invCtr.societyCash)}');
                    }
                  ),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text(''),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        // NOTICE: Uncomment if you want to add shadow behind the page.
        // Keep in mind that it may cause animation jerks.
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 0.0,
          ),
        ],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),

      child: Scaffold(
        appBar: AppBar(
          bottom: appBarUnderline(),
          title:  Text('Invoices'.tr),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: backGroundTemplate(
          child: GetBuilder<InvoicesCtr>(builder: (context) {
            return FutureBuilder<List<Invoice>>(
              future: getAlldocsModelsFromFb<Invoice>(invoicesColl, (json) => Invoice.fromJson(json)),
              builder: (BuildContext context, AsyncSnapshot<List<Invoice>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Invoice> invoices = snapshot.data!;
                  print('## invoicesList (ctr) updated');

                  DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');

                  invoices.sort((a, b) {
                    DateTime timeA = dateFormat.parse(a.timeReturn!);
                    DateTime timeB = dateFormat.parse(b.timeReturn!);
                    return timeB.compareTo(timeA);
                  });

                  invCtr.refreshAllInvoices(invoices);

                  return (invoices.isNotEmpty)
                      ? ListView.builder(
                          //physics: const NeverScrollableScrollPhysics(),

                          //itemExtent: 180,

                          reverse: false,
                          padding: const EdgeInsets.only(top: 5,bottom:60, right: 15, left: 15,),
                          shrinkWrap: true,
                          itemCount: invoices.length,
                          itemBuilder: (BuildContext context, int index) {
                            Invoice inv = (invoices[index]);
                            return invoiceCard(inv,index);
                          })
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Text('no invoices added yet'.tr,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.indieFlower(
                                  textStyle: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.w700),
                                )),
                          ),
                        );
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  print('## loading invoices ...');

                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white70),
                  );
                } else if (snapshot.hasError) {
                  print('## error: ${snapshot.error.toString()}');
                  return Center(
                    child: Text(
                      snapshotErrorMsg,
                      style: const TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      "no invoices added".tr,
                      style: const TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                  );
                }
              },
            );
          }),
        ),

        /// add new invoice
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: customFAB(
          text: 'New Invoice'.tr,
          onPressed: () {
            invCtr.showTypeDialog();
            //removeField();
            //addChangedTotalField();
          },
        ),

      ),
    );
  }
}

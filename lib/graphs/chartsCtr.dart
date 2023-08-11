

import 'package:get/get.dart';

import '../_models/client.dart';

class ChartsCtr extends GetxController {


  @override
  onInit() {
    super.onInit();
    //print('## init HomeCtr');
    Future.delayed(const Duration(milliseconds: 50), () {
      // downloadStoresFromDb().whenComplete(()async {
      //   //stNearbyMarkers = await loadNearbyMarkers(stMarkers, selectedProduct, sliderVal);// after download stores data
      // });
    });
  }

  @override
  void onClose() {
    super.onClose();
  }



}

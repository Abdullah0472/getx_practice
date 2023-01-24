import 'package:get/get.dart';
class HomeScreenController extends GetxController{

 // var count = 0.obs;
  RxInt count = 0.obs;

  increment(){
    count(++count.value+1);

  }

}
import 'package:get/get.dart';

import '../view model/task_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskController());
  }
}

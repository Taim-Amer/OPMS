import 'package:get/get.dart';
import 'package:opms/utils/router/app_router.dart';

class BreadcrumbController extends GetxController {
  final RxList<String> titles = <String>[].obs;

  // دالة مساعدة لإضافة عناوين حسب المسار
  void addTitleForRoute(String routeName) {
    final title = _getTitleForRoute(routeName);
    if (title != null) titles.add(title);
  }

  String? _getTitleForRoute(String routeName) {
    switch (routeName) {
      case AppRoutes.kLogin:
        return 'Login';
      case AppRoutes.kSidebar:
        return 'Main';
      case AppRoutes.kDepartments:
        return 'Departments';
      case AppRoutes.kProjects:
        return 'Projects & Units';
      case AppRoutes.kOutputs:
        return 'Outputs';
      case AppRoutes.kOutcome:
        return 'Outcomes';
      case AppRoutes.kIndicator:
        return 'Indicators';
      case AppRoutes.kActivities:
        return 'Activities';
      default:
        return null;
    }
  }

  void setTitle({required String title}){
    removeTitle();
    addTitle(title);
  }

  // الانتقال مع إضافة عنوان (بدون إدارة التنقل)
  void addTitle(String title) {
    titles.add(title);
  }

  // إزالة العنوان  (بدون إدارة التنقل)
  void removeTitle() {
    if (titles.isNotEmpty) {
      titles.removeLast();
    }
  }

  // الانتقال مع إضافة عنوان وإدارة التنقل
  void navigateTo(String routeName, String pageTitle) {
    titles.add(pageTitle);
    Get.toNamed(routeName);
  }

  // إعادة تعيين العناوين
  void resetTitles() {
    titles.clear();
  }
}
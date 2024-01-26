import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:guarani_poke_test/src/pages/modules/favorite/views/favorite_view.dart';
import 'package:guarani_poke_test/src/pages/modules/home/views/home_view.dart';
import 'package:guarani_poke_test/src/pages/modules/main_screen/controllers/layout_controller.dart';
import 'package:guarani_poke_test/src/pages/modules/perfil/views/perfil_view.dart';
import 'package:guarani_poke_test/src/widgets/bottom_navigation_bar/custom_bottom_navigation_bar.dart';

class MainScreenView extends GetView<LayoutController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavigationBar(
          controller: controller,
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (controller.currentIndex.value) {
      case 0:
        return const HomeView();
      case 1:
        return FavoriteView();
      case 2:
        return PerfilView();
      default:
        return const SizedBox.shrink();
    }
  }
}

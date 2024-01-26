import 'package:flutter/material.dart';
import 'package:guarani_poke_test/src/core/base/colors.dart';
import 'package:guarani_poke_test/src/core/base/images.dart';
import 'package:guarani_poke_test/src/pages/modules/main_screen/controllers/layout_controller.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final LayoutController controller;
  const CustomBottomNavigationBar({super.key, required this.controller});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildNavItem(Images.homeTab, 'Home', 0),
          _buildNavItem(Images.favoriteTab, 'Favoritos', 1),
          _buildNavItem(Images.profileTab, 'Perfil', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, int index) {
    return TextButton(
      onPressed: () => widget.controller.currentIndex.value = index,
      style: TextButton.styleFrom(
        foregroundColor: CustomColors.primaryColor,
      ),
      child: Column(
        children: <Widget>[
          Image.asset(
            icon,
            width: 42,
            height: 42,
            color: widget.controller.currentIndex.value == index
                ? CustomColors.redPokemon
                : CustomColors.defaultColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: widget.controller.currentIndex.value == index
                  ? CustomColors.redPokemon
                  : CustomColors.defaultColor,
            ),
          ),
        ],
      ),
    );
  }
}

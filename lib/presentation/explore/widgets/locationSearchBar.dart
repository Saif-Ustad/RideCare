import 'package:flutter/material.dart';

import '../../../core/configs/theme/app_colors.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 15,
      right: 15,
      child: Row(
        children: [
          Expanded(child: _searchBox()),
          SizedBox(width: 10),
          _filterIcon(),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 40,
      decoration: _boxDecoration(),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        style: _textStyle(),
        decoration: InputDecoration(
          hintText: "Search location",
          hintStyle: _hintTextStyle(),
          prefixIcon: Icon(Icons.location_on, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10, bottom: 10),
        ),
      ),
    );
  }

  Widget _filterIcon() {
    return Container(
      height: 40,
      width: 40,
      decoration: _boxDecoration(),
      child: IconButton(
        icon: Icon(Icons.filter_list, color: AppColors.primary),
        onPressed: () {},
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 5,
          spreadRadius: 1,
        ),
      ],
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      color: AppColors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  TextStyle _hintTextStyle() {
    return TextStyle(
      color: AppColors.grey,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    );
  }

}


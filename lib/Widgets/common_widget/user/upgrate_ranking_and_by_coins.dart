import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../../ViewModel/get_data_view_model.dart';
import '../show_bottom/show_bottom_by_coins.dart';
import '../show_bottom/show_bottom_upgrate_rank.dart';

class UpgradeAndBuyCoinsCard extends StatefulWidget {
  final RxMap<dynamic, dynamic> userData;

  const UpgradeAndBuyCoinsCard({Key? key, required this.userData}) : super(key: key);

  @override
  State<UpgradeAndBuyCoinsCard> createState() => _UpgradeAndBuyCoinsCardState();
}

class _UpgradeAndBuyCoinsCardState extends State<UpgradeAndBuyCoinsCard> {
  final controllerGetData = Get.put(GetDataViewModel());
  @override
  Widget build(BuildContext context) {
    return widget.userData.isNotEmpty
        ? Card(
      color: const Color(0xFF1E1E1E), // Màu nền tối
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: widget.userData['ranking'] == 'Normal' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (widget.userData['ranking'] == 'Normal')
              InkWell(
                onTap:(){
                  showBottomUpgrateRank(context);
                },
                child: _buildButton(
                  text: 'Nâng cấp tài khoản',
                  color: const Color(0xFF3B6790), // Xanh dương
                ),
              ),
            InkWell(
              onTap: (){
                showBottomByCoints(context);
              },
              child: _buildButton(
                text: 'Nạp ví',
                color: const Color(0xFFEB5B00), // Cam ánh kim
              ),
            ),
          ],
        ),
      ),
    )
        : const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildButton({required String text, required Color color}) {
    return Container(
      width: text == 'Nâng cấp tài khoản' ? 170 : 120,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'PlusJakartaSans'
          ),
        ),
      ),
    );
  }
}

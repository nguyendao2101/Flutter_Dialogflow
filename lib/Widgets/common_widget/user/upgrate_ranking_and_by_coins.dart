import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UpgradeAndBuyCoinsCard extends StatelessWidget {
  final RxMap<dynamic, dynamic> userData;

  const UpgradeAndBuyCoinsCard({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userData.isNotEmpty
        ? Card(
      color: Color(0xFF1E1E1E), // Màu nền tối
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: userData['ranking'] == 'Normal' ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (userData['ranking'] == 'Normal')
              _buildButton(
                text: 'Nâng cấp tài khoản',
                color: Color(0xFF3B6790), // Xanh dương
              ),
            _buildButton(
              text: 'Nạp ví',
              color: Color(0xFFEB5B00), // Cam ánh kim
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
      width: text == 'Nâng cấp tài khoản' ? 160 : 120,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../images/image_extention.dart';
import '../basic_app_button/basic_app_button.dart';

void showPaymentMethod(BuildContext context) {
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.grey.withOpacity(0.8),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.8,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Payment Confirmation',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'PlusJakartaSans',
                    color: Color(0xff32343E),
                  ),
                ),
                const SizedBox(height: 20),
                // if (selectedPaymentMethod.value?['id'] == '1')
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      // Add a check icon for visual confirmation
                      const SizedBox(height: 24),
                      Image.asset(ImageAssest.check, height: 128,),
                      const SizedBox(height: 64),

                      const Text(
                        'Your order has been confirmed by HungryHub.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      BasicAppButton(
                        onPressed:(){
                          Navigator.pop(context);
                        }
                        , title: '', sizeTitle: 18,
                        height: 44,
                        colorButton: const Color(0xffA31D1D),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
    },
  );
}

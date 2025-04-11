import 'package:app_agendamento_manicure/ui/pages/utils/core/core.dart';
import 'package:flutter/material.dart';

class PixPage extends StatefulWidget {
  const PixPage({super.key});

  @override
  State<PixPage> createState() => _PixPageState();
}

class _PixPageState extends State<PixPage> {
  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
        ),
        padding: EdgeInsets.all(2),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
                'assets/images/pix_lolo.jpg',
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),
            Positioned(
              top: width / 11,
              right: width / 11,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnnouncementContainer extends StatelessWidget {
  const AnnouncementContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 118,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 18,
              offset: Offset(0, 0),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 108,
              height: 98,
              decoration: ShapeDecoration(
                image: const DecorationImage(
                  image: AssetImage('Assets/defaul.png'),
                  fit: BoxFit.fill,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 173,
                        child: Text(
                          'Apple iPad Pro 12.9" (2020) 256GB Wi-Fi Space Grey',
                          style: TextStyle(
                            color: Color(0xFF313131),
                            fontSize: 12,
                            fontFamily: 'SF Pro Display',
                            fontWeight: FontWeight.w600,

                          ),
                        ),
                      ),
                      SvgPicture.asset('Assets/icons/follow_2.svg', width: 24)
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Text(
                    'Le Vendeur John E.',
                    style: TextStyle(
                      color: Color(0xFF9B9FAA),
                      fontSize: 12,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        '18 500 DZD',
                        style: TextStyle(
                          color: Color(0xFFED5434),
                          fontSize: 16,
                          fontFamily: 'SF Pro Display',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

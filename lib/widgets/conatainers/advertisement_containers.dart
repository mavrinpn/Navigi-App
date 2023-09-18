import 'package:flutter/material.dart.';

class  AdvertisementContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String imageUrl;
  const AdvertisementContainer(
    {super.key,
    required this.onTap,
    required this.imageUrl,
  });


  @override
  Widget build(BuildContext context) {

    return  Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width-15,
            height: 88,
            decoration: ShapeDecoration(
              image:  DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
  }


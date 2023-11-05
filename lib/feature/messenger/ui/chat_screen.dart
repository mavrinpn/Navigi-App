import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/utils/colors.dart';
import 'package:smart/utils/fonts.dart';
import 'package:smart/widgets/messenger/message_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.mainBackground,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              focusColor: AppColors.empty,
              hoverColor: AppColors.empty,
              highlightColor: AppColors.empty,
              splashColor: AppColors.empty,
              onTap: () {
                Navigator.pop(context);
              },
              child: const SizedBox(
                width: 35,
                height: 48,
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.black,
                ),
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://cs14.pikabu.ru/post_img/big/2023/02/13/8/1676296367166243426.png'),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'John E.',
              style: AppTypography.font12lightGray,
            ),
            Container(
              alignment: Alignment.topCenter,
              height: 16,
              child: SvgPicture.asset('Assets/icons/online_circle.svg'),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                height: 75,
                color: Colors.red,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      return MessengerContainer(text: 'asdasssdfjhkasdjhkfhjkfjsaidhkdasd', isCurrentUser: false,);
                    },
                    itemCount: 3,
                    reverse: true),
              ),
            ),
            Container(
              height: 64,
              width: MediaQuery.sizeOf(context).width,
              color: AppColors.backgroundLightGray,
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(
                      'Assets/icons/attach.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 260,
                    child: TextField(
                      controller: messageController,
                      onChanged: (s) {
                        setState(() {});
                      },
                      cursorColor: AppColors.red,
                      cursorWidth: 1,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(12, 4, 12, 4),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: AppColors.whiteGray)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: AppColors.whiteGray)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: AppColors.whiteGray)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: AppColors.whiteGray)),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                          color: messageController.text.isNotEmpty
                              ? AppColors.red
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                      width: 40,
                      height: 40,
                      child: SvgPicture.asset(
                        'Assets/icons/send.svg',
                        width: 20,
                        height: 20,
                        color: messageController.text.isNotEmpty
                            ? Colors.white
                            : AppColors.darkGrey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

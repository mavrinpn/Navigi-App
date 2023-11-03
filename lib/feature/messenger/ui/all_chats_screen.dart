import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart/widgets/messenger/chat_container.dart';

class MessengerMainScreen extends StatefulWidget {
  const MessengerMainScreen({super.key});

  @override
  State<MessengerMainScreen> createState() => _MessengerMainScreenState();
}

class _MessengerMainScreenState extends State<MessengerMainScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.mainBackground,
        elevation: 0,
        title: Text(localizations.messages, style: AppTypography.font20black),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 40,
            collapsedHeight: 40,
            toolbarHeight: 40,
            floating: true,
            title: SizedBox(
              height: 44,
              width: double.infinity,
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SvgPicture.asset('Assets/icons/search_simple.svg',
                          width: 22),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(maxWidth: 50, maxHeight: 22),
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: const Color(0xffF4F5F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        gapPadding: 0,
                        borderSide: BorderSide.none)),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 16,
            ),
          )
        ]..addAll([
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                sliver: SliverToBoxAdapter(
                  child: ChatContainer(
                    userOnline: true,
                    chatImageUrl: 'https://static.life.ru/publications/2021/2/10/1332649499201.808.jpg',
                    otherUser: 'John E.',
                    announcementName: 'Apple iPad Pro 12.9" (2020) 256GB Wi-Fi',
                    message: Message.fish(owned_: true, read: DateTime.now()),
                  ),
                )),
            SliverPadding(
                padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                sliver: SliverToBoxAdapter(
                  child: ChatContainer(
                    userOnline: false,
                    chatImageUrl: 'https://static.life.ru/publications/2021/2/10/1332649499201.808.jpg',
                    otherUser: 'John E.',
                    announcementName: 'Apple iPad Pro 12.9" (2020) 256GB Wi-Fi',
                    message: Message.fish(owned_: false),
                  ),
                )),
          ]),
      ),
    );
  }
}
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart/feature/messenger/data/messenger_repository.dart';
import 'package:smart/localization/app_localizations.dart';
import 'package:smart/models/messenger/room.dart';
import 'package:smart/utils/utils.dart';
import 'package:smart/feature/messenger/ui/widgets/chat_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final messengerRepository = RepositoryProvider.of<MessengerRepository>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.appBarColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(localizations.messages, style: AppTypography.font20black),
      ),
      body: StreamBuilder<List<Room>>(
          stream: messengerRepository.chatsStream.stream,
          initialData: const [],
          builder: (context, snapshot) {
            return RefreshIndicator(
              color: AppColors.red,
              onRefresh: () async {
                messengerRepository.preloadChats();
                messengerRepository.refreshSubscription();
              },
              child: CustomScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 68,
                    collapsedHeight: 68,
                    toolbarHeight: 68,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    floating: true,
                    title: SizedBox(
                      height: 68,
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          height: 44,
                          child: TextField(
                            controller: searchController,
                            onChanged: (v) {
                              messengerRepository.searchChat(searchController.text);
                            },
                            decoration: InputDecoration(
                              hintText: localizations.searchInMessages,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SvgPicture.asset('Assets/icons/search_simple.svg', width: 22),
                              ),
                              prefixIconConstraints: const BoxConstraints(maxWidth: 50, maxHeight: 22),
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: const Color(0xffF4F5F6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), gapPadding: 0, borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  ...List.generate(
                    snapshot.data!.length,
                    (index) => ChatContainer.fromRoom(snapshot.data![index]),
                  )
                ],
              ),
            );
          }),
    );
  }
}

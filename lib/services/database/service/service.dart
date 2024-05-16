part of '../database_service.dart';

class DatabaseService {
  final Databases _databases;

  final Functions _functions;
  final Storage _storage;
  final Realtime _realtime;
  final Account _account;

  late final CategoriesService categories;
  late final AnnouncementsService announcements;
  late final FavouritesService favourites;
  late final UserService users;
  late final MessagesService messages;
  late final NotificationsDatabaseService notifications;
  late final ReviewsService reviews;
  late final KeyWordsService keyWords;
  late final TipWordsService tipWords;
  late final ModelsService models;
  late final MediumPriceService mediumPrices;
  late final BlockedUsersService blockedUsers;

  DatabaseService({required Client client})
      : _databases = Databases(client),
        _functions = Functions(client),
        _realtime = Realtime(client),
        _account = Account(client),
        _storage = Storage(client) {
    categories = CategoriesService(_databases);
    notifications = NotificationsDatabaseService(_databases);
    users = UserService(_databases, _functions, _account);
    announcements = AnnouncementsService(_databases, _storage);
    reviews = ReviewsService(_databases, _storage, _functions, _account);
    mediumPrices = MediumPriceService(_databases);
    keyWords = KeyWordsService(_databases);
    tipWords = TipWordsService(_databases);
    models = ModelsService(_databases);
    blockedUsers = BlockedUsersService(_databases);
    favourites = FavouritesService(_databases, _storage);
    messages = MessagesService(_databases, _realtime, _functions, _storage, users, _account);
  }
}

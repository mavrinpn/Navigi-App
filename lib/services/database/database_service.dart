import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:smart/models/announcement.dart';
import 'package:smart/models/announcement_creating_data.dart';
import 'package:smart/models/category.dart';
import 'package:smart/models/item/item.dart';
import 'package:smart/models/messenger/message.dart';
import 'package:smart/models/sort_types.dart';
import 'package:smart/models/subcategory.dart';
import 'package:smart/models/user.dart';

import '../../models/messenger/room.dart';
import '../../utils/constants.dart';

part 'service/categories.dart';

part 'service/contstants.dart';

part 'service/announcements.dart';

part 'service/favourites.dart';

part 'service/messages.dart';

part 'service/functions.dart';

part 'service/user.dart';

part 'service/notifications.dart';

part 'service/service.dart';

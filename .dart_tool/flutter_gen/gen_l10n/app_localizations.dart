import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @addAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'Add announcement'**
  String get addAnnouncement;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @dontHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccount;

  /// No description provided for @enterThePassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the password'**
  String get enterThePassword;

  /// No description provided for @forgotThePassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot the password?'**
  String get forgotThePassword;

  /// No description provided for @enterThePhoneNumberAssociatedWithYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number associated with your account'**
  String get enterThePhoneNumberAssociatedWithYourAccount;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enterVerificationCode;

  /// No description provided for @didntReceiveTheCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get didntReceiveTheCode;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @enterTheEmailAddressAssociatedWithYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with your account'**
  String get enterTheEmailAddressAssociatedWithYourAccount;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @realEstate.
  ///
  /// In en, this message translates to:
  /// **'Real estate'**
  String get realEstate;

  /// No description provided for @electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronics;

  /// No description provided for @homeAppliance.
  ///
  /// In en, this message translates to:
  /// **'Home appliance'**
  String get homeAppliance;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @accessoriesAndRepairs.
  ///
  /// In en, this message translates to:
  /// **'Accessories and Repairs'**
  String get accessoriesAndRepairs;

  /// No description provided for @clothes.
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get clothes;

  /// No description provided for @homeAndLeisure.
  ///
  /// In en, this message translates to:
  /// **'Home and leisure'**
  String get homeAndLeisure;

  /// No description provided for @animals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animals;

  /// No description provided for @jobsAndServices.
  ///
  /// In en, this message translates to:
  /// **'Jobs and services'**
  String get jobsAndServices;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'home page'**
  String get homePage;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @trademarkSearch.
  ///
  /// In en, this message translates to:
  /// **'Trademark search'**
  String get trademarkSearch;

  /// No description provided for @jobs.
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get jobs;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @lookingForEmployees.
  ///
  /// In en, this message translates to:
  /// **'Looking for employees'**
  String get lookingForEmployees;

  /// No description provided for @workplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get workplace;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @localisation.
  ///
  /// In en, this message translates to:
  /// **'Localisation'**
  String get localisation;

  /// No description provided for @searchArea.
  ///
  /// In en, this message translates to:
  /// **'Search area'**
  String get searchArea;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @driver.
  ///
  /// In en, this message translates to:
  /// **'driver'**
  String get driver;

  /// No description provided for @dZDmonth.
  ///
  /// In en, this message translates to:
  /// **'DZD/month'**
  String get dZDmonth;

  /// No description provided for @withPicture.
  ///
  /// In en, this message translates to:
  /// **'With picture'**
  String get withPicture;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'sort'**
  String get sort;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'sort by'**
  String get sortBy;

  /// No description provided for @onlyAHighRanking.
  ///
  /// In en, this message translates to:
  /// **'Only a high ranking'**
  String get onlyAHighRanking;

  /// No description provided for @onlyWithReduction.
  ///
  /// In en, this message translates to:
  /// **'Only with reduction'**
  String get onlyWithReduction;

  /// No description provided for @random.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get random;

  /// No description provided for @ascendingPrice.
  ///
  /// In en, this message translates to:
  /// **'Ascending price'**
  String get ascendingPrice;

  /// No description provided for @decreasingPrice.
  ///
  /// In en, this message translates to:
  /// **'Decreasing price'**
  String get decreasingPrice;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @theMerie.
  ///
  /// In en, this message translates to:
  /// **'The merie'**
  String get theMerie;

  /// No description provided for @show1000Ads.
  ///
  /// In en, this message translates to:
  /// **'Show 1000 ads'**
  String get show1000Ads;

  /// No description provided for @searchInAlgiers.
  ///
  /// In en, this message translates to:
  /// **'Search in Algiers'**
  String get searchInAlgiers;

  /// No description provided for @todayAt1825.
  ///
  /// In en, this message translates to:
  /// **'Today at 18:25'**
  String get todayAt1825;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get views;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @makeAnOffer.
  ///
  /// In en, this message translates to:
  /// **'Make an offer'**
  String get makeAnOffer;

  /// No description provided for @typeOfProduct.
  ///
  /// In en, this message translates to:
  /// **'Type of product'**
  String get typeOfProduct;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @operatingSystem.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get operatingSystem;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'condition'**
  String get condition;

  /// No description provided for @diagonal.
  ///
  /// In en, this message translates to:
  /// **'Diagonal'**
  String get diagonal;

  /// No description provided for @touch.
  ///
  /// In en, this message translates to:
  /// **'touch'**
  String get touch;

  /// No description provided for @builtinMemory.
  ///
  /// In en, this message translates to:
  /// **'Built-in memory'**
  String get builtinMemory;

  /// No description provided for @wiFi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get wiFi;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @tablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get tablet;

  /// No description provided for @electronic.
  ///
  /// In en, this message translates to:
  /// **'Electronic'**
  String get electronic;

  /// No description provided for @veryGood.
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get veryGood;

  /// No description provided for @megapixels.
  ///
  /// In en, this message translates to:
  /// **'megapixels'**
  String get megapixels;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @relatedAds.
  ///
  /// In en, this message translates to:
  /// **'Related Ads'**
  String get relatedAds;

  /// No description provided for @block.
  ///
  /// In en, this message translates to:
  /// **'block'**
  String get block;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @articleAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Article added to favorites!'**
  String get articleAddedToFavorites;

  /// No description provided for @offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get offer;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @onSale.
  ///
  /// In en, this message translates to:
  /// **'On sale'**
  String get onSale;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @theDealIsDone.
  ///
  /// In en, this message translates to:
  /// **'The deal is done'**
  String get theDealIsDone;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @writeAComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get writeAComment;

  /// No description provided for @whatDidYouTalkAbout.
  ///
  /// In en, this message translates to:
  /// **'What did you talk about?'**
  String get whatDidYouTalkAbout;

  /// No description provided for @didYouPurchaseTheItem.
  ///
  /// In en, this message translates to:
  /// **'Did you purchase the item?'**
  String get didYouPurchaseTheItem;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @meeting.
  ///
  /// In en, this message translates to:
  /// **'Meeting'**
  String get meeting;

  /// No description provided for @datingConvention.
  ///
  /// In en, this message translates to:
  /// **'dating convention'**
  String get datingConvention;

  /// No description provided for @communicationByPhone.
  ///
  /// In en, this message translates to:
  /// **'Communication by phone'**
  String get communicationByPhone;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @noFavoritesAtTheMoment.
  ///
  /// In en, this message translates to:
  /// **'No favorites at the moment.'**
  String get noFavoritesAtTheMoment;

  /// No description provided for @addArticlesToYourFavoritesToFindThemHere.
  ///
  /// In en, this message translates to:
  /// **'Add articles to your favorites to find them here.'**
  String get addArticlesToYourFavoritesToFindThemHere;

  /// No description provided for @juin.
  ///
  /// In en, this message translates to:
  /// **'juin'**
  String get juin;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @youHaveNoAds.
  ///
  /// In en, this message translates to:
  /// **'You have no ads'**
  String get youHaveNoAds;

  /// No description provided for @addAnAd.
  ///
  /// In en, this message translates to:
  /// **'Add an ad'**
  String get addAnAd;

  /// No description provided for @balanceGeneratedBySales.
  ///
  /// In en, this message translates to:
  /// **'Balance generated by sales'**
  String get balanceGeneratedBySales;

  /// No description provided for @myInformations.
  ///
  /// In en, this message translates to:
  /// **'My informations'**
  String get myInformations;

  /// No description provided for @myComments.
  ///
  /// In en, this message translates to:
  /// **'My comments'**
  String get myComments;

  /// No description provided for @fAQ.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get fAQ;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get termsOfUse;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @deleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteMyAccount;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App settings'**
  String get appSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @personalOffers.
  ///
  /// In en, this message translates to:
  /// **'Personal offers'**
  String get personalOffers;

  /// No description provided for @selectedAds.
  ///
  /// In en, this message translates to:
  /// **'Selected ads'**
  String get selectedAds;

  /// No description provided for @accountCertification.
  ///
  /// In en, this message translates to:
  /// **'Account certification'**
  String get accountCertification;

  /// No description provided for @takeAPictureOfYourselfHoldingAnIDCardNextToYourFaceLikeTheExampleBelow.
  ///
  /// In en, this message translates to:
  /// **'Take a picture of yourself holding an ID card next to your face, like the example below.'**
  String get takeAPictureOfYourselfHoldingAnIDCardNextToYourFaceLikeTheExampleBelow;

  /// No description provided for @uploadThePhotoInPNGOrJPEGFormatFromYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Upload the photo in PNG or JPEG format from your device.'**
  String get uploadThePhotoInPNGOrJPEGFormatFromYourDevice;

  /// No description provided for @addPictures.
  ///
  /// In en, this message translates to:
  /// **'Add pictures'**
  String get addPictures;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalViews.
  ///
  /// In en, this message translates to:
  /// **'Total views'**
  String get totalViews;

  /// No description provided for @viewingRate.
  ///
  /// In en, this message translates to:
  /// **'Viewing rate'**
  String get viewingRate;

  /// No description provided for @numberOfFavorites.
  ///
  /// In en, this message translates to:
  /// **'Number of favorites'**
  String get numberOfFavorites;

  /// No description provided for @numberOfInteractions.
  ///
  /// In en, this message translates to:
  /// **'Number of interactions'**
  String get numberOfInteractions;

  /// No description provided for @onModeration.
  ///
  /// In en, this message translates to:
  /// **'On moderation'**
  String get onModeration;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @writeToUs.
  ///
  /// In en, this message translates to:
  /// **'write to us'**
  String get writeToUs;

  /// No description provided for @areYouSureYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout'**
  String get areYouSureYouWantToLogout;

  /// No description provided for @byLoggingOutYouWillNoLongerBeAbleToViewYourFavoriteAdsReceiveNotificationsFromPotentialCustomersOrSellersOrAccessCertainFeaturesReservedForLoggedinUsers.
  ///
  /// In en, this message translates to:
  /// **'By logging out, you will no longer be able to view your favorite ads, receive notifications from potential customers or sellers, or access certain features reserved for logged-in users.'**
  String get byLoggingOutYouWillNoLongerBeAbleToViewYourFavoriteAdsReceiveNotificationsFromPotentialCustomersOrSellersOrAccessCertainFeaturesReservedForLoggedinUsers;

  /// No description provided for @enterTheNameOfYourItem.
  ///
  /// In en, this message translates to:
  /// **'Enter the name of your item'**
  String get enterTheNameOfYourItem;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @adType.
  ///
  /// In en, this message translates to:
  /// **'Ad Type'**
  String get adType;

  /// No description provided for @nEw.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get nEw;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get black;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get white;

  /// No description provided for @roseGold.
  ///
  /// In en, this message translates to:
  /// **'Rose gold'**
  String get roseGold;

  /// No description provided for @spaceGray.
  ///
  /// In en, this message translates to:
  /// **'space gray'**
  String get spaceGray;

  /// No description provided for @publishTheAd.
  ///
  /// In en, this message translates to:
  /// **'Publish the ad'**
  String get publishTheAd;

  /// No description provided for @yourAdIsBeingChecked.
  ///
  /// In en, this message translates to:
  /// **'Your ad is being checked'**
  String get yourAdIsBeingChecked;

  /// No description provided for @pleaseDoNotLeaveTheAppWhileWeAreProcessingYourAd.
  ///
  /// In en, this message translates to:
  /// **'Please do not leave the app while we are processing your ad.'**
  String get pleaseDoNotLeaveTheAppWhileWeAreProcessingYourAd;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @offrirVotrePrix.
  ///
  /// In en, this message translates to:
  /// **'Offer your price'**
  String get offrirVotrePrix;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

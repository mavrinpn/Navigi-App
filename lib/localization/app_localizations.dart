import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
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

  /// No description provided for @connectToDiscoverFeatures.
  ///
  /// In en, this message translates to:
  /// **'Connect to discover all our features.'**
  String get connectToDiscoverFeatures;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register!'**
  String get register;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter the Telephone number associated with your account'**
  String get enterPhone;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code'**
  String get enterCode;

  /// No description provided for @checkPhone.
  ///
  /// In en, this message translates to:
  /// **'Let\'s check your phone number together.'**
  String get checkPhone;

  /// No description provided for @callMe.
  ///
  /// In en, this message translates to:
  /// **'Call me'**
  String get callMe;

  /// No description provided for @enterFourDigits.
  ///
  /// In en, this message translates to:
  /// **'Enter the last 4 digits of\nthe incoming call number'**
  String get enterFourDigits;

  /// No description provided for @haventRecieveCode.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t received the code?'**
  String get haventRecieveCode;

  /// No description provided for @sendAgain.
  ///
  /// In en, this message translates to:
  /// **'Send again'**
  String get sendAgain;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get newPassword;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @createPassword.
  ///
  /// In en, this message translates to:
  /// **'Pass a password'**
  String get createPassword;

  /// No description provided for @repeatePassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat the password'**
  String get repeatePassword;

  /// No description provided for @acceptPolicy.
  ///
  /// In en, this message translates to:
  /// **'I accept the conditions of use and confirm that I accept the privacy policy.'**
  String get acceptPolicy;

  /// No description provided for @errorIncorrectInfo.
  ///
  /// In en, this message translates to:
  /// **'Error! Try or enter other information.'**
  String get errorIncorrectInfo;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'Look'**
  String get view;

  /// No description provided for @researchInAlgiers.
  ///
  /// In en, this message translates to:
  /// **'Research in Algiers'**
  String get researchInAlgiers;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @relatedAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Related announcements'**
  String get relatedAnnouncements;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'Look at everything'**
  String get viewAll;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @kmOfYou.
  ///
  /// In en, this message translates to:
  /// **'km of you)'**
  String get kmOfYou;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home page'**
  String get homePage;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favourites;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profile;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showAll;

  /// No description provided for @searchBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand search'**
  String get searchBrand;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'That\'s it'**
  String get done;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @searchZone.
  ///
  /// In en, this message translates to:
  /// **'Research area'**
  String get searchZone;

  /// No description provided for @displayAds.
  ///
  /// In en, this message translates to:
  /// **'Display ads'**
  String get displayAds;

  /// No description provided for @withPicture.
  ///
  /// In en, this message translates to:
  /// **'With picture'**
  String get withPicture;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sorting'**
  String get sort;

  /// No description provided for @dontHaveProducts.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have selected products'**
  String get dontHaveProducts;

  /// No description provided for @goRepertoire.
  ///
  /// In en, this message translates to:
  /// **'go to the repertoire'**
  String get goRepertoire;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @youHaveNoAds.
  ///
  /// In en, this message translates to:
  /// **'You have no ads'**
  String get youHaveNoAds;

  /// No description provided for @salesHaveReported.
  ///
  /// In en, this message translates to:
  /// **'Sales have reported'**
  String get salesHaveReported;

  /// No description provided for @myData.
  ///
  /// In en, this message translates to:
  /// **'My data'**
  String get myData;

  /// No description provided for @myComments.
  ///
  /// In en, this message translates to:
  /// **'My comments'**
  String get myComments;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'Faq'**
  String get faq;

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

  /// No description provided for @privacyPolicyFileId.
  ///
  /// In en, this message translates to:
  /// **'privacy_policy_fr'**
  String get privacyPolicyFileId;

  /// No description provided for @termsOfUseFileId.
  ///
  /// In en, this message translates to:
  /// **'terms_of_use_fr'**
  String get termsOfUseFileId;

  /// No description provided for @disconnectFromTheAccount.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from the account'**
  String get disconnectFromTheAccount;

  /// No description provided for @delProfile.
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get delProfile;

  /// No description provided for @onTheServiceOf.
  ///
  /// In en, this message translates to:
  /// **'On the service of'**
  String get onTheServiceOf;

  /// No description provided for @charit.
  ///
  /// In en, this message translates to:
  /// **'Charit'**
  String get charit;

  /// No description provided for @applicationSettings.
  ///
  /// In en, this message translates to:
  /// **'Application settings'**
  String get applicationSettings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @fr.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get fr;

  /// No description provided for @ar.
  ///
  /// In en, this message translates to:
  /// **'Arab'**
  String get ar;

  /// No description provided for @personalOffers.
  ///
  /// In en, this message translates to:
  /// **'Personal offers'**
  String get personalOffers;

  /// No description provided for @selectedProducts.
  ///
  /// In en, this message translates to:
  /// **'Selected products'**
  String get selectedProducts;

  /// No description provided for @certify.
  ///
  /// In en, this message translates to:
  /// **'Certify'**
  String get certify;

  /// No description provided for @takeAphotoWith.
  ///
  /// In en, this message translates to:
  /// **'Take a photo with a identity card holding next to the person as seen on the example below.'**
  String get takeAphotoWith;

  /// No description provided for @downloadThePhoto.
  ///
  /// In en, this message translates to:
  /// **'Download the photo in PNG format, JPEG.'**
  String get downloadThePhoto;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @del.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get del;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get features;

  /// No description provided for @typeOfProduct.
  ///
  /// In en, this message translates to:
  /// **'Type of product'**
  String get typeOfProduct;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Product category'**
  String get productCategory;

  /// No description provided for @operatingSystem.
  ///
  /// In en, this message translates to:
  /// **'Operating system'**
  String get operatingSystem;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @diagonal.
  ///
  /// In en, this message translates to:
  /// **'Diagonal'**
  String get diagonal;

  /// No description provided for @tactile.
  ///
  /// In en, this message translates to:
  /// **'Tactile'**
  String get tactile;

  /// No description provided for @integratedMemory.
  ///
  /// In en, this message translates to:
  /// **'Integrated memory'**
  String get integratedMemory;

  /// No description provided for @shooting.
  ///
  /// In en, this message translates to:
  /// **'Shooting'**
  String get shooting;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @board.
  ///
  /// In en, this message translates to:
  /// **'Board'**
  String get board;

  /// No description provided for @electronic.
  ///
  /// In en, this message translates to:
  /// **'Electronic'**
  String get electronic;

  /// No description provided for @ipados.
  ///
  /// In en, this message translates to:
  /// **'ipados'**
  String get ipados;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today at'**
  String get todayAt;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get views;

  /// No description provided for @statistical.
  ///
  /// In en, this message translates to:
  /// **'Statistical'**
  String get statistical;

  /// No description provided for @euismodAeneanSed.
  ///
  /// In en, this message translates to:
  /// **'Euismod Aenean Sed?'**
  String get euismodAeneanSed;

  /// No description provided for @contactTheSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact the support'**
  String get contactTheSupport;

  /// No description provided for @writeWithSupport.
  ///
  /// In en, this message translates to:
  /// **'Write with support'**
  String get writeWithSupport;

  /// No description provided for @doYouWantLogout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to log out?'**
  String get doYouWantLogout;

  /// No description provided for @doYouWantLogoutAlert.
  ///
  /// In en, this message translates to:
  /// **'Next time you will need to enter a password'**
  String get doYouWantLogoutAlert;

  /// No description provided for @doYouWantDelete.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete your account?'**
  String get doYouWantDelete;

  /// No description provided for @doYouWantDeleteAlert.
  ///
  /// In en, this message translates to:
  /// **'If you delete your account, you will no longer be able to recover the content or information that you have shared on Navigi. Your profile will also be deleted.'**
  String get doYouWantDeleteAlert;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @addAnAd.
  ///
  /// In en, this message translates to:
  /// **' Add an ad'**
  String get addAnAd;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @selectSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Select a subcategory'**
  String get selectSubcategory;

  /// No description provided for @loremipsum.
  ///
  /// In en, this message translates to:
  /// **'Loremipsum'**
  String get loremipsum;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **' No'**
  String get no;

  /// No description provided for @indicateTheName.
  ///
  /// In en, this message translates to:
  /// **'Indicate the name'**
  String get indicateTheName;

  /// No description provided for @typeOfNews.
  ///
  /// In en, this message translates to:
  /// **'Type of news'**
  String get typeOfNews;

  /// No description provided for @new_.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_;

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

  /// No description provided for @graySpace.
  ///
  /// In en, this message translates to:
  /// **'Gray space'**
  String get graySpace;

  /// No description provided for @theModerationOfThe.
  ///
  /// In en, this message translates to:
  /// **'The moderation of the advertisement is underway'**
  String get theModerationOfThe;

  /// No description provided for @doNotBlockThe.
  ///
  /// In en, this message translates to:
  /// **'Do not block the application during the treatment of your ad'**
  String get doNotBlockThe;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **' Filters'**
  String get filters;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @resetEverything.
  ///
  /// In en, this message translates to:
  /// **'Reset everything'**
  String get resetEverything;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @subcategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subcategory;

  /// No description provided for @onlyAhighClassification.
  ///
  /// In en, this message translates to:
  /// **'Only a high classification'**
  String get onlyAhighClassification;

  /// No description provided for @onlyWithReduction.
  ///
  /// In en, this message translates to:
  /// **'Only with reduction'**
  String get onlyWithReduction;

  /// No description provided for @tacitly.
  ///
  /// In en, this message translates to:
  /// **'Tacitly'**
  String get tacitly;

  /// No description provided for @byDate.
  ///
  /// In en, this message translates to:
  /// **'By date'**
  String get byDate;

  /// No description provided for @firstCheap.
  ///
  /// In en, this message translates to:
  /// **'First cheap'**
  String get firstCheap;

  /// No description provided for @firstDear.
  ///
  /// In en, this message translates to:
  /// **'First dear'**
  String get firstDear;

  /// No description provided for @outOfDistance.
  ///
  /// In en, this message translates to:
  /// **'Out of distance'**
  String get outOfDistance;

  /// No description provided for @realEstate.
  ///
  /// In en, this message translates to:
  /// **'Real estate'**
  String get realEstate;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @householdItems.
  ///
  /// In en, this message translates to:
  /// **'Household items'**
  String get householdItems;

  /// No description provided for @splash.
  ///
  /// In en, this message translates to:
  /// **'Splash'**
  String get splash;

  /// No description provided for @garment.
  ///
  /// In en, this message translates to:
  /// **'Garment'**
  String get garment;

  /// No description provided for @houseAndleisure.
  ///
  /// In en, this message translates to:
  /// **'House and leisure'**
  String get houseAndleisure;

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

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @researchArea.
  ///
  /// In en, this message translates to:
  /// **'Research area'**
  String get researchArea;

  /// No description provided for @toBlock.
  ///
  /// In en, this message translates to:
  /// **' To block'**
  String get toBlock;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **' Report'**
  String get report;

  /// No description provided for @productAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Product added to favorites!'**
  String get productAddedToFavorites;

  /// No description provided for @toWrite.
  ///
  /// In en, this message translates to:
  /// **'To write'**
  String get toWrite;

  /// No description provided for @toCall.
  ///
  /// In en, this message translates to:
  /// **'To call'**
  String get toCall;

  /// No description provided for @onServiceSince.
  ///
  /// In en, this message translates to:
  /// **'On service since'**
  String get onServiceSince;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'comments'**
  String get comments;

  /// No description provided for @theTransactionTookPlace.
  ///
  /// In en, this message translates to:
  /// **'The transaction took place'**
  String get theTransactionTookPlace;

  /// No description provided for @whatDidYouTalkAbout.
  ///
  /// In en, this message translates to:
  /// **'What did you talk about?'**
  String get whatDidYouTalkAbout;

  /// No description provided for @haveYouBoughtTheGoods.
  ///
  /// In en, this message translates to:
  /// **' Have you bought the goods?'**
  String get haveYouBoughtTheGoods;

  /// No description provided for @howDidItEnd.
  ///
  /// In en, this message translates to:
  /// **'How did it end?'**
  String get howDidItEnd;

  /// No description provided for @phoneCommunication.
  ///
  /// In en, this message translates to:
  /// **'Phone communication'**
  String get phoneCommunication;

  /// No description provided for @meetingAgreement.
  ///
  /// In en, this message translates to:
  /// **'Meeting agreement'**
  String get meetingAgreement;

  /// No description provided for @toWriteAcomment.
  ///
  /// In en, this message translates to:
  /// **'To write a comment'**
  String get toWriteAcomment;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get hello;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @passwordOrEmailEnteredIncorrectly.
  ///
  /// In en, this message translates to:
  /// **'Not of pass or badly seized email'**
  String get passwordOrEmailEnteredIncorrectly;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @popularResearch.
  ///
  /// In en, this message translates to:
  /// **'Popular research'**
  String get popularResearch;

  /// No description provided for @researchHistory.
  ///
  /// In en, this message translates to:
  /// **'Research history'**
  String get researchHistory;

  /// No description provided for @toClean.
  ///
  /// In en, this message translates to:
  /// **'To clean'**
  String get toClean;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'be empty'**
  String get empty;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'seller'**
  String get seller;

  /// No description provided for @offrirVotrePrix.
  ///
  /// In en, this message translates to:
  /// **'Offer your price'**
  String get offrirVotrePrix;

  /// No description provided for @addPictures.
  ///
  /// In en, this message translates to:
  /// **'Add pictures'**
  String get addPictures;

  /// No description provided for @afterwards.
  ///
  /// In en, this message translates to:
  /// **'Afterwards'**
  String get afterwards;

  /// No description provided for @loremLobortisMi.
  ///
  /// In en, this message translates to:
  /// **'Lorem Lobortis Mi Ornare Nisi Tellus Sed Aliquam Accidental Nis'**
  String get loremLobortisMi;

  /// No description provided for @errorReviewOrEnterOther.
  ///
  /// In en, this message translates to:
  /// **'Error! Review or enter other information.'**
  String get errorReviewOrEnterOther;

  /// No description provided for @jacceptsTheConditionsForTheilization.
  ///
  /// In en, this message translates to:
  /// **'Jaccepts the conditions for theilization and confirms that Jaccepte the Privacy Policy.'**
  String get jacceptsTheConditionsForTheilization;

  /// No description provided for @regg.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get regg;

  /// No description provided for @entrance.
  ///
  /// In en, this message translates to:
  /// **'Entrance'**
  String get entrance;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'place'**
  String get place;

  /// No description provided for @popularRequests.
  ///
  /// In en, this message translates to:
  /// **'Popular requests'**
  String get popularRequests;

  /// No description provided for @cancelation.
  ///
  /// In en, this message translates to:
  /// **'Cancelation'**
  String get cancelation;

  /// No description provided for @withSuccess.
  ///
  /// In en, this message translates to:
  /// **'With success'**
  String get withSuccess;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @placeApplicationSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get placeApplicationSettings;

  /// No description provided for @mark.
  ///
  /// In en, this message translates to:
  /// **'Mark'**
  String get mark;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @choosingCarBrand.
  ///
  /// In en, this message translates to:
  /// **'Choosing a car brand'**
  String get choosingCarBrand;

  /// No description provided for @choosingMark.
  ///
  /// In en, this message translates to:
  /// **'Choosing mark'**
  String get choosingMark;

  /// No description provided for @choosingCategory.
  ///
  /// In en, this message translates to:
  /// **'Choosing category'**
  String get choosingCategory;

  /// No description provided for @specifyPlace.
  ///
  /// In en, this message translates to:
  /// **'Specify place'**
  String get specifyPlace;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing was found'**
  String get notFound;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @offerMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello! I propose you'**
  String get offerMessage;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment'**
  String get writeComment;

  /// No description provided for @dataDownloadError.
  ///
  /// In en, this message translates to:
  /// **'Data download error'**
  String get dataDownloadError;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'The changes are saved'**
  String get changesSaved;

  /// No description provided for @dataSavingError.
  ///
  /// In en, this message translates to:
  /// **'Data saving error'**
  String get dataSavingError;

  /// No description provided for @adSuccessfullyAdded.
  ///
  /// In en, this message translates to:
  /// **'The ad was successfully added'**
  String get adSuccessfullyAdded;

  /// No description provided for @errorCreatingAd.
  ///
  /// In en, this message translates to:
  /// **'Error creating the ad'**
  String get errorCreatingAd;

  /// No description provided for @chatBlocked.
  ///
  /// In en, this message translates to:
  /// **'The chat is blocked'**
  String get chatBlocked;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock user'**
  String get unblockUser;

  /// No description provided for @adAddedToFavorites.
  ///
  /// In en, this message translates to:
  /// **'The ad has been added to favorites'**
  String get adAddedToFavorites;

  /// No description provided for @adRemovedFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'The ad has been removed from favorites'**
  String get adRemovedFromFavorites;

  /// No description provided for @marketPrice.
  ///
  /// In en, this message translates to:
  /// **'Market price:'**
  String get marketPrice;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @marketPriceCaption.
  ///
  /// In en, this message translates to:
  /// **'The price range has been calculated over the last 6 months. Here is what has been taken into account:'**
  String get marketPriceCaption;

  /// No description provided for @markAndModel.
  ///
  /// In en, this message translates to:
  /// **'Mark and model'**
  String get markAndModel;

  /// No description provided for @productParameters.
  ///
  /// In en, this message translates to:
  /// **'The product parameters'**
  String get productParameters;

  /// No description provided for @cityAndRegion.
  ///
  /// In en, this message translates to:
  /// **'City and region'**
  String get cityAndRegion;

  /// No description provided for @userBlockedYou.
  ///
  /// In en, this message translates to:
  /// **'The user {userName} has blocked you'**
  String userBlockedYou(String userName);

  /// No description provided for @youBlockedUser.
  ///
  /// In en, this message translates to:
  /// **'You have blocked the user {userName}'**
  String youBlockedUser(String userName);

  /// No description provided for @dzd.
  ///
  /// In en, this message translates to:
  /// **'Algerian Dinar'**
  String get dzd;

  /// No description provided for @mln.
  ///
  /// In en, this message translates to:
  /// **'Millions'**
  String get mln;

  /// No description provided for @mlrd.
  ///
  /// In en, this message translates to:
  /// **'Billions'**
  String get mlrd;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get tryAgainLater;

  /// No description provided for @userAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This user is already registered'**
  String get userAlreadyRegistered;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'The user is not registered'**
  String get userNotFound;

  /// No description provided for @forgotYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotYourPassword;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @recoverPassword.
  ///
  /// In en, this message translates to:
  /// **'Recover password'**
  String get recoverPassword;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'not specified'**
  String get notSpecified;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter valid E-mail'**
  String get enterValidEmail;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid Code'**
  String get invalidCode;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password Update Successfully'**
  String get passwordUpdateSuccess;

  /// No description provided for @soldAction.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get soldAction;

  /// No description provided for @putForSaleAction.
  ///
  /// In en, this message translates to:
  /// **'Put for sale'**
  String get putForSaleAction;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @errorCommentAlreadyLeft.
  ///
  /// In en, this message translates to:
  /// **'The review has already been sent to this seller'**
  String get errorCommentAlreadyLeft;

  /// No description provided for @errorCommentYourself.
  ///
  /// In en, this message translates to:
  /// **'You can\'t send review to yourself'**
  String get errorCommentYourself;

  /// No description provided for @errorInvalidScore.
  ///
  /// In en, this message translates to:
  /// **'Rating error'**
  String get errorInvalidScore;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'Error in the text'**
  String get errorText;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'There is no Internet connection. Please make sure that wi-fi or cellular connection is enabled and try again.'**
  String get noConnection;

  /// No description provided for @isConnection.
  ///
  /// In en, this message translates to:
  /// **'Internet connection has been restored'**
  String get isConnection;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @enterPhoneNumberAtSettings.
  ///
  /// In en, this message translates to:
  /// **'To create an ad, enter your phone number in the settings'**
  String get enterPhoneNumberAtSettings;
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

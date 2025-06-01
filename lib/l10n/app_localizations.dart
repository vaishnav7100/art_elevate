import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('ml')
  ];

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nArt Elevate'**
  String get welcomeMessage;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email id'**
  String get emailHint;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmail;

  /// No description provided for @gmailOnly.
  ///
  /// In en, this message translates to:
  /// **'Please enter a gmail address'**
  String get gmailOnly;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Password'**
  String get passwordHint;

  /// No description provided for @passwordLength.
  ///
  /// In en, this message translates to:
  /// **'Password should be at least 6 characters'**
  String get passwordLength;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account,'**
  String get noAccount;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'click here'**
  String get clickHere;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error :'**
  String get error;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get invalidEmail;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email address is already in use.'**
  String get emailInUse;

  /// No description provided for @okButton.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okButton;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @myArtwork.
  ///
  /// In en, this message translates to:
  /// **'My Artwork'**
  String get myArtwork;

  /// No description provided for @termsAndPolicies.
  ///
  /// In en, this message translates to:
  /// **'Terms and policies'**
  String get termsAndPolicies;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About us'**
  String get aboutUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full Name (Required)*'**
  String get fullNameRequired;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number (Required)*'**
  String get phoneNumberRequired;

  /// No description provided for @pincodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Pincode (Required)*'**
  String get pincodeRequired;

  /// No description provided for @pleaseEnter6DigitPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a 6-digit pincode'**
  String get pleaseEnter6DigitPincode;

  /// No description provided for @pincodeMustBeNumeric.
  ///
  /// In en, this message translates to:
  /// **'Pincode must be numeric'**
  String get pincodeMustBeNumeric;

  /// No description provided for @stateRequired.
  ///
  /// In en, this message translates to:
  /// **'State (Required)*'**
  String get stateRequired;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City (Required)*'**
  String get cityRequired;

  /// No description provided for @houseNoRequired.
  ///
  /// In en, this message translates to:
  /// **'House No., Building Name (Required)*'**
  String get houseNoRequired;

  /// No description provided for @landmarkRequired.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get landmarkRequired;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// No description provided for @addDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Add delivery address'**
  String get addDeliveryAddress;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterValidName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid name.'**
  String get pleaseEnterValidName;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number.'**
  String get pleaseEnterPhone;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get pleaseEnterValidPhone;

  /// No description provided for @pleaseEnterPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the pincode of your location.'**
  String get pleaseEnterPincode;

  /// No description provided for @pleaseEnterState.
  ///
  /// In en, this message translates to:
  /// **'Please enter your state.'**
  String get pleaseEnterState;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter your city.'**
  String get pleaseEnterCity;

  /// No description provided for @pleaseEnterHouse.
  ///
  /// In en, this message translates to:
  /// **'Please enter your house number or building name.'**
  String get pleaseEnterHouse;

  /// No description provided for @pleaseEnterLandmark.
  ///
  /// In en, this message translates to:
  /// **'Please enter a landmark for your location.'**
  String get pleaseEnterLandmark;

  /// No description provided for @addressAdded.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully!'**
  String get addressAdded;

  /// No description provided for @addressAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to add address'**
  String get addressAddFailed;

  /// No description provided for @item_not_found.
  ///
  /// In en, this message translates to:
  /// **'Item not found!'**
  String get item_not_found;

  /// No description provided for @search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search by product, brand & more...'**
  String get search_hint;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_title;

  /// No description provided for @error_message.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch user data. Please try again'**
  String get error_message;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get view_all;

  /// No description provided for @my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get my_account;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @password_reset_email_sent.
  ///
  /// In en, this message translates to:
  /// **'Password Reset Email has been sent!'**
  String get password_reset_email_sent;

  /// No description provided for @delete_account_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get delete_account_confirmation;

  /// No description provided for @enter_password_to_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Enter your password to delete account'**
  String get enter_password_to_delete_account;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @reset_password_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset your password?'**
  String get reset_password_confirmation;

  /// No description provided for @please_login_again.
  ///
  /// In en, this message translates to:
  /// **'You need to log in again to perform this action'**
  String get please_login_again;

  /// No description provided for @account_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get account_deleted_successfully;

  /// No description provided for @error_deleting_account.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account. Please try again.'**
  String get error_deleting_account;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No chats found.'**
  String get noChatsFound;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My orders'**
  String get myOrders;

  /// No description provided for @oopsNoOrders.
  ///
  /// In en, this message translates to:
  /// **'Oops! Can\'t find any orders'**
  String get oopsNoOrders;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get shopNow;

  /// No description provided for @errorLoadingOrders.
  ///
  /// In en, this message translates to:
  /// **'Error loading orders: '**
  String get errorLoadingOrders;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get noItemsFound;

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

  /// No description provided for @my_addresses.
  ///
  /// In en, this message translates to:
  /// **'My Addresses'**
  String get my_addresses;

  /// No description provided for @saved_addresses.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses '**
  String get saved_addresses;

  /// No description provided for @add_a_new_address.
  ///
  /// In en, this message translates to:
  /// **'Add a new address'**
  String get add_a_new_address;

  /// No description provided for @delete_this_address.
  ///
  /// In en, this message translates to:
  /// **'Delete this address'**
  String get delete_this_address;

  /// No description provided for @address_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Address deleted successfully'**
  String get address_deleted_successfully;

  /// No description provided for @error_deleting_address.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error_deleting_address;

  /// No description provided for @user_need_to_login.
  ///
  /// In en, this message translates to:
  /// **'User need to login'**
  String get user_need_to_login;

  /// No description provided for @address_made_default.
  ///
  /// In en, this message translates to:
  /// **'Address made default successfully'**
  String get address_made_default;

  /// No description provided for @error_making_default_address.
  ///
  /// In en, this message translates to:
  /// **'Error making address default'**
  String get error_making_default_address;

  /// No description provided for @my_artwork.
  ///
  /// In en, this message translates to:
  /// **'My Artwork'**
  String get my_artwork;

  /// No description provided for @error_fetching_email.
  ///
  /// In en, this message translates to:
  /// **'Error fetching email'**
  String get error_fetching_email;

  /// No description provided for @error_fetching_artworks.
  ///
  /// In en, this message translates to:
  /// **'Error fetching artworks'**
  String get error_fetching_artworks;

  /// No description provided for @artwork_deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Artwork deleted successfully'**
  String get artwork_deleted_successfully;

  /// No description provided for @error_deleting_artwork.
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error_deleting_artwork;

  /// No description provided for @upload_your_artwork.
  ///
  /// In en, this message translates to:
  /// **'Upload your artwork!'**
  String get upload_your_artwork;

  /// No description provided for @upload_artwork.
  ///
  /// In en, this message translates to:
  /// **'Upload artwork'**
  String get upload_artwork;

  /// No description provided for @delete_this_artwork.
  ///
  /// In en, this message translates to:
  /// **'Delete this artwork'**
  String get delete_this_artwork;

  /// No description provided for @returnPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return policy'**
  String get returnPolicy;

  /// No description provided for @paymentPolicy.
  ///
  /// In en, this message translates to:
  /// **'Payment policy'**
  String get paymentPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @customerCare.
  ///
  /// In en, this message translates to:
  /// **'Customer care :'**
  String get customerCare;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'Whatsapp :'**
  String get whatsapp;

  /// No description provided for @workingHours.
  ///
  /// In en, this message translates to:
  /// **'MON-FRI : 9:30AM - 6:00 PM'**
  String get workingHours;

  /// No description provided for @connectMessage.
  ///
  /// In en, this message translates to:
  /// **'Anyone can directly connect with us on following Customer care number and E-mail'**
  String get connectMessage;

  /// No description provided for @who_are_we.
  ///
  /// In en, this message translates to:
  /// **'Who Are We'**
  String get who_are_we;

  /// No description provided for @about_us_description.
  ///
  /// In en, this message translates to:
  /// **'Art Elevate is an innovative app designed for both art lovers and creators. Created by Vaishnav, it connects artists with buyers through an easy-to-use platform. Artists can upload their works, set prices, and reach a global audience. Buyers can explore a wide variety of art styles and genres. The app ensures secure transactions and a smooth user experience. Art Elevate also features a community where users can interact and share their artistic passions. It supports artists from diverse backgrounds, helping them gain visibility. Whether buying or selling, Art Elevate is your gateway to the art world.'**
  String get about_us_description;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to our art platform! \nFill out the form below to become a seller and start showcasing your artwork.'**
  String get welcome_message;

  /// No description provided for @artwork_submission.
  ///
  /// In en, this message translates to:
  /// **'Artwork Submission'**
  String get artwork_submission;

  /// No description provided for @no_image_selected.
  ///
  /// In en, this message translates to:
  /// **'No images selected'**
  String get no_image_selected;

  /// No description provided for @title_for_artwork.
  ///
  /// In en, this message translates to:
  /// **'Title for your artwork'**
  String get title_for_artwork;

  /// No description provided for @select_title.
  ///
  /// In en, this message translates to:
  /// **'Select title'**
  String get select_title;

  /// No description provided for @price_of_artwork.
  ///
  /// In en, this message translates to:
  /// **'Price of your artwork'**
  String get price_of_artwork;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @selectTitle.
  ///
  /// In en, this message translates to:
  /// **'Please select a title'**
  String get selectTitle;

  /// No description provided for @enterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price'**
  String get enterPrice;

  /// No description provided for @seller_agreement.
  ///
  /// In en, this message translates to:
  /// **'Seller Agreement'**
  String get seller_agreement;

  /// No description provided for @agreeToTerms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get agreeToTerms;

  /// No description provided for @submit_application.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submit_application;

  /// No description provided for @artwork_verification_message.
  ///
  /// In en, this message translates to:
  /// **'We will verify your artwork in 12 hours and post it.'**
  String get artwork_verification_message;

  /// No description provided for @artwork_upload_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload artwork. Please try again.'**
  String get artwork_upload_error;

  /// No description provided for @image_select_and_price_message.
  ///
  /// In en, this message translates to:
  /// **'Please select an image and set a price'**
  String get image_select_and_price_message;

  /// No description provided for @fill_upload_image_message.
  ///
  /// In en, this message translates to:
  /// **'Please fill upload image of your artwork'**
  String get fill_upload_image_message;

  /// No description provided for @accept_terms_message.
  ///
  /// In en, this message translates to:
  /// **'Please accept the terms and condition.'**
  String get accept_terms_message;

  /// No description provided for @artworkAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'We will verify your artwork and then post it '**
  String get artworkAddedSuccess;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @no_items_found.
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get no_items_found;

  /// No description provided for @oops_no_items.
  ///
  /// In en, this message translates to:
  /// **'Oops! Can\'t find any items'**
  String get oops_no_items;

  /// No description provided for @add_now.
  ///
  /// In en, this message translates to:
  /// **'Add now'**
  String get add_now;

  /// No description provided for @report_sent_successfully.
  ///
  /// In en, this message translates to:
  /// **'Report sent successfully'**
  String get report_sent_successfully;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @no_data_found.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get no_data_found;

  /// No description provided for @set_your_profile_password.
  ///
  /// In en, this message translates to:
  /// **'Set your profile & password'**
  String get set_your_profile_password;

  /// No description provided for @mark_as_delivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as delivered'**
  String get mark_as_delivered;

  /// No description provided for @marked_as_delivered.
  ///
  /// In en, this message translates to:
  /// **'Marked as delivered'**
  String get marked_as_delivered;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @no_notifications_available.
  ///
  /// In en, this message translates to:
  /// **'No notifications available'**
  String get no_notifications_available;

  /// No description provided for @mark_as_read.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get mark_as_read;

  /// No description provided for @please_save_your_address.
  ///
  /// In en, this message translates to:
  /// **'Please save your address!'**
  String get please_save_your_address;

  /// No description provided for @processing_your_order.
  ///
  /// In en, this message translates to:
  /// **'Processing your order...'**
  String get processing_your_order;

  /// No description provided for @order_now.
  ///
  /// In en, this message translates to:
  /// **'Order now'**
  String get order_now;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @rate_this_artwork.
  ///
  /// In en, this message translates to:
  /// **'Rate this Artwork'**
  String get rate_this_artwork;

  /// No description provided for @no_orders_available.
  ///
  /// In en, this message translates to:
  /// **'No Orders available'**
  String get no_orders_available;

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get send_message;

  /// No description provided for @customer_orders.
  ///
  /// In en, this message translates to:
  /// **'Customer Orders'**
  String get customer_orders;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'hi', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

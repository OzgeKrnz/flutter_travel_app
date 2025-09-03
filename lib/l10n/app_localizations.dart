import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @country_DE.
  ///
  /// In de, this message translates to:
  /// **'Deutschland'**
  String get country_DE;

  /// No description provided for @country_AT.
  ///
  /// In de, this message translates to:
  /// **'Österreich'**
  String get country_AT;

  /// No description provided for @country_CH.
  ///
  /// In de, this message translates to:
  /// **'Schweiz'**
  String get country_CH;

  /// No description provided for @category_CULTURE.
  ///
  /// In de, this message translates to:
  /// **'Kultur'**
  String get category_CULTURE;

  /// No description provided for @category_FESTIVAL.
  ///
  /// In de, this message translates to:
  /// **'Festival'**
  String get category_FESTIVAL;

  /// No description provided for @category_ADVENTURE.
  ///
  /// In de, this message translates to:
  /// **'Abenteuer'**
  String get category_ADVENTURE;

  /// No description provided for @category_ART.
  ///
  /// In de, this message translates to:
  /// **'Kunst'**
  String get category_ART;

  /// No description provided for @category_GASTRONOMY.
  ///
  /// In de, this message translates to:
  /// **'Gastronomie'**
  String get category_GASTRONOMY;

  /// No description provided for @category_NATURE.
  ///
  /// In de, this message translates to:
  /// **'Natur'**
  String get category_NATURE;

  /// No description provided for @category_HISTORY.
  ///
  /// In de, this message translates to:
  /// **'Geschichte'**
  String get category_HISTORY;

  /// No description provided for @region_BERLIN.
  ///
  /// In de, this message translates to:
  /// **'Berlin'**
  String get region_BERLIN;

  /// No description provided for @region_BAYERN.
  ///
  /// In de, this message translates to:
  /// **'Bayern'**
  String get region_BAYERN;

  /// No description provided for @region_WIEN.
  ///
  /// In de, this message translates to:
  /// **'Wien'**
  String get region_WIEN;

  /// No description provided for @region_ZURICH.
  ///
  /// In de, this message translates to:
  /// **'Zürich'**
  String get region_ZURICH;

  /// No description provided for @region_VALAIS.
  ///
  /// In de, this message translates to:
  /// **'Wallis'**
  String get region_VALAIS;

  /// No description provided for @region_BERN.
  ///
  /// In de, this message translates to:
  /// **'Bern'**
  String get region_BERN;

  /// No description provided for @region_LUZERN.
  ///
  /// In de, this message translates to:
  /// **'Luzern'**
  String get region_LUZERN;

  /// No description provided for @region_HESSEN.
  ///
  /// In de, this message translates to:
  /// **'Hessen'**
  String get region_HESSEN;

  /// No description provided for @region_SACHSEN.
  ///
  /// In de, this message translates to:
  /// **'Sachsen'**
  String get region_SACHSEN;

  /// No description provided for @region_STEIERMARK.
  ///
  /// In de, this message translates to:
  /// **'Steiermark'**
  String get region_STEIERMARK;

  /// No description provided for @region_VORARLBERG.
  ///
  /// In de, this message translates to:
  /// **'Vorarlberg'**
  String get region_VORARLBERG;

  /// No description provided for @region_GENEVE.
  ///
  /// In de, this message translates to:
  /// **'Genf'**
  String get region_GENEVE;

  /// No description provided for @region_HAMBURG.
  ///
  /// In de, this message translates to:
  /// **'Hamburg'**
  String get region_HAMBURG;

  /// No description provided for @region_TIROL.
  ///
  /// In de, this message translates to:
  /// **'Tirol'**
  String get region_TIROL;

  /// No description provided for @title_TRIP_BERLIN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Berlin'**
  String get title_TRIP_BERLIN;

  /// No description provided for @desc_TRIP_BERLIN.
  ///
  /// In de, this message translates to:
  /// **'Museen, historische Stätten und Street-Art erkunden'**
  String get desc_TRIP_BERLIN;

  /// No description provided for @title_TRIP_BAYERN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Bayern'**
  String get title_TRIP_BAYERN;

  /// No description provided for @desc_TRIP_BAYERN.
  ///
  /// In de, this message translates to:
  /// **'Tradition, Natur und historische Städte entdecken'**
  String get desc_TRIP_BAYERN;

  /// No description provided for @title_TRIP_WIEN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Wien'**
  String get title_TRIP_WIEN;

  /// No description provided for @desc_TRIP_WIEN.
  ///
  /// In de, this message translates to:
  /// **'Kaffeehäuser, klassische Musik und Altstadtflair'**
  String get desc_TRIP_WIEN;

  /// No description provided for @title_TRIP_ZURICH.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Zürich'**
  String get title_TRIP_ZURICH;

  /// No description provided for @desc_TRIP_ZURICH.
  ///
  /// In de, this message translates to:
  /// **'Altstadt, Kunst und Seepromenade erkunden'**
  String get desc_TRIP_ZURICH;

  /// No description provided for @title_TRIP_VALAIS.
  ///
  /// In de, this message translates to:
  /// **'Reise ins Wallis'**
  String get title_TRIP_VALAIS;

  /// No description provided for @desc_TRIP_VALAIS.
  ///
  /// In de, this message translates to:
  /// **'Alpenpanoramen, Wanderungen und Bergdörfer'**
  String get desc_TRIP_VALAIS;

  /// No description provided for @title_TRIP_BERN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Bern'**
  String get title_TRIP_BERN;

  /// No description provided for @desc_TRIP_BERN.
  ///
  /// In de, this message translates to:
  /// **'Zähringerstadt, Aareufer und Museen'**
  String get desc_TRIP_BERN;

  /// No description provided for @title_TRIP_LUZERN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Luzern'**
  String get title_TRIP_LUZERN;

  /// No description provided for @desc_TRIP_LUZERN.
  ///
  /// In de, this message translates to:
  /// **'Kapellbrücke, Vierwaldstättersee und Altstadt'**
  String get desc_TRIP_LUZERN;

  /// No description provided for @title_TRIP_HESSEN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Hessen'**
  String get title_TRIP_HESSEN;

  /// No description provided for @desc_TRIP_HESSEN.
  ///
  /// In de, this message translates to:
  /// **'Fachwerkstädte, Museen und Kulinarik entdecken'**
  String get desc_TRIP_HESSEN;

  /// No description provided for @title_TRIP_SACHSEN.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Sachsen'**
  String get title_TRIP_SACHSEN;

  /// No description provided for @desc_TRIP_SACHSEN.
  ///
  /// In de, this message translates to:
  /// **'Barockarchitektur, Kunst und Elbtäler erkunden'**
  String get desc_TRIP_SACHSEN;

  /// No description provided for @title_TRIP_STEIERMARK.
  ///
  /// In de, this message translates to:
  /// **'Reise in die Steiermark'**
  String get title_TRIP_STEIERMARK;

  /// No description provided for @desc_TRIP_STEIERMARK.
  ///
  /// In de, this message translates to:
  /// **'Weinberge, Schlösser und Naturparks'**
  String get desc_TRIP_STEIERMARK;

  /// No description provided for @title_TRIP_VORARLBERG.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Vorarlberg'**
  String get title_TRIP_VORARLBERG;

  /// No description provided for @desc_TRIP_VORARLBERG.
  ///
  /// In de, this message translates to:
  /// **'Alpen, Bodensee und moderne Architektur'**
  String get desc_TRIP_VORARLBERG;

  /// No description provided for @title_TRIP_GENEVE.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Genf'**
  String get title_TRIP_GENEVE;

  /// No description provided for @desc_TRIP_GENEVE.
  ///
  /// In de, this message translates to:
  /// **'Genfersee, Altstadt und internationale Viertel'**
  String get desc_TRIP_GENEVE;

  /// No description provided for @title_TRIP_HAMBURG.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Hamburg'**
  String get title_TRIP_HAMBURG;

  /// No description provided for @desc_TRIP_HAMBURG.
  ///
  /// In de, this message translates to:
  /// **'Hafen, Speicherstadt und Elbphilharmonie'**
  String get desc_TRIP_HAMBURG;

  /// No description provided for @title_TRIP_TIROL.
  ///
  /// In de, this message translates to:
  /// **'Reise nach Tirol'**
  String get title_TRIP_TIROL;

  /// No description provided for @desc_TRIP_TIROL.
  ///
  /// In de, this message translates to:
  /// **'Bergpanoramen, Wanderungen und Wintersport'**
  String get desc_TRIP_TIROL;

  /// No description provided for @home_title.
  ///
  /// In de, this message translates to:
  /// **'Reisen'**
  String get home_title;

  /// No description provided for @empty_no_results.
  ///
  /// In de, this message translates to:
  /// **'Kein Ergebnis, bitte Filter löschen.'**
  String get empty_no_results;

  /// No description provided for @help_pickDateRange.
  ///
  /// In de, this message translates to:
  /// **'Reisezeitraum auswählen'**
  String get help_pickDateRange;

  /// No description provided for @app_name.
  ///
  /// In de, this message translates to:
  /// **'Travel App'**
  String get app_name;

  /// No description provided for @menu_home.
  ///
  /// In de, this message translates to:
  /// **'Start'**
  String get menu_home;

  /// No description provided for @menu_profile.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get menu_profile;

  /// No description provided for @menu_logout.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get menu_logout;

  /// No description provided for @profile_title.
  ///
  /// In de, this message translates to:
  /// **'Profil'**
  String get profile_title;

  /// No description provided for @profile_full_name.
  ///
  /// In de, this message translates to:
  /// **'Vollständiger Name'**
  String get profile_full_name;

  /// No description provided for @profile_created_at.
  ///
  /// In de, this message translates to:
  /// **'Konto erstellt'**
  String get profile_created_at;

  /// No description provided for @profile_last_login.
  ///
  /// In de, this message translates to:
  /// **'Letzte Anmeldung'**
  String get profile_last_login;

  /// No description provided for @filter_country.
  ///
  /// In de, this message translates to:
  /// **'Land'**
  String get filter_country;

  /// No description provided for @filter_region.
  ///
  /// In de, this message translates to:
  /// **'Region'**
  String get filter_region;

  /// No description provided for @filter_category.
  ///
  /// In de, this message translates to:
  /// **'Kategorie'**
  String get filter_category;

  /// No description provided for @filter_date.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get filter_date;

  /// No description provided for @filter_favorites.
  ///
  /// In de, this message translates to:
  /// **'Favoriten'**
  String get filter_favorites;

  /// No description provided for @filter_clear.
  ///
  /// In de, this message translates to:
  /// **'Zurücksetzen'**
  String get filter_clear;

  /// No description provided for @filter_all.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get filter_all;
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
      <String>['de', 'en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

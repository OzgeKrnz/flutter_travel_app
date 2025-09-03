import 'package:travel_app/l10n/app_localizations.dart';

String _n(String s) => s
    .toLowerCase()
    .replaceAll('ı','i').replaceAll('ş','s').replaceAll('ğ','g')
    .replaceAll('ü','u').replaceAll('ö','o').replaceAll('ç','c')
    .trim();

String? toCountryCode(String input) {
  final s = _n(input);
  if (s == 'de' || ['deutschland','germany','almanya'].contains(s)) return 'DE';
  if (s == 'at' || ['osterreich','österreich','austria','avusturya'].contains(s)) return 'AT';
  if (s == 'ch' || ['schweiz','switzerland','isvicre','isviçre','suisse'].contains(s)) return 'CH';
  return null;
}

String? toRegionKey(String input) {
  final s = _n(input);
  if (s == 'berlin') return 'BERLIN';
  if (['bayern','bavaria'].contains(s)) return 'BAYERN';
  if (['wien','vienna'].contains(s)) return 'WIEN';
  if (['zurich','zürich','zuerich'].contains(s)) return 'ZURICH';
  if (['valais','wallis'].contains(s)) return 'VALAIS';
  if (s == 'bern') return 'BERN';
  if (['luzern','lucerne'].contains(s)) return 'LUZERN';
  if (s == 'hessen') return 'HESSEN';
  if (['sachsen','saxony'].contains(s)) return 'SACHSEN';
  if (['steiermark','styria'].contains(s)) return 'STEIERMARK';
  if (s == 'vorarlberg') return 'VORARLBERG';
  if (['geneve','genf','geneva','genève'].contains(s)) return 'GENEVE';
  if (s == 'hamburg') return 'HAMBURG';
  if (['tirol','tyrol'].contains(s)) return 'TIROL';
  return null;
}

String? toCategoryCode(String input) {
  final s = _n(input);
  if (['kultur','culture','kültür'].contains(s)) return 'CULTURE';
  if (['festival'].contains(s)) return 'FESTIVAL';
  if (['abenteuer','adventure','macera'].contains(s)) return 'ADVENTURE';
  if (['kunst','art','sanat'].contains(s)) return 'ART';
  if (['gastronomie','gastronomy','gastronomi'].contains(s)) return 'GASTRONOMY';
  if (['natur','nature','doga','doğa'].contains(s)) return 'NATURE';
  if (['geschichte','history','tarih'].contains(s)) return 'HISTORY';
  return null;
}

String localizedCountry(String any, AppLocalizations l) {
  final code = toCountryCode(any) ?? any;
  switch (code) {
    case 'DE': return l.country_DE;
    case 'AT': return l.country_AT;
    case 'CH': return l.country_CH;
    default:   return any;
  }
}

String localizedRegion(String any, AppLocalizations l) {
  final key = toRegionKey(any) ?? any;
  switch (key) {
    case 'BERLIN':      return l.region_BERLIN;
    case 'BAYERN':      return l.region_BAYERN;
    case 'WIEN':        return l.region_WIEN;
    case 'ZURICH':      return l.region_ZURICH;
    case 'VALAIS':      return l.region_VALAIS;
    case 'BERN':        return l.region_BERN;
    case 'LUZERN':      return l.region_LUZERN;
    case 'HESSEN':      return l.region_HESSEN;
    case 'SACHSEN':     return l.region_SACHSEN;
    case 'STEIERMARK':  return l.region_STEIERMARK;
    case 'VORARLBERG':  return l.region_VORARLBERG;
    case 'GENEVE':      return l.region_GENEVE;
    case 'HAMBURG':     return l.region_HAMBURG;
    case 'TIROL':       return l.region_TIROL;
    default:            return any;
  }
}

String localizedCategory(String any, AppLocalizations l) {
  final key = toCategoryCode(any) ?? any;
  switch (key) {
    case 'CULTURE':    return l.category_CULTURE;
    case 'FESTIVAL':   return l.category_FESTIVAL;
    case 'ADVENTURE':  return l.category_ADVENTURE;
    case 'ART':        return l.category_ART;
    case 'GASTRONOMY': return l.category_GASTRONOMY;
    case 'NATURE':     return l.category_NATURE;
    case 'HISTORY':    return l.category_HISTORY;
    default:           return any;
  }

}

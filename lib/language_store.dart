import 'package:flutter/material.dart';

enum AppLanguage { fr, en, ar }

class LanguageStore extends ChangeNotifier {
  LanguageStore._();

  static final instance = LanguageStore._();

  AppLanguage _language = AppLanguage.fr;

  AppLanguage get language => _language;

  Locale get locale => switch (_language) {
    AppLanguage.fr => const Locale('fr', 'FR'),
    AppLanguage.en => const Locale('en', 'US'),
    AppLanguage.ar => const Locale('ar', 'TN'),
  };

  bool get isRtl => _language == AppLanguage.ar;

  String get languageName => switch (_language) {
    AppLanguage.fr => 'Français',
    AppLanguage.en => 'English',
    AppLanguage.ar => 'العربية',
  };

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }

  String text(String key) =>
      _translations[_language]?[key] ??
      _translations[AppLanguage.fr]?[key] ??
      key;

  static const _translations = <AppLanguage, Map<String, String>>{
    AppLanguage.fr: {
      'home': 'Accueil',
      'favorites': 'Favoris',
      'messages': 'Messages',
      'profile': 'Profil',
      'contact': 'Contacter',
      'my_favorites': 'Mes favoris',
      'language': 'Langue',
      'choose_language': 'Choisir la langue',
      'notifications': 'Notifications',
      'help': 'Centre d’aide',
      'privacy': 'Confidentialité',
      'logout': 'Se déconnecter',
      'my_profile': 'Mon profil',
      'conversations': 'Vos conversations',
      'conversation_hint': 'Touchez une conversation pour répondre.',
      'no_conversation': 'Aucune conversation',
      'new_conversation': 'Nouvelle conversation',
      'start_conversation': 'Commencez la conversation',
      'write_message': 'Écrire un message...',
      'no_favorites': 'Aucun favori pour le moment',
      'no_favorites_hint':
          'Touchez le cœur d’une annonce pour la retrouver ici.',
      'remove_favorite': 'Retirer des favoris',
      'add_favorite': 'Ajouter aux favoris',
      'for_sale': 'À vendre',
      'bedrooms': 'chambres',
      'listing_details': 'Détails du bien',
      'description': 'Description',
      'owner': 'Propriétaire',
      'listing_description_default': 'Découvrez ce bien dans son environnement et contactez son propriétaire pour obtenir plus d’informations.',
    },
    AppLanguage.en: {
      'home': 'Home',
      'favorites': 'Favorites',
      'messages': 'Messages',
      'profile': 'Profile',
      'contact': 'Contact',
      'my_favorites': 'My favorites',
      'language': 'Language',
      'choose_language': 'Choose language',
      'notifications': 'Notifications',
      'help': 'Help center',
      'privacy': 'Privacy',
      'logout': 'Log out',
      'my_profile': 'My profile',
      'conversations': 'Your conversations',
      'conversation_hint': 'Tap a conversation to reply.',
      'no_conversation': 'No conversations',
      'new_conversation': 'New conversation',
      'start_conversation': 'Start the conversation',
      'write_message': 'Write a message...',
      'no_favorites': 'No favorites yet',
      'no_favorites_hint': 'Tap a listing’s heart to find it here.',
      'remove_favorite': 'Remove from favorites',
      'add_favorite': 'Add to favorites',
      'for_sale': 'For sale',
      'bedrooms': 'bedrooms',
      'listing_details': 'Listing details',
      'description': 'Description',
      'owner': 'Owner',
      'listing_description_default': 'Discover this property in its setting and contact the owner for more information.',
    },
    AppLanguage.ar: {
      'home': 'الرئيسية',
      'favorites': 'المفضلة',
      'messages': 'الرسائل',
      'profile': 'الملف الشخصي',
      'contact': 'تواصل',
      'my_favorites': 'مفضلتي',
      'language': 'اللغة',
      'choose_language': 'اختر اللغة',
      'notifications': 'الإشعارات',
      'help': 'مركز المساعدة',
      'privacy': 'الخصوصية',
      'logout': 'تسجيل الخروج',
      'my_profile': 'ملفي الشخصي',
      'conversations': 'محادثاتك',
      'conversation_hint': 'اضغط على محادثة للرد.',
      'no_conversation': 'لا توجد محادثات',
      'new_conversation': 'محادثة جديدة',
      'start_conversation': 'ابدأ المحادثة',
      'write_message': 'اكتب رسالة...',
      'no_favorites': 'لا توجد عناصر مفضلة',
      'no_favorites_hint': 'اضغط على القلب لحفظ الإعلان هنا.',
      'remove_favorite': 'إزالة من المفضلة',
      'add_favorite': 'أضف إلى المفضلة',
      'for_sale': 'للبيع',
      'bedrooms': 'غرف',
      'listing_details': 'تفاصيل العقار',
      'description': 'الوصف',
      'owner': 'المالك',
      'listing_description_default':
          'اكتشف هذا العقار وتواصل مع المالك للحصول على المزيد من المعلومات.',
    },
  };
}

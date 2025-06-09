import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:referaly/resources/app_colors.dart';
import 'package:referaly/resources/app_preference.dart';
import 'package:referaly/utils/translations.dart';
import 'package:referaly/widgets/primary_button.dart';
import '../../languages/languagekeys.dart';

class ShowWelcomeToProfessionalDialog extends StatelessWidget {
  const ShowWelcomeToProfessionalDialog({super.key});

  Map<String, Map<String, String>> getWelcomeTexts() {
    return {
      'en': {
        'title': '🎉 Welcome to your professional dashboard!',
        'subtitle': 'With this new interface:',
        'text': '''
🔁 Refer prospects to other professionals  
📩 Receive recommendations for your own business  
👥 Invite your referrers — professionals or individuals  
🚀 Grow your network with ease
'''
      },
      'fr': {
        'title': '🎉 Bienvenue sur votre espace professionnel !',
        'subtitle': 'Avec cette nouvelle interface :',
        'text': '''
🔁 Vous pouvez recommander des prospects à d'autres professionnels  
📩 Vous recevez des recommandations pour votre propre activité  
👥 Invitez vos apporteurs d'affaires — professionnels ou particuliers  
🚀 Développez votre réseau en toute simplicité
'''
      },
      'es': {
        'title': '🎉 ¡Bienvenido a tu espacio profesional!',
        'subtitle': 'Con esta nueva interfaz:',
        'text': '''
🔁 Puedes recomendar prospectos a otros profesionales  
📩 Recibes recomendaciones para tu propia actividad  
👥 Invita a tus prescriptores — profesionales o particulares  
🚀 Haz crecer tu red fácilmente
'''
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppPreference.readString(AppPreference.appLanguage) ?? 'en';
    final content = getWelcomeTexts()[lang] ?? getWelcomeTexts()['en']!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  content['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  content['subtitle']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content['text']!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.65,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  text: tr(LanguageKeys.okay),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

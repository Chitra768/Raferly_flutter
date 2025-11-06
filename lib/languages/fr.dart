import 'package:referaly/languages/en.dart';

import 'languagekeys.dart';

final Map<String, String> fr = {
// welcome page
  LanguageKeys.Welcome: 'Bienvenue sur Referaly',
  LanguageKeys.createAccont: 'Créer un Compte',
  LanguageKeys.login: 'Se connecter',

// Change Language
  LanguageKeys.letsGo: 'Allons-y!!!',
  LanguageKeys.chooseLanguage: 'Choisissez la langue',

// ReferalyFinderButtonText

  LanguageKeys.matchyourleadswith:
      'Trouvez les réponses à toutes vos questions',
  LanguageKeys.matchyourleadswith1:
      'Recommander et être recommandé par d’autres professionnels de Referaly',
  LanguageKeys.trustedprofessionals:
      "d'être recommandé par d'autres professionnels",
  LanguageKeys.FindReferalers: 'Réseauter dès maintenant',
// login page
  LanguageKeys.loginToContinue: 'Se connecter',
  LanguageKeys.welcomeBacktreferaly: 'Bienvenue sur Referaly',
  LanguageKeys.email: 'Email',
  LanguageKeys.enterEmail: 'Entrer Email',
  LanguageKeys.password: 'Mot de Passe',
  LanguageKeys.enterPassword: 'Mot de Passe',
  LanguageKeys.forgotPassword: 'Mot de Passe oublié?',
  LanguageKeys.donthaveanAccount: "Vous n'avez pas de compte?",
  LanguageKeys.signup: 'Créer un compte',
  LanguageKeys.LetsGetYouConnected: 'Pour aller plus loin !',
  LanguageKeys.createAnAccount: 'Se connecter en 2 secondes',
  LanguageKeys.createAnAccountSignIn: 'Se créer un compte en 2 secondes',
//intro sliders
  LanguageKeys.next: 'Suivant',
  LanguageKeys.getstarted: '📝Créer votre programme d’apport d’affaires',
  LanguageKeys.skip: 'Passer',
  LanguageKeys.introtitle_1: "Boostez\n  Votre Réseau d'Affaires",
  LanguageKeys.introtitle_2: 'Recommandations\n Simplifiées',
  LanguageKeys.introtitle_3: 'Suivi\n  Prospects Simplifié',
  LanguageKeys.introtitle_4:
      'Tout-en-Un :\n Signature, Centre de Prospects,\n Suivi, Facturation',
  LanguageKeys.introtitle_5: '⁠Accès Rapide & Intuitif',

  LanguageKeys.introtext_1:
      "Créez vos événements d'apport d'affaires et\n invitez clients et professionnels à vous recommander. Vos contrats sont générés automatiquement via Referaly !",
  LanguageKeys.introtext_2:
      "Vos apporteurs d'affaires envoient des prospects directement via l'app, centralisant ainsi toutes les infos clés dans votre espace privé. Accédez facilement à un vivier de prospects qualifiés.",
  LanguageKeys.introtext_3:
      "Pourquoi perdre du temps en suivi manuel ? Notre plateforme automatise cette tâche et informe vos collaborateurs de l'évolution des prospects.",
  LanguageKeys.introtext_4:
      "Fatigué de jongler entre différents outils ? Referaly simplifie tout : de l'acceptation des conditions à la facturation, tout est automatisé.",
  LanguageKeys.introtext_5:
      'Comment connecter instantanément avec de nouveaux apporteurs ? Un simple partage de lien ou un QR code via WhatsApp, email ou LinkedIn suffit pour démarrer une collaboration efficace.',

// register page
  LanguageKeys.register: 'Se créer un compte',
  LanguageKeys.welcomeTotreferaly: 'Bienvenue sur Referaly',
  LanguageKeys.firstName: 'Prénom',
  LanguageKeys.lastName: 'Entrez le nom',
  LanguageKeys.phoneNumber: 'Numéro de téléphone',
  LanguageKeys.alredyHaveAcc: 'Vous avez déjà un compte?',
  LanguageKeys.enterName: 'Entrer Prénom',
  LanguageKeys.enterFirstName: 'Entrez le prénom',
  LanguageKeys.enterLastName: 'Entrer le nom de famille',
  LanguageKeys.enterNum: 'Entrer numéro',
  LanguageKeys.minimum8Char: 'mot de passe de minimum 8 caractères',
  LanguageKeys.invalidEmail: 'Veuillez entrer une adresse e-mail valide',
  LanguageKeys.firastNameError: 'Veuillez saisir votre prénom',
  LanguageKeys.lastNameError: 'Veuillez entrer votre nom de famille',
  LanguageKeys.phoneNumError: 'Veuillez entrer le numéro de téléphone',
  LanguageKeys.professional: 'Professionnel',
  LanguageKeys.individual: 'individuel',
  LanguageKeys.city: 'Ville',
  LanguageKeys.enterCity: 'Entrez la ville',
  LanguageKeys.cityError: 'Veuillez entrer la ville',
  LanguageKeys.cityErrorOnlyChar:
      'Please enter a valid city name. Only letters are allowed.',
  LanguageKeys.jobError: 'Veuillez saisir le poste',
  LanguageKeys.jobTypeError: 'Veuillez sélectionner le type de travail',
  LanguageKeys.companyType: "Type d'utilisateur",
  LanguageKeys.selectJob: 'Sélectionnez un emploi',

//forgot password
  LanguageKeys.forgotPassword: 'Mot de passe oublié?',
  LanguageKeys.forgotPassSubtext:
      "Aucun problème ! Indiquez nous l'email relié à votre compte Referaly",
  LanguageKeys.enterYourEmail: 'Entrer votre Email',
  LanguageKeys.Continue: 'Suivant',

//enter otp code
  LanguageKeys.entercode: 'Entrez le code',
  LanguageKeys.enterCodesubtext:
      "Rentrer le code de validation que nous venons d'envoyer à l'email indiqué précedemment",
  LanguageKeys.sendCodeagain: 'Renvoyer le code',
  LanguageKeys.verify: 'Vérifier',
  LanguageKeys.didntreceivedcode: "Je n'ai pas reçu de code.",
  LanguageKeys.resend: 'Réessayer',
  LanguageKeys.wrongCode: 'Mauvais code, essayez de nouveau',

// create new password
  LanguageKeys.createNewPass: 'Nouveau mot de passe',
  LanguageKeys.createNewPasssubtext:
      'Votre nouveau mot de passe doit être différent de ceux déjà utilisés.',
  LanguageKeys.newPass: 'Nouveau Mot de passe',
  LanguageKeys.confirmPass: 'Confirmer Mot de passe',
  LanguageKeys.submit: 'Soumettre',

  LanguageKeys.passChanged: 'Nouveau mot de passe créé',
  LanguageKeys.passChangedSubtext:
      'Votre Mot de Passe a été modifié avec succès !',
  LanguageKeys.backtoLogin: 'Se connecter',
  LanguageKeys.confirmPassError:
      'Le mot de passe et le mot de passe de confirmation ne correspondent pas',

//side menu
  LanguageKeys.preorderpage: 'Premium',
  LanguageKeys.myprofile: 'Mon profil',
  LanguageKeys.language: 'Langue',
  LanguageKeys.logout: 'Se déconnecter',

// pre order page
  LanguageKeys.comingsoon: 'Bientôt disponible',
  LanguageKeys.jun2024: 'JUIN 2024',
  LanguageKeys.getrecomget:
      "Plus d'apporteurs d'affaires,", // Changed After 15th July Doc Shared 'Plus Réseau d'Affaires,',
  LanguageKeys.morelead: 'Plus de Clients',
  LanguageKeys.creatNmanageyournetwork: 'Créez et gérez votre réseau',
  LanguageKeys.bussinessreferrence: "Liste de vos apporteurs d'affaires",
  LanguageKeys.preorder: 'Précommander',
  LanguageKeys.dollar200lifetime: '€ 300 Paiement Unique',
  LanguageKeys.lifetime300IOS: '{{value}} Paiement Unique',
  LanguageKeys.lifetimeaccess: 'Accès à vie pour €300 au lieu de €600/an',
  LanguageKeys.lifetimeaccessIOS:
      'Débloquez toutes les fonctionnalités pour {{value}}',
  LanguageKeys.earn50oneachreferal:
      'Partage Et Reçois 50€ Pour Toi Et Pour Ton Filleul',
  LanguageKeys.share: 'Partager \nle contact',
  LanguageKeys.seeDesigns: 'voir les designs',
  LanguageKeys.euro200: '€ 200.00',
  LanguageKeys.totalreferred: 'Nombre de Filleuls :',
  LanguageKeys.applycouponcode: 'Appliquer Code de parrainage',
  LanguageKeys.withoutcouponcode: 'Sans Code',
  LanguageKeys.codeError: 'Veuillez entrer le code',
  LanguageKeys.shareTxt_one:
      "Salut ! Je te partage cette application qui te permet de développer, centraliser et gérer tes réseaux d'apporteurs d'affaires ! Je pense que ça peut t'être utile dans ton activité.\nÇa s'appelle Referaly et ils ont actuellement une offre de lancement qui te garantit un accès à vie au lieu d'un abonnement. Avec mon code ",
  LanguageKeys.shareTxt_two: ', tu as 50 euros de réduction !',

//edit profile
  LanguageKeys.editprofile: 'Modifier profil',
  LanguageKeys.job: 'Profession',
  LanguageKeys.enterJob: 'Entrer le travail',
  LanguageKeys.industry: "Secteur d'activité",
  LanguageKeys.country: 'Pays',
  LanguageKeys.city: 'Ville',
  LanguageKeys.choosefromlib: 'Sélectionner depuis la galerie',
  LanguageKeys.takePicture: 'Prendre une photo',

// error comp
  LanguageKeys.okay: "D'accord",
  LanguageKeys.success: 'Succès',
  LanguageKeys.whoops: 'Oups',
  LanguageKeys.other: 'Autre',
  LanguageKeys.unauthenticateUserMsg:
      "L'utilisateur connecté n'est pas authentifié. Veuillez vous reconnecter.",

//New key
  LanguageKeys.noDataFound: 'Aucune donnée trouvée',
  LanguageKeys.commisionValue: 'Valeur de la commission',
  LanguageKeys.pleaseEnterCommissionValue:
      'Veuillez saisir la valeur de la commission',
  LanguageKeys.enterCommissionValue: 'Entrez la valeur de la commission',
  LanguageKeys.deleteAccount: 'Supprimer le compte',
  LanguageKeys.deleteAccountConfirmation:
      'Êtes-vous sûr de vouloir supprimer le compte ?',
  LanguageKeys.paymentCancel: 'Le paiement est annulé.',

//newlyAdded
  LanguageKeys.myDeal: 'Pour\nmon\nactivité',
  LanguageKeys.viewLeads: 'View Leads',
  LanguageKeys.shareDeal: 'Inviter un\n apporteur',
  LanguageKeys.commision: 'Commission',
  LanguageKeys.dealDescription: 'Description',
  LanguageKeys.companyDetails: "Information d'entreprise",
  LanguageKeys.cancel: 'Annuler',
  LanguageKeys.invitedDeals: 'Je suis prescripteur',
  LanguageKeys.leadRecieved: 'Contacts\nreçus',
  LanguageKeys.leadSent: 'Contacts\nenvoyés',
  LanguageKeys.incomeGenerated: 'Revenus générés',
  LanguageKeys.leadSentTab: 'Contacts\nenvoyés',
  LanguageKeys.leadReceivedTab: 'Contacts\nreçus',
  LanguageKeys.submitALead: 'Envoyer un\n contact',
  LanguageKeys.createADeal: "Créer un contrat d'apport d'affaires",
  LanguageKeys.partnerWithCompanies: 'à venir',
  LanguageKeys.chooseOneOptionBelow: 'Actions',
  LanguageKeys.viewDeal: 'Voir',
  LanguageKeys.hi: 'Bonjour',
  LanguageKeys.thisIsYour: 'Ceci est votre progrès',
  LanguageKeys.activeDeal: 'Vos programmes',
  LanguageKeys.frequentlyAsked: 'Vos partenaires & réductions',
  LanguageKeys.commisionEvent: "Apport d'Affaires",
  LanguageKeys.shareApp: "Partager l'application",
  LanguageKeys.somethingWent: "Quelque chose s'est mal passé",
  LanguageKeys.pleaseTry: 'Veuillez réessayer',

// New Error Key
  LanguageKeys.emptyEmail: "Veuillez entrer l'adresse e-mail",
  LanguageKeys.emptyFirstName: 'Veuillez entrer le prénom',
  LanguageKeys.emptyLastName: 'Veuillez entrer votre nom de famille',
  LanguageKeys.emptyPassword: 'Veuillez entrer le mot de passe',
  LanguageKeys.emptyNewPass: 'Veuiwe arelez entrer le nouveau mot de passe',
  LanguageKeys.emptyRePass: 'Veuillez ressaisir le mot de passe',

// Premium Modal
  LanguageKeys.unlockPremiumHeader:
      'Débloquez les fonctionnalités premium de Referaly',
  LanguageKeys.getItNow: 'Obtenez le maintenant',
  LanguageKeys.moreBillingOptions: "Plus d'options de facturation",
  LanguageKeys.launchOffer: 'Offre de lancement',
  LanguageKeys.unloackFeatureDevelop:
      'Développez, centralisez et gérez vos réseaux de prescripteurs',
  LanguageKeys.unloackFeatureAutomate:
      'Automatisation des contrats et des factures de commission',
  LanguageKeys.unloackFeatureInvitation:
      'Invitation facile via QR code ou lien (WhatsApp, LinkedIn, email...)',
  LanguageKeys.unloackFeatureAllIn:
      'Outil tout-en-un pour rendre la recommandation facile et intuitive',
  LanguageKeys.unloackFeatureTrack: 'Suivi automatisé de vos dossiers clients',
  LanguageKeys.annual: 'ANNUEL',
  LanguageKeys.monthly: 'MENSUEL',
  LanguageKeys.payNow: 'Payez maintenant',

  LanguageKeys.businessLeads: 'Vos prospects',

  LanguageKeys.submitDeal: 'Créer le programme',
  LanguageKeys.faqs: 'FAQs',

  LanguageKeys.edit: 'Modifier',
  LanguageKeys.delete: 'Supprimer',
  LanguageKeys.enterComment: 'Entrez un commentaire',

  LanguageKeys.or: 'ou', // Changed After 15th July Doc Shared 'OR',
  LanguageKeys.viewDocuments: 'Voir le document',
  LanguageKeys.seeAll: 'Voir tous mes apporteurs d’affaires',
  LanguageKeys.external: 'Externe',
  LanguageKeys.enterAmount: 'Entrer montant',
  LanguageKeys.yes: 'Oui',
  LanguageKeys.no: 'Non',
  LanguageKeys.notificationHeader: 'Notification',
  LanguageKeys.dealInvitation: 'Deal invitation',
  LanguageKeys.dealAccept: 'Aceptar',

  LanguageKeys.detailAboutDeal: "Détails sur l'accord",
  LanguageKeys.editDeal: 'Modifier\ncontrat',
  LanguageKeys.updateDeal: 'Mettre à jour le contrat',
  LanguageKeys.numberOfPartners: "Apporteurs\nd'affaires",
//New Keys
  LanguageKeys.shareTheApp: "Partager l'application",
  LanguageKeys.get40Percent: '¡Recibe una recompensa de 50 euros!',
  LanguageKeys.trackYourLead: 'Suivi des prospects',
  LanguageKeys.reviewContract: 'Voir contrat',
  LanguageKeys.leads: 'Prospect',
  LanguageKeys.track: 'Suivi',
  LanguageKeys.referrers: "Apporteurs d'affaires",
  LanguageKeys.commingSoon: 'À venir',

// Company Form
  LanguageKeys.companyName: 'Nom de votre entreprise',
  LanguageKeys.companyAddress: 'Adresse de votre entreprise',
  LanguageKeys.companyPhoneNumber: "Votre numéro d'entreprise",
  LanguageKeys.companyLogo: "Logo d'entreprise",
  LanguageKeys.companyProfile: "Profil de l'entreprise",
  LanguageKeys.editCompanyProfile: "Votre profil d'entreprise",
  LanguageKeys.enterCompanyName: "Entrez le nom de l'entreprise",
  LanguageKeys.enterCompanyAddress: "Entrez l'adresse de l'entreprise",
  LanguageKeys.enterCompanyNumber: "Entrez le numéro de l'entreprise",
  LanguageKeys.companyNameError: "Veuillez entrer le nom de l'entreprise",
  LanguageKeys.companyAddressError: "Veuillez saisir l'adresse de l'entreprise",
  LanguageKeys.companyPhoneError:
      'Veuillez entrer un numéro de téléphone valide',
  LanguageKeys.companyLogoError:
      "Veuillez sélectionner le logo de l'entreprise",

// LanguageKeys.profileTypeError: `To Create Deal Your Account Must Be ${languagekeys.professional.toUpperCase()}`,
  LanguageKeys.profileTypeError:
      "Pour créer un programme partenaire, vous avez besoin d'un compte professionnel",
  LanguageKeys.commissionReceived:
      'Commissions\nreçues', // Changed After Feedback of 15th July Doc Shared 'Commission(S) reçues', //'Prospects envoyés',
  LanguageKeys.documentsHeader: 'Documents',

  LanguageKeys.admin: 'Administrateur',
  LanguageKeys.invited: 'Invité',

  LanguageKeys.createdDate: 'Date de création',
  LanguageKeys.acceptedDate: "Date d'acceptation",
  LanguageKeys.lostLeadConfirmation:
      "Ce prospect perdu est désormais accessible dans l'espace 'Historique' de Referaly.",
  LanguageKeys.lostLead: 'Marquer comme prospect perdu',
  LanguageKeys.agreeAndAccept: "J'ai lu et j'accepte les conditions du contrat",
  LanguageKeys.new_deal: "Votre mission d'apport d'affaires",
  LanguageKeys.leadSubmissionForm: 'Ajouter le prospect',
  LanguageKeys.submitLead: 'Ajouter le prospect',
  LanguageKeys.chooseDeal: 'Choisir entreprise',
  LanguageKeys.selectDeal: 'Sélectionner le contrat',
  LanguageKeys.detailAboutLead: 'Détail du prospect',

  LanguageKeys.agreeLeadTxt:
      "Je certifie que le prospect dont j'envoie les informations via Referaly a consenti au partage de ses données et à leur transmission à une autre entreprise.",
  LanguageKeys.enterDealName: 'Nom',
  LanguageKeys.nameOfDeal: 'Nom du contrat',
  LanguageKeys.commissionShared: 'Commission partagée',
  LanguageKeys.chooseOneoption: 'Choisir une option',
  LanguageKeys.no_commission: 'Pas de commission',
  LanguageKeys.fix_commission: 'Commission fixe',
  LanguageKeys.percentage_commission: 'Commission au %',
  LanguageKeys.contractOfDeal: "Contrat d'apport d'affaires",
  LanguageKeys.payTheCommission: 'Payer la commission',
  LanguageKeys.amountPaid: 'Montant payé',
  LanguageKeys.createYourFirst:
      "Créer votre premier contrat d'apport d'affaires et commencer à inviter des prescripteurs",
  LanguageKeys.createButton: 'créer',
  LanguageKeys.becomeABusiness:
      "Demandez à un professionnel de vous inviter à le recommander via son lien ou QR code. Vous aurez un contrat de commissionnement ainsi qu'un suivi en temps réel de vos recommandations !",
  LanguageKeys.appWithNetwork: "Partagez l'app avec votre réseau !",
  LanguageKeys.findBusinessReferres: "Rejoindre un réseau d'affaires",
  LanguageKeys.seeDescription: 'Voir la description',
  LanguageKeys.noDeals: 'Aucune offre',
  LanguageKeys.shareNow: 'Partager',
  LanguageKeys.new_deal: "Contrat d'Apport d'Affaires",
  LanguageKeys.comapnyLabel: 'SIREN',
  LanguageKeys.invalidCommissionValue:
      'Veuillez entrer une valeur de commission valide',
  LanguageKeys.description: 'Description',
  LanguageKeys.contractText: 'Contrat',

  LanguageKeys.noCommisionValue: 'Pas de commission',
  LanguageKeys.fixCommissionValue: 'Commission fixe',
  LanguageKeys.percentageCommissionValue: 'Commission au %',

  LanguageKeys.preOrderSubtitle:
      "Développer, centraliser et gérer vos réseaux d'apporteurs d'affaires",
  LanguageKeys.summerOffer: "Offre d'été",

//New keys
  LanguageKeys.inviteCollab: 'Inviter des collaborateurs',
  LanguageKeys.numberOfCollaborators: 'Nombre de collaborateurs',
  LanguageKeys.noCollaborators:
      'Demandez à vos collègues de se créer un compte Referaly gratuitement, puis taper leur nom dans la barre de recherche pour les ajouter à votre équipe.',
  LanguageKeys.acceptThePolicies: 'Accepter les ',
  LanguageKeys.feedbacks: 'Notifier un bug',
// Picker types
  LanguageKeys.submitFeedback: 'Envoyer',
  LanguageKeys.featureIdea: 'Idée de fonctionnalité',
  LanguageKeys.reportABug: 'Signaler un bug',
  LanguageKeys.feedbackTypes: 'Types',
  LanguageKeys.searchPlaceholder: 'Rechercher',
  LanguageKeys.noSearchResults: 'Aucun résultat de recherche trouvé',
  LanguageKeys.tryDifferentKeywords: 'Essayez différents mots-clés',
  LanguageKeys.resultsFound: 'résultats trouvés',
  LanguageKeys.sendNotification: 'Envoyer une notification',
  LanguageKeys.notificationErrorText:
      'Veuillez entrer le message de notification',
  LanguageKeys.copyLinkBelow: 'Ou copiez le lien ci-dessous',
  LanguageKeys.joinTheDeal: 'Rejoindre le programme partenaire',
  LanguageKeys.send: 'Envoyer',
  LanguageKeys.uploadAndNotify: 'Ajouter et notifier votre réseau',
  LanguageKeys.browseFile: "Parcourir le fichier à partir d'ici",
  LanguageKeys.uploadFile: 'Ajouter le fichier',
  LanguageKeys.trackName: 'Étapes de suivi pour vos apporteurs',
  LanguageKeys.enterTrackName: 'Entrez le nom',
  LanguageKeys.addLead: 'Ajouter un prospect',
  LanguageKeys.mySelf: 'Moi-même',
  LanguageKeys.businessReferrer: "Apporteur d'Affaires",
  LanguageKeys.noBusinessReferrer: "Aucun apporteur d'affaires",
  LanguageKeys.note: 'Note',
  LanguageKeys.title: 'Titre',
  LanguageKeys.titleErrorText: 'Veuillez entrer le titre de la notification',
  LanguageKeys.selectReferrer: "Sélectionner l'apporteur d'affaires",
  LanguageKeys.addnew: 'Nouvelle étape',
  LanguageKeys.minimumTrack: 'Au moins un nom est requis.',
  LanguageKeys.trackNameCannot: 'Le nom ne peut pas être vide.',
  LanguageKeys.trackNameRequired: 'Le nom est requis.',
  LanguageKeys.searchBy: 'Rechercher par e-mail...',
  LanguageKeys.selectBusinessReferrer: "Sélectionnez un apporteur d'affaires",
  LanguageKeys.updateRequired: 'Mise à jour disponible',
  LanguageKeys.updateRequiredText:
      "Une nouvelle version de l'application est disponible avec des fonctionnalités améliorées.",
  LanguageKeys.youWillBeRedirectedToTheAppStoreText:
      "Vous serez redirigé vers votre boutique d'applications",
  LanguageKeys.updateNow: 'Mettre à jour maintenant',
  LanguageKeys.updateLead: 'Mettre à jour le contact',
  LanguageKeys.leadDetails: 'Details',
  LanguageKeys.fullName: 'Nom complet',
  LanguageKeys.invitedDeal: 'Programmes invités',
  LanguageKeys.suggestedDeal: 'Découvrir',
  LanguageKeys.addLeadButton: 'Ajout manuel',
  LanguageKeys.view: 'Voir',
  LanguageKeys.home: 'Accueil',
  LanguageKeys.whatAreYou: 'Entrer le nom du compte de vos collaborateurs',
  LanguageKeys.searchCollaorators: 'Chercher',
  LanguageKeys.descriptionSubmitFeedback: 'Description',
  LanguageKeys.assignLeadType: 'Source',
  LanguageKeys.optionModalSubmitLead: 'Envoyer un contact',
  LanguageKeys.notificationDescription: 'Message',
  LanguageKeys.shareQR: 'Partager',
  LanguageKeys.nullDataText: 'Non renseigné',
  LanguageKeys.createDealDescription: 'Description de votre service',
  LanguageKeys.dealTabHeader: "Je suis apporteur d'affaires",
  LanguageKeys.assignModalSubmit: 'Ajouter',
  LanguageKeys.privacyPolicy: 'politique de confidentialité',
  LanguageKeys.chooseDealAssignLead: 'Choisir Programme',
  LanguageKeys.selectDealAssignLead: 'Sélectionner programme',
  LanguageKeys.pleaseEnterDealName: 'Veuillez entrer le nom du contrat',
  LanguageKeys.pleaseSelectCommType:
      'Veuillez sélectionner le type de commission',
  LanguageKeys.enterDescriptionErr: "Détails du contact",
  LanguageKeys.selectDealErr: 'Veuillez sélectionner un programme',
  LanguageKeys.selectLeadType: 'Veuillez sélectionner le type de contact',
  LanguageKeys.documentIsCancel: 'Le document est annulé',
  LanguageKeys.pleaseEnterCommissionForLeadReceived:
      'La valeur de la commission est requise.',
  LanguageKeys.archive: 'Historique des affaires',
  LanguageKeys.recover: 'Récupérer',
  LanguageKeys.lost: 'Perdu',
  LanguageKeys.succeeded: 'Réussi',
  LanguageKeys.noArchiveReceive:
      "Vous trouverez ici la liste des prospects que vous avez reçus via Referaly et dont le dossier a été clôturé",
  LanguageKeys.noArchiveSent:
      "Vous trouverez ici la liste des prospects que vous avez recommandés et dont le dossier a été clôturé",
  LanguageKeys.notInterested: 'Pas intéressé',
  LanguageKeys.neverReplies: "N'a jamais répondu/a cessé de répondre",
  LanguageKeys.incorrectInfo: 'Informations incorrectes',
  LanguageKeys.reasonValidation: 'Veuillez sélectionner au moins une raison',
  LanguageKeys.lableArchive: 'Libellé',
  LanguageKeys.dateArchive: 'Date',
  LanguageKeys.reason: 'Raison',
  LanguageKeys.importFromContact: 'Importer depuis mon répertoire',
  LanguageKeys.contactCalled: 'Contact appelé',
  LanguageKeys.contractSigned: 'Contrat signé',
  LanguageKeys.serviceDeleiverd: 'Service délivré',
  LanguageKeys.paymentReceived: 'Paiement reçu',
  LanguageKeys.commisionPaid: 'Commission payée',
  LanguageKeys.clickHereToDownload:
      'Cliquez ici pour télécharger le fichier PDF.',
  LanguageKeys.referalyFinder: 'Referaly Finder',
  LanguageKeys.weFind:
      'Nous trouvons un professionnel pour votre contact et négocions une commission pour vous',
  LanguageKeys.typeOfProfessional:
      'Quel professionnel cherchez vous pour votre contact',
  LanguageKeys.moreInfo: "Plus d'infos que vous souhaitez partager",
  LanguageKeys.typeOfProfessionalPlaceholder: 'Type de professionnel',
  LanguageKeys.typeOfProfessionalError:
      'Veuillez entrer le Quel professionnel cherchez vous',
  LanguageKeys.enterMoreInfo: "Entrez plus d'informations",
  LanguageKeys.finderFooterText:
      "Referaly sera responsable de trouver un professionnel qui peut aider votre contact. Si vous souhaitez recevoir une commission pour ce référencement, nous négocierons en votre nom pour l'obtenir. Veuillez noter qu'aucune information sur le contact ne sera partagée tant qu'un accord signé n'est pas en place entre vous et le professionnel.",
  LanguageKeys.finderFooterSecondText: '¡Te contactaremos en una semana!',
  LanguageKeys.permissionDenied: 'Accès refusé',
  LanguageKeys.storagePermissionForPreview:
      "L'autorisation de stockage est requise pour prévisualiser les fichiers.",
  LanguageKeys.widgetDescription:
      'On trouve un professionnel pour votre prospect',
  LanguageKeys.finderConfirmation: 'Are you sure you want to submit a lead?',
  LanguageKeys.finderDescriptionField: 'Description du besoin de votre contact',
  LanguageKeys.finderLeadInfo: 'Information de votre contact',
  LanguageKeys.discoverReferaly: 'Découvrez Referaly Finder !',
  LanguageKeys.quickFind:
      'Trouvez rapidement des professionnels qualifiés de confiance à qui recommander vos contacts — avec une commission en option !',
  LanguageKeys.whyUse: 'Pourquoi utiliser Referaly Finder ?',

  LanguageKeys.extensiveProfessional: 'Large réseau de professionnels :',
  LanguageKeys.easilyConnect:
      'Rencontrez facilement des partenaires sérieux et qualifiés parmi notre sélection.',
  LanguageKeys.transparency: 'Transparence et flexibilité :',
  LanguageKeys.wantACommission:
      'La commission ? On la négocie pour vous, uniquement si vous le souhaitez !',

  LanguageKeys.peopleFirst: 'Rencontres humaines avant tout :',
  LanguageKeys.engageDirectly:
      'Échangez avec chaque professionnel pour valider son sérieux et étoffer votre réseau.',
  LanguageKeys.freeService: 'Service 100 % gratuit :',
  LanguageKeys.noFees:
      "Aucun frais à prévoir — notre priorité, c'est de faciliter vos mises en relation !",
  LanguageKeys.youGain:
      'Vous gagnez en visibilité, eux en contacts — une vraie collaboration gagnant-gagnant !',
  LanguageKeys.letGo: 'Allons-y !',
  LanguageKeys.contactSent: 'Contact envoyé !',
  LanguageKeys.weReNow:
      'Nous travaillons à trouver le professionnel idéal pour vous. Nous vous recontacterons par email ou téléphone sous 5 jours ouvrables !',
  LanguageKeys.perfect: 'Parfait !',
  LanguageKeys.userLeadInfo: 'Information du contact client',
  LanguageKeys.myPrograms: 'Mes contrats',
  LanguageKeys.myNetwork: 'Mon Réseau',
  LanguageKeys.createDeal: 'Créer un nouveau contrat',
  LanguageKeys.dealSelector: 'Envoyez une notification',
  LanguageKeys.specificDeal: "Aux apporteurs de",
  LanguageKeys.allDeals: 'Tous les contrats',
  LanguageKeys.uniqueCommision: 'Commission\nUnique',
  LanguageKeys.differentCommision: 'Différentes\ncommissions',
  LanguageKeys.itWillSpecified:
      'Si vous proposez un seul type de commission ou aucune commission',
  LanguageKeys.leadType: 'Type de contact',
  LanguageKeys.enterLeadType: 'Indiquez le type de prospect',
  LanguageKeys.addCase: 'Ajouter un cas',
  LanguageKeys.generateContract: 'Générer automatiquement le contrat',
  LanguageKeys.clickHere: 'Voir template',
  LanguageKeys.uploadYourOwn: 'Téléchargez votre propre contrat',
  LanguageKeys.pleaseSelectLeadType: 'Veuillez entrer le type de contact',
  LanguageKeys.detailsAboutCompany: "Détails sur l'entreprise",
  LanguageKeys.lastContractAccepted: 'Dernier contrat accepté',
  LanguageKeys.youHaveSelected:
      'Vous avez sélectionné tous les contrats. Les actions seront appliquées à tous les éléments',
  LanguageKeys.shareDirect: 'Partager Directement',
  LanguageKeys.contract: 'Contrat',
  LanguageKeys.selectAll: 'Tout Sélectionner',
  LanguageKeys.deselectAll: 'Tout Désélectionner',
  LanguageKeys.theDetailsOfTheDeal:
      'Les détails des commissions se trouvent dans le contrat ci-dessous',
  LanguageKeys.clickHereToViewFull: 'Cliquez ici pour voir le contrat complet',
  LanguageKeys.byRecommendingThis:
      "En recommandant ce professionnel via Referaly, vous aurez accès gratuitement à un espace privilégié en tant que prescripteur, ainsi qu'à un suivi en temps réel de vos recommandations.",
  LanguageKeys.pleaseCheckYour:
      'Veuillez vérifier votre connexion internet et réessayer',
  LanguageKeys.networkError: 'Erreur de Réseau',
  LanguageKeys.contactAccess: "Permission d'accès aux contacts",
  LanguageKeys.weNeedAccess:
      "Nous avons besoin d'accéder à vos contacts pour vous aider à remplir rapidement les champs vides",
  LanguageKeys.storagePermission:
      'Une autorisation de stockage est nécessaire pour télécharger des fichiers',
  LanguageKeys.newest: 'Le Plus Récent',
  LanguageKeys.oldest: 'Le Plus Ancien',
  LanguageKeys.iHaveRead:
      "J'ai lu et j'accepte les termes et conditions du contrat",
  LanguageKeys.forYou: 'Pour vous',
  LanguageKeys.upTo: "Jusqu'à",
  LanguageKeys.inviteLinkCopied: 'Lien copié avec succès.',
  LanguageKeys.youCanNowShare:
      'Vous pouvez maintenant le coller dans un message',
  LanguageKeys.invitedSubmitLead: 'Envoyer un contact',
  LanguageKeys.invitedDealsHomePage: "Je suis\n apporteur\n d'affaires",
  LanguageKeys.ifYouAreOffer:
      'Si vous proposez différents types de commissions en fonction du contact reçu',
  LanguageKeys.collabInfo: 'Donnez-leur accès à vos apporteurs et prospects.',
  LanguageKeys.docInfo:
      'Téléchargez des fichiers que vos apporteurs peuvent consulter et partager.',
  LanguageKeys.shareInfo:
      'Partagez des contrats et invitez de nouveaux apporteurs.',
  LanguageKeys.notificationInfo:
      ' Envoyez des mises à jour directement à vos apporteurs.',
  LanguageKeys.addTeam: 'Ajouter des collègues',
  LanguageKeys.shareDoc: 'Partager des documents',
  LanguageKeys.inviteRefe: 'Inviter des apporteurs',
  LanguageKeys.notifyRefe: 'Notifier les apporteurs',
  LanguageKeys.deleteCofirmation:
      "Veuillez noter que la suppression de ce contrat entraînera la suppression de tous les apporteurs d'affaires invités à ce dernier. Pour conserver leur participation, vous devrez les inviter à un nouveau contrat.",
  LanguageKeys.companyDetailsMydeal: 'Information',
  LanguageKeys.seeLess: 'Voir moins',
  LanguageKeys.deleteIamReferrer: 'Quitter le programme',
  LanguageKeys.successTheLead:
      "Succès ! Ce prospect, désormais client, est maintenant visible dans l'espace 'Historique' de Referaly",
  LanguageKeys.percentageCommission: 'Commission',
  LanguageKeys.phoneNumberNetwork: 'Téléphone',

//Send Lead out of referaly
  LanguageKeys.viaReferaly: 'via Referaly',
  LanguageKeys.outOf: 'En dehors de Referaly',
  LanguageKeys.sendLeadOut: "Envoyer en dehors de Referaly",
  LanguageKeys.sendLead: 'Envoyer un contact',
  LanguageKeys.outOfReferalyInfo:
      "Recommandez un professionnel qui n'est pas encore sur ReferaiReferaly ou qui ne vous a pas encore invité. Vos infos restent confidentielles tant que le contrat n'est pas accepté. Suivi sécurisé et transparent.",
  LanguageKeys.leadInfo: 'Information de votre contact client',
  LanguageKeys.generateAContract: 'Générer et Partager un contrat',
  LanguageKeys.hereIsYour: 'Voici votre lien',
  LanguageKeys.shareTheFollowing:
      'Partagez le lien suivant avec le professionnel à qui vous souhaitez envoyer le prospect',
  LanguageKeys.youWillBeProtected:
      'Vous serez protégé par un contrat et recevrez un suivi pour le prospect que vous avez envoyé',
  LanguageKeys.shareEasily: 'Partagez facilement',
  LanguageKeys.iHaveSharedMy: "J'ai déjà partagé mon lien",
  LanguageKeys.commisionTitle: 'La commission que vous souhaitez recevoir',
  LanguageKeys.createDealOutOf: "Créer un programme d'apport d'affaires",
  LanguageKeys.outOfTrackName: 'Le étapes de suivi que vous voulez avoir',
  LanguageKeys.fillCompany: "Remplir mes informations d'enterprise",
  LanguageKeys.congratulations:
      "Félicitations ! \n Quelqu'un veut vous envoyer un contact client ! \n Pour voir les informations du contact, créez d'abord un compte entreprise (gratuit) et acceptez le contrat envoyé par votre apporteur d'affaires.",
  LanguageKeys.businessIntroduce:
      "L'apporteur d'affaires ne demande pas de commission pour cette recommandation",
  LanguageKeys.sendAContact: 'Envoyer un contact',
  LanguageKeys.toAProfessional: "à un professionnel qui ne vous a pas invité",
  LanguageKeys.toAProfessional1:
      "à un pro, avec ou sans compte Referaly, qu’il vous ait invité ou non",
  LanguageKeys.businessReferrerName: "Apport d’affaires de:",
  LanguageKeys.outOfReferalyDealName: "Apport d'affaires",
  LanguageKeys.premiumInformativeText:
      "Avec la version gratuite vous pouvez ajouter maximum 5 apporteurs d'affaires",
  LanguageKeys.premiumInformativeTextLeads:
      'Avec la version gratuite vous pouvez recevoir maximum 2 contacts clients',
  LanguageKeys.sendDocument: 'Ajouter',
  LanguageKeys.theTrackingStep:
      "Ces étapes de suivi sont visibles par vous et vos apporteurs d'affaires, garantissant une transparence totale dans le traitement des recommandations qu'ils vous adressent.",
  LanguageKeys.somethingWentWrong:
      "Quelque chose s'est mal passé. Veuillez essayer de relancer l'application.",
  LanguageKeys.Consultingcallwithanexpert: 'Connectez-vous avec votre réseau',
  LanguageKeys.ConsultingcallwithanexpertDescription:
      'Connectez-vous avec votre réseau',
  LanguageKeys.Howitworks: 'Comment ça marche ?',
  LanguageKeys.HowitworksDescription: 'Trouvez les réponses à vos questions',
  LanguageKeys.HowitworksTitle: 'Comment ça marche?',
  LanguageKeys.dashboard: 'Tableau de bord',

// Newly Added
  LanguageKeys.TheprofessionalIwanttosendacontactto:
      'Sélectionner tous les programmes',
  LanguageKeys.HasalreadyinvitedmeonReferaly:
      'Sélectionner tous les programmes',
  LanguageKeys.HasnotinvitedmeonReferaly: "Veuillez entrer l'adresse e-mail",
  LanguageKeys.YourCurrentPlan: 'Votre Offre actuelle',
  LanguageKeys.inviteTitle:
      'Le professionnel à qui je souhaite envoyer un contact',
  LanguageKeys.inviteReferalyIconText: "M'a déjà \ninvité sur\n Referaly",
  LanguageKeys.inviteSendText: "ne m'a pas\ninvité sur\n Referaly",

//Premium screen
  LanguageKeys.Membership: 'Adhésion',
  LanguageKeys.GetPremium: 'Choisissez Votre Offre',
  LanguageKeys.Monthly: 'Mensuel',
  LanguageKeys.Yearly: 'Année',
  LanguageKeys.BuySubscription: "S'abonner",
  LanguageKeys.UpgradePlan: 'Offre supérieure',
  LanguageKeys.CancelPlan: 'Annuler le forfait',
  LanguageKeys.TabYearly: 'Annuel',
  LanguageKeys.BacktoHomePage: "Retour à la page d'accueil",
  LanguageKeys.Independent: 'Indépendant',
  LanguageKeys.VatTxt: '( TTC )',
  LanguageKeys.UniqueAccess: '1 accès unique',
  LanguageKeys.AgencyPremium: 'Offre Agence',

  LanguageKeys.FreeTrialDescription: '1 accès unique',
  LanguageKeys.FreeTrialPrice: '365 euros/an',

  LanguageKeys.AgencyDescription:
      "Jusqu'à 10 utilisateurs pour travailler en équipe, avec un compte administrateur et des comptes collaborateurs.",
  LanguageKeys.AgencyPrice: '645 euros/an',
  LanguageKeys.PlusPremiumDiscription:
      "➕ Ajouter un collaborateur sur l'agence premium.",
  LanguageKeys.RecievedPremiumDiscription:
      '🎯 Recevez un nombre illimité de clients potentiels.',
  LanguageKeys.CollaboratorPremiumDiscription:
      '🤝 Créez autant de programmes partenaires que vous le souhaitez.',
  LanguageKeys.DocumentPremiumDiscription:
      '🗂️ Stockez tous vos documents sans limites.',
  LanguageKeys.NotificationsPremiumDiscription:
      "📲 Envoyer des notifications aux apporteurs d'affaires.",
  LanguageKeys.Feature1: 'Créer des Programmes de Parrainage Illimités',
  LanguageKeys.Feature2: 'Générer des Contrats de Parrainage Illimités',
  LanguageKeys.Feature3:
      'Inviter des Parrains avec des Liens Personnalisés et des Codes QR',
  LanguageKeys.Feature4:
      'Partager Facilement les Formulaires de Parrainage - Même Hors de l\'App',
  LanguageKeys.Feature5:
      'Accéder à Notre Logiciel Complet de Parrainage pour Bureau',
  LanguageKeys.Feature6: 'Recevoir Votre Carte de Parrainage d\'Affaires NFC',
  LanguageKeys.Feature7: 'Coaching 1 à 1 pour Maximiser Vos Résultats',
  LanguageKeys.Feature8: 'Rejoindre les Réseaux d\'Affaires Premium Uniquement',
  LanguageKeys.PremiumHeading: 'Débloquez la Puissance Complète du Parrainage',
  LanguageKeys.PremiumSubtitle: 'avec Referaly Premium',
  LanguageKeys.PremiumIntroText:
      'Amenez votre entreprise au niveau supérieur avec un accès illimité à tout ce dont vous avez besoin pour attirer plus de clients et augmenter votre visibilité :',
  LanguageKeys.SubscriptionTextBox:
      'Que vous soyez freelance, consultant ou propriétaire d\'entreprise, Referaly Premium est votre raccourci vers une croissance plus intelligente.',
  LanguageKeys.SeePremiumOffers: 'Obtenir Premium Maintenant',
  LanguageKeys.GetPremiumNow: 'Obtenir Premium Maintenant',
  LanguageKeys.BackToHomePage: "Retour à la page d'accueil",
  LanguageKeys.BottomText:
      'Mettez à niveau maintenant et commencez à développer votre réseau de parrainage aujourd\'hui 👉',
// LanguageKeys.choosethebestplan: 'Choisissez le meilleur plan pour vous',
  LanguageKeys.ReferalyConnectedCard: 'Carte \nconnectée\nReferaly',
  LanguageKeys.connectedcard: 'Carte connectée\nReferaly',
  LanguageKeys.ConnectedCardDescription: 'Connectez-vous avec votre réseau',
  LanguageKeys.RefferalyCard:
      "Une carte exclusive pour partager vos infos et ajouter des apporteurs d'affaires en un instant.",
  LanguageKeys.NFCCardBUtton: 'Comment ça marche?',
  LanguageKeys.UnlimitedCoaching: 'Accompagnement sur mesure',
  LanguageKeys.UnlimitedCoachingdesc:
      "Profitez d'un coaching personnalisé et illimité avec un expert du réseautage",
  LanguageKeys.Membership: 'Adhésion',
  LanguageKeys.bookConsultation: 'Réserver une Consultation',
  LanguageKeys.expertNetworkConsulting: 'Consultation Expert en Réseautage',
  LanguageKeys.consultingDescription:
      'Obtenez des conseils personnalisés de nos experts en réseautage pour élargir vos connexions professionnelles et accélérer votre croissance de carrière.',
  LanguageKeys.availableTimes: 'Heures Disponibles',
  LanguageKeys.bookConsultationButton: 'Réserver une Consultation',
  LanguageKeys.chatOnWhatsapp: 'Discuter sur Whatsapp',
  LanguageKeys.questionsRegarding: 'Avez-vous des questions concernant?',
  LanguageKeys.yourActivity: 'Fonctionnalités premiums',
  LanguageKeys.businessReferrerFeatures:
      'Fonctionnalités d’apporteurs d’affaires',
  LanguageKeys.createReferralContract: 'Créer un contrat de parrainage',
  LanguageKeys.shareReferralContract: 'Partager le contrat de parrainage',
  LanguageKeys.addDocuments: 'Ajouter des documents',
  LanguageKeys.trackBusinessReferrer: "Suivre votre recommandeur d'affaires",
  LanguageKeys.editProfileCompanyInfo:
      "Modifier le profil et les informations de l'entreprise",
  LanguageKeys.setupConnectedCard: 'Configurer votre carte connectée',
  LanguageKeys.bookCall: 'Réserver un appel',
  LanguageKeys.referalyFinder: 'Recherche de parrainage',
  LanguageKeys.addLeadManually: 'Saisir manuellement',
  LanguageKeys.contactForm: 'Formulaire de contact',
  LanguageKeys.payCommissions: 'Payer les commissions',
  LanguageKeys.header: 'Votre Activité',
  LanguageKeys.chooseProfileType: 'Choisir le type de profil',
  LanguageKeys.professional: 'Professionnel',
  LanguageKeys.individual: 'Particulier',
  LanguageKeys.professionalDescription:
      "🔁 Envoyez et recevez des prospects\n\n🛠️ Accès à une plateforme complète pour gérer vos apports d'affaires\n\n📊 Suivi des commissions, signature de contrats, gestion de documents\n\n🌐 Accès à Referaly Finder pour élargir son réseau",

  LanguageKeys.individualDescription:
      "✅ Envoyez facilement des prospects à vos contacts professionnels\n\n💬 Suivez vos recommandations via une interface simplifiée\n\n🎁 Recevez des remerciements ou des commissions selon le cas",

// LanguageKeys.continue: 'Continuer',
  LanguageKeys.networkWithProfessionals:
      "Réseauter avec d'autres professionnels via Referaly",
  LanguageKeys.findBusinessReferrers: "Trouver des apporteurs d’affaires",
  LanguageKeys.alsoReferThem: 'Recommandez-les également',
  LanguageKeys.connectedCardDescription:
      'Une carte connectée que vous tapez sur le téléphone, facile et rapide',
  LanguageKeys.digitalVisitCard:
      'Une carte de visite numérique pour vos prospects, clients et partenaires',
  LanguageKeys.bestNetworkingTool: 'Votre meilleur outil de réseautage !!',
  LanguageKeys.standOutDifferent:
      'Démarquez-vous, soyez différent et commandez votre carte maintenant',
  LanguageKeys.BusinessNetwork: 'Réseau Professionnel',
  LanguageKeys.findYourBusinessNetwork: 'Trouvez votre réseau professionnel',
  LanguageKeys.referrerTypeLabel: 'Type de recommandateurs souhaité',
  LanguageKeys.standardOption: 'Standard',
  LanguageKeys.premiumOption: 'Premium',
  LanguageKeys.whoCanRefer: 'Personnes que vous pouvez recommander',
  LanguageKeys.shareCommissions: 'Partagez-vous les commissions?',
  LanguageKeys.yesOption: 'Oui',
  LanguageKeys.noOption: 'Non',
  LanguageKeys.clientLocation: 'Localisation du client',
  LanguageKeys.onlineOption: 'En ligne',
  LanguageKeys.inPersonOption: 'En personne',
  LanguageKeys.findReferrerButton: 'Trouver un recommandateur',
  LanguageKeys.successMessage: 'Profil mis à jour avec succès',
  LanguageKeys.consultationNote:
      'Nous aborderons également cela lors de votre appel de consultation.',
// LanguageKeys.viewDocuments: 'Voir documents & contrats',
// LanguageKeys.receiveCommission: 'Recevoir des commissions',
  LanguageKeys.alreadyHaveCard: 'Vous avez déjà une carte? Configurez la !',
  LanguageKeys.orderCard: 'Commander ma carte',
  LanguageKeys.startNetworkingNow: 'Commencez à réseauter maintenant',
  LanguageKeys.ConnectedCard: 'Carte connectée',
  LanguageKeys.selectYourStyle: 'Sélectionnez votre style',
  LanguageKeys.getItForPrice: 'Obtenez-la pour 60€ HT',
  LanguageKeys.getItForPriceTwo: 'Obtenez-la pour 75€ HT',
  LanguageKeys.getItForPriceThree: 'Obtenez-la pour 90€ HT',
  LanguageKeys.upgradePlanFree:
      'Améliorez votre plan et obtenez-la gratuitement',
  LanguageKeys.doYouHaveQuestionsRegarding:
      'Avez-vous des questions concernant ?',
  LanguageKeys.bookAConsultation: 'Réserver une consultation',
  LanguageKeys.viewDocumentsContracts: 'Voir documents & contrats',
  LanguageKeys.editProfile: 'Modifier le profil',
  LanguageKeys.trackMyLeads: 'Suivi',
  LanguageKeys.receiveCommissions: 'Recevoir des commissions',
  LanguageKeys.chooseBestPlan: 'Choisissez le meilleur plan pour vous',
  LanguageKeys.findMyBusinessReferrer: "Trouvez mon recommandateur d'affaires",

  LanguageKeys.busniess: 'Développez votre réseau',
  LanguageKeys.findbusniess:
      "Trouver et être trouvé par des apporteurs d'affaires",
  LanguageKeys.yourBusinessActivity: 'Votre activité',
  LanguageKeys.enterReferrerType: 'Entrez votre activité professionnelle',
  LanguageKeys.typeOfBusiness:
      'Quel type de professionnels peut vous recommander? Ajoutez les un par un',
  LanguageKeys.add: 'Ajouter',
  LanguageKeys.enterCanRefer:
      ' Écrire le type de professionnel et appuyer sur "Ajouter"',
  LanguageKeys.canRefer:
      'Quel type de professionnels pouvez vous recommander? Ajoutez les un par un',
  LanguageKeys.shareCommision: 'Partagez vous des commissions?',
  LanguageKeys.clientBusinessLocation:
      'Est ce que vous travaillez en ligne ou bien en présentiel?',
  LanguageKeys.online: 'En ligne',
  LanguageKeys.inPerson: 'En personne',
  LanguageKeys.findMyBusinessReferral: "Trouver des apporteurs d’affaires",

  LanguageKeys.busniess: ' Développez votre réseau',
  LanguageKeys.findbusniess:
      "Trouver et être trouvé par des apporteurs d'affaires",
  LanguageKeys.shareCommision: 'Partagez vous des commissions?',

  LanguageKeys.weWillGetBackToYou:
      'Nous allons présenter votre profil à des apporteurs d\'affaires potentiels et vous recontacterons prochainement.',
  LanguageKeys.weWillCoverThisDuringYourConsultationCall:
      'Nous couvrirons également cela lors de votre appel de consultation.',
  LanguageKeys.bookMyConsultation: 'Réserver ma consultation',

  LanguageKeys.connectedCardTitle:
      'Une carte connectée que vous tapez sur le téléphone, facile et rapide',
  LanguageKeys.digitalVisitCardTitle:
      'Une carte de visite numérique pour vos prospects, clients et partenaires',
  LanguageKeys.bestNetworkingToolTitle: 'Votre meilleur outil de réseautage !!',
  LanguageKeys.standOutBeDifferentOrderCardTitle:
      'Démarquez-vous, soyez différent et commandez votre carte maintenant',
  LanguageKeys.chooseBestPlan: 'Choisissez le meilleur plan pour vous',
  LanguageKeys.areYouAProfessional: 'Êtes-vous \nun \nprofessionnel ?',

  LanguageKeys
          .ifYouAreAProfessionalYouWillGainAccessToADifferentInterfaceNotOnlyToSendLeadsButAlsoToReceiveThemForYourOwnBusiness:
      'Si vous êtes un professionnel, vous aurez accès à une interface différente, non seulement pour envoyer des leads, mais aussi pour les recevoir pour votre propre entreprise.',

  LanguageKeys.onlySwitchIfYouAreLookingToReceiveClientsThroughReferaly:
      'Changez uniquement si vous souhaitez recevoir des clients via Referaly',
  LanguageKeys.myDealinner: 'Pour mon activité',

  LanguageKeys.referreals: "Vos apporteurs d'affaires",
  LanguageKeys.youAreNotCurrentlyPartOfAnyBusinessReferralProgram:
      'Aucun partenariat actif',
  LanguageKeys.askYourProfessionalToInviteYouUsingTheirLinkOrQRCode:
      "Vous n'avez actuellement accepté aucun partenariat. Pour commencer à envoyer des contacts et gagner des commissions, vous devez être invité par un professionnel.",
  LanguageKeys.askAProfessionalToSendYouAnInvitationToJoinTheirReferralNetwork:
      'Demandez à un professionnel de vous envoyer une invitation pour rejoindre son réseau de parrainage.',

  // Out of referaly
  LanguageKeys.nameOfTheBusinessReferrer: 'Nom de l’apporteur d’affaires',
  LanguageKeys.businessIntroducerDoesNotRequestCommission:
      'El presentador comercial no solicita comisión por esta recomendación.',
  LanguageKeys.acceptTermsAndConditions:
      'He leído y acepto los términos y condiciones del contrato',
  LanguageKeys.accept: 'Accepter',
  LanguageKeys.commissionFix: 'Comisión fija : ',
  LanguageKeys.linkCopiedToClipboard: 'Lien copié avec succès.',
  LanguageKeys.selectContact: 'Sélectionner un contact',
  LanguageKeys.upTo10TeamAccesses:
      "Jusqu'à 10 accès d'équipe pour collaborer en tant que Team Compte administrateur et compte collaborateurs",
  LanguageKeys.enterCommission: 'Entrer la valeur de la commission',
  LanguageKeys.upgradeToPremiumNow:
      'Passez à la version premium maintenant pour débloquer ces fonctionnalités. 🔒',
  LanguageKeys.businessActivityRequired:
      "L'activité professionnelle est requise",
  LanguageKeys.atLeastOneReferrerTypeRequired:
      'Au moins un type de recommandateur est requis',
  LanguageKeys.atLeastOneCanReferItemRequired:
      'Au moins un type de recommandateur est requis',
  LanguageKeys
          .yourReferrersRecommendationsWillAppearHereAsSoonAsSomeoneHasSentYouAContact:
      "Les recommandations de vos apporteurs d'affaires s'afficheront ici dès qu'un contact vous aura été transmis.",
  LanguageKeys
          .theRecommendationsYouSendToProfessionalsWillAppearHereWithStepByStepTrackingOfEachCaseProgress:
      "Les recommandations que vous enverrez à des professionnels s'afficheront ici, avec un suivi étape par étape de l'évolution de chaque dossier",

  // Social Login Error Messages
  LanguageKeys.googleLoginFailed:
      'Échec de la connexion Google. Veuillez réessayer.',
  LanguageKeys.googleTokenNotFound:
      "Impossible d'obtenir le jeton d'authentification Google.",
  LanguageKeys.appleLoginFailed:
      'Échec de la connexion Apple. Veuillez réessayer.',
  LanguageKeys.appleTokenNotFound:
      "Impossible d'obtenir le jeton d'authentification Apple.",
  LanguageKeys.facebookLoginFailed:
      'Échec de la connexion Facebook. Veuillez réessayer.',
  LanguageKeys.facebookTokenNotFound:
      "Impossible d'obtenir le jeton d'authentification Facebook.",
  LanguageKeys.socialLoginCancelled: 'La connexion a été annulée.',
  LanguageKeys.socialLoginError:
      "Une erreur s'est produite lors de la connexion. Veuillez réessayer.",

  // Form Validation Messages
  LanguageKeys.pleaseEnterEmail: 'Veuillez entrer votre adresse e-mail',
  LanguageKeys.pleaseEnterValidEmail:
      'Veuillez entrer une adresse e-mail valide',
  LanguageKeys.pleaseEnterPassword: 'Veuillez entrer votre mot de passe',
  LanguageKeys.pleaseEnterFirstName: 'Veuillez entrer votre prénom',
  LanguageKeys.pleaseEnterLastName: 'Veuillez entrer votre nom',
  LanguageKeys.pleaseEnterPhoneNumber:
      'Veuillez entrer votre numéro de téléphone',
  LanguageKeys.pleaseEnterCity: 'Veuillez entrer votre ville',
  LanguageKeys.pleaseEnterJob: 'Veuillez entrer votre profession',
  LanguageKeys.pleaseSelectJobType:
      'Veuillez sélectionner le type de profession',
  LanguageKeys.pleaseEnterCompanyName:
      'Veuillez entrer le nom de l\'entreprise',
  LanguageKeys.pleaseEnterCompanyAddress:
      'Veuillez entrer l\'adresse de l\'entreprise',
  LanguageKeys.pleaseEnterCompanyNumber:
      'Veuillez entrer le numéro de l\'entreprise',
  LanguageKeys.pleaseSelectCompanyLogo:
      'Veuillez sélectionner le logo de l\'entreprise',
  LanguageKeys.pleaseEnterDescription: 'Veuillez entrer la description',
  LanguageKeys.pleaseEnterCommission: 'Veuillez entrer la commission',
  LanguageKeys.pleaseEnterAmount: 'Veuillez entrer le montant',
  LanguageKeys.pleaseEnterTitle: 'Veuillez entrer le titre',
  LanguageKeys.pleaseEnterComment: 'Veuillez entrer le commentaire',
  LanguageKeys.pleaseEnterTrackName: 'Veuillez entrer le nom du suivi',
  LanguageKeys.pleaseEnterMoreInfo: 'Veuillez entrer plus d\'informations',
  LanguageKeys.pleaseEnterLeadType: 'Veuillez entrer le type de contact',
  LanguageKeys.pleaseSelectDeal: 'Veuillez sélectionner un accord',
  LanguageKeys.pleaseSelectReferrer: 'Veuillez sélectionner un recommandateur',
  LanguageKeys.pleaseAcceptTerms: 'Veuillez accepter les termes et conditions',
  LanguageKeys.leadCreatedSuccessfully: 'Contact créé avec succès',
  LanguageKeys.feedbackSubmittedSuccessfully: 'Commentaire envoyé avec succès',
  'invalidOtpMessage': 'Le code OTP que vous avez saisi est invalide',
  'pleaseTryAgain': 'Veuillez réessayer avec le bon code',
  LanguageKeys.error: 'Erreur',
  LanguageKeys.couldNotOpenDocument: 'Impossible d\'ouvrir le document',
  LanguageKeys.contactPermissionDenied: 'Permission de contact refusée',
  LanguageKeys.businessActivityRequired: 'L\'activité commerciale est requise',
  LanguageKeys.atLeastOneReferrerTypeRequired:
      'Au moins un type de parrain est requis',
  LanguageKeys.atLeastOneCanReferItemRequired:
      'Au moins un élément de référence est requis',
  LanguageKeys.contractDeletedSuccess: 'Contrat supprimé avec succès',
  LanguageKeys.dealAcceptSuccess: 'Affaire acceptée avec succès',
  LanguageKeys.leadAddedSuccessfully: 'Lead ajouté avec succès',
  LanguageKeys.leadDeletedSuccessfully: 'Lead supprimé avec succès',
  LanguageKeys.leadUpdatedSuccessfully: 'Lead mis à jour avec succès',

  LanguageKeys.dealCreatedSuccessfully: 'Affaire créée avec succès',
  LanguageKeys.dealUpdatedSuccessfully: 'Affaire mise à jour avec succès',
  LanguageKeys.dealDeletedSuccessfully: 'Affaire supprimée avec succès',
  LanguageKeys.dealAcceptedFailed: 'Affaire acceptée avec succès',
  LanguageKeys.dealRejectedFailed: 'Affaire rejetée avec succès',
  LanguageKeys.dealExpiredFailed: 'Affaire expirée avec succès',
  LanguageKeys.dealCancelledFailed: 'Affaire annulée avec succès',
  LanguageKeys.dealCompletedFailed: 'Affaire complétée avec succès',
  LanguageKeys.dealCreatedFailed: 'Affaire créée avec succès',
  LanguageKeys.dealUpdatedFailed: 'Affaire mise à jour avec succès',
  LanguageKeys.dealDeletedFailed: 'Affaire supprimée avec succès',
  LanguageKeys.youAreNotPaidUser:
      ' Votre compte est est en version Premium, ce qui indique que vous êtes enregistré en tant que professionnel. Il n\'est donc pas possible de modifier le type de compte.',
  LanguageKeys.individualSubtitle:
      "Idéal pour les anciens clients, amis, proches ou salariés qui souhaitent simplement recommander un professionnel et profiter d'un suivi de dossier avec un contrat d'apporteur d'affaires",
  LanguageKeys.professionalSubtitle:
      "Plateforme avancée pour envoyer des recommandations et recevoir des prospects qualifiés pour développer votre entreprise.",
  LanguageKeys.pleaseFillInTheDetailsBelow:
      "Veuillez remplir les détails ci-dessous",
  LanguageKeys.addNewLead: 'Ajouter un nouveau lead',
  LanguageKeys.save: 'Enregistrer',
  LanguageKeys.addContact: 'Ajouter \nau contact',
  LanguageKeys.name: 'Nom',
  LanguageKeys.contactAddedSuccessfully: 'Contact ajouté avec succès',
  LanguageKeys.google: 'Google',
  LanguageKeys.facebook: 'Facebook',
  LanguageKeys.apple: 'Apple',
  LanguageKeys.setupCard: 'Prendre un rendez vous',
  LanguageKeys.addCoworkers: 'Choisissez le contrat que vous voulez partager',
  LanguageKeys.addBusinessReferrence:
      'Ajoutez vos premiers apporteurs d’affaires en créant et partageant votre premier contrat d’apport d’affaires',
  LanguageKeys.noProvided: 'Non renseigné',
  LanguageKeys.individualTitle: 'Action impossible',
  LanguageKeys.individualDescription1:
      'Vous ne pouvez pas passer à un compte particulier car vous avez déjà reçu des prospects ou créé des contrats d’apport d’affaires.',

  LanguageKeys.addNewLeadSubTitle:
      'à un professionnel qui ne vous a pas partagé son lien/QR code',
  LanguageKeys.subTitle: 'CRM de poche',

  LanguageKeys.titleConnectedCard: 'Configurez votre carte',
  LanguageKeys.titlePersonalInformation: 'Information\npersonnelle',
  LanguageKeys.titleBusinessInformation: 'Information\nd’entreprise',

  LanguageKeys.businessReferralProgram:
      'Programme d’apport d’affaires (professionnels)',
  LanguageKeys.ambassadorProgram: 'Programme ambassadeur (particuliers)',
  LanguageKeys.writeACustomName: 'Écrivez un nom sur mesure',

  LanguageKeys.welcometitle: 'Se connecter ou se créer un compte avec',

  LanguageKeys.selectAnOption: 'Sélectionner une option',
  LanguageKeys.addCoworker: 'Ajouter un collaborateur',
  LanguageKeys.shareAccessOf: 'Partager l\'accès de',
  LanguageKeys.updateVersion:
      'Nouvelle mise à jour disponible\nCliquez ici pour mettre à jour Referaly',

  LanguageKeys.seeMore: 'Voir plus',
  LanguageKeys.inWhichCityDoYouWork: 'Dans quelle ville travaillez vous?',
  LanguageKeys.enterYourCity: 'Entrez votre ville',
  LanguageKeys.cityIsRequired: 'La ville est requise',
  LanguageKeys.enterRevenueText:
      'Quel chiffre d\'affaires avez-vous généré grâce à cette recommandation?',
  LanguageKeys.turnover: 'Chiffre d\'affaires',
  LanguageKeys.netIncome: 'Revenu net',
  LanguageKeys.tutorialTrainingtoDevelopYourBusiness:
      'Formations tutoriels pour développer votre réseau d’apporteurs d’affaires',
  LanguageKeys.requestUpdate: 'Demander un suivi',
  LanguageKeys.requestUpdateMessage:
      'Se ha enviado una notificación al profesional solicitando comentarios sobre este prospecto.',
  LanguageKeys.leadName: 'Nom du lead',
  LanguageKeys.leadTracking: 'Suivi de leads',
  LanguageKeys.comment: 'Commentaire',
  LanguageKeys.nextStep: 'Étape suivante',
  LanguageKeys.searchPlaceholderLeads: 'Rechercher un contact',
  LanguageKeys.completed: 'Complété',
  LanguageKeys.commentTo: 'Commentaire de',

  LanguageKeys.updatePopupTitle:
      "Suivi de l'affaire : votre retour est précieux",
  LanguageKeys.updatePopupDescription:
      " L'apporteur d'affaires lié à ce contact souhaite être tenu informé de l'évolution de cette opportunité." +
          "\nAvez-vous effectué une mise à jour récente ? Même en l'absence de réponse du prospect, un simple commentaire permet de maintenir un bon niveau de suivi." +
          "\nUn suivi régulier renforce la confiance et consolide vos relations avec votre réseau d'apporteurs.",

  LanguageKeys.title1: "Suivi de l'affaire",
  LanguageKeys.title2: "Votre retour est précieux",
  LanguageKeys.title3:
      "L'apporteur d'affaires lié à ce contact souhaite être tenu informé de l'évolution de cette opportunité.",
  LanguageKeys.title4: "Mise à jour requise",
  LanguageKeys.title5: "Avez-vous effectué une mise à jour récente?",
  LanguageKeys.title6:
      "Même en l'absence de retour du prospect, un simple commentaire maintient un bon niveau de suivi",
  LanguageKeys.title7:
      "Un suivi régulier renforce la confiance et consolide vos relations avec votre réseau",
  LanguageKeys.title8: "Ajouter une mise à jour",
  LanguageKeys.activeReferrals: "Apporteurs d'affaires\nactifs",
  LanguageKeys.collaborators: "Collaborateurs",
  LanguageKeys.enveyers: "Envoyer Notif.",
  LanguageKeys.seeStatistics: "Voir les statistiques et le classement",
  LanguageKeys.contractAndDocument: "Contrat &\n documents",

  LanguageKeys.howItWorks: 'Comment ça marche?',
  LanguageKeys.viewContract: 'Voir le contrat',
  LanguageKeys.attachFiles: 'Joindre des fichiers',
  LanguageKeys.invitePartner:
      'Inviter un apporteur d’affaires sur l’application',
  LanguageKeys.shareReferralForm: 'Partager le formulaire de recommandation',
  LanguageKeys.outsideOfTheApp: 'en dehors de l’application',

  LanguageKeys.referralHubTitle: 'Hub Parrainage',
  LanguageKeys.LeadsTitle: 'Envoyer un prospect',
  LanguageKeys.LeadsDescription:
      "Envoyez rapidement un prospect en quelques secondes au professionnel. Remplissez un simple formulaire avec les détails du client et laissez le professionnel s'occuper du reste.",
  LanguageKeys.ContractTitle: 'Contrat & Documents',
  LanguageKeys.ContractDescription:
      "Consultez tous les documents que le professionnel a mis à disposition de ses apporteurs d'affaires. Accédez aux contrats, conditions et détails des commissions.",
  LanguageKeys.OptionsTitle: "Plus d'options",
  LanguageKeys.OptionsDescription:
      "Le menu trois points vous permet de quitter le programme de parrainage, gérer les notifications ou accéder à des paramètres supplémentaires pour ce partenariat.",

  LanguageKeys.viewContact: 'Information de\n l’entreprise',
  LanguageKeys.fixedCommissionAmount: 'Montant fixe de commission',
  LanguageKeys.withoutVATOfTheAmountInvoiced: 'Hors TVA du montant facturé',
  LanguageKeys.perSuccessfulReferral: 'par parrainage réussi',
  LanguageKeys.shareDocument: 'Partager le document',

  LanguageKeys.howitworktitle: 'Comment ça marche',
  LanguageKeys.howitworkdescription: "Découvrez la fonction de chaque bouton",
  LanguageKeys.viewContractTitle: 'Voir le contrat',
  LanguageKeys.viewContractDescription:
      "Ouvrez et consultez le contrat associé à votre programme de parrainage. Accédez à tous les termes, conditions et détails de l'accord.",
  LanguageKeys.editProgram: 'Modifier le programme',
  LanguageKeys.editProgramDescription:
      "Modifiez les paramètres de votre programme de parrainage, mettez à jour les termes, commissions et personnalisez les détails selon vos besoins.",
  LanguageKeys.attchfiles: 'Joindre des fichiers',
  LanguageKeys.attachFilesDescription:
      "Téléchargez des documents pour les apporteurs d'affaires afin qu'ils puissent faire de meilleures références et partager des ressources avec leur réseau.",
  LanguageKeys.invitePartnerTitle: "Inviter un partenaire via l'app",
  LanguageKeys.invitePartnerDescription:
      "Invitez directement des partenaires commerciaux sur Referaly pour un accès gratuit au suivi en temps réel, aux contrats et à l'envoi facile de prospects.",
  LanguageKeys.shareDescription:
      'Partagez un formulaire de parrainage avec des apporteurs d’affaires qui préfèrent ne pas télécharger l’application.',
  LanguageKeys.shareTitle: 'Partager un formulaire en dehors de l’application',

  // profile selector
  LanguageKeys.profileTypeTitle: "Que voulez-vous faire sur Referaly ?",
  LanguageKeys.profileTypeSubtitle:
      "Choisissez l'expérience qui correspond à vos besoins de gestion de recommandations",
  LanguageKeys.profileTypeIndividualSubtitle:
      "Plateforme simple et épurée axée sur l'envoi de recommandations et la gestion de vos contacts.",
  LanguageKeys.profileTypeProfessionalOnly: "PROFESSIONNELS UNIQUEMENT",
  LanguageKeys.profileTypeProfessionalIndividuals:
      "PROFESSIONNELS ET PARTICULIERS",
  LanguageKeys.profileTypeSendReceive:
      "Envoyer et Recevoir des Recommandations",
  LanguageKeys.profileTypeSendOnly: "Envoyer des Recommandations Uniquement",
  LanguageKeys.profileTypeGetStarted: "Commencer",
  LanguageKeys.featureSendUnlimited: "Recommandations illimitées",
  LanguageKeys.featureReceiveLeads: "Recevoir des prospects qualifiés",
  LanguageKeys.featureAnalytics: "Analyses et insights avancés",
  LanguageKeys.featureLeadTools: "Outils de gestion des prospects",
  LanguageKeys.featureSendEasily: "Envoi facile de recommandations",
  LanguageKeys.featureTrackStatus: "Suivi du statut des recommandations",
  LanguageKeys.featureContactManagement: "Gestion des contacts",
  LanguageKeys.featureBasicReporting: "Rapports de base",

  LanguageKeys.notAvialble: "Non renseigné",
  LanguageKeys.seeAllStatistics: "Voir toutes les statistiques",
  LanguageKeys.totalArchivedLeads: "Total des prospects archivés",
  LanguageKeys.commissionsPaid: "Commission versée",
  LanguageKeys.succeededLeads: "Prospects convertis",
  LanguageKeys.referredBy: "Recommandé par",
  LanguageKeys.reasonOfTheLoss: "Motif de perte",
  LanguageKeys.retrieve: "Récupérer",
  LanguageKeys.newLead: "Nouveau prospect",
  LanguageKeys.leadsReceived: "Prospects reçus",
  LanguageKeys.sendALeadToAProfessionalWhoDidNotInviteYou:
      "Envoyer un prospect à un professionnel qui ne vous a pas invité",
  LanguageKeys.sendALead: "Envoyer contact",

  LanguageKeys.modeProfessional: "Compte professionnel",
  LanguageKeys.receiveLeadsViaReferaly: "Recevoir des leads via Referaly",
  LanguageKeys.faqAndTuto: "FAQ &\nTuto",
  LanguageKeys.learnToUseReferalyEfficiently:
      "Apprendre à utiliser Referaly efficacement",
  LanguageKeys.youAreLeavingWithoutSavingInfoSaveChanges:
      "Vous quittez sans enregistrer les informations. Enregistrer les modifications ?",
  LanguageKeys.seeAllDocuments: "Voir tous les documents",
  LanguageKeys.commissionRate: "Taux de commission",
  LanguageKeys.documentsAvailable: "Documents disponibles",

  LanguageKeys.sendReferral: "Envoyer une recommandation",
  LanguageKeys.chooseYourPreferredSharingMethod:
      "Qui voulez-vous recommander ?",
  LanguageKeys.referalyProfessional: "À un utilisateur de Referaly",
  LanguageKeys.externalContact: "Un professionnel qui n’a pas Referaly",
  LanguageKeys.sendToAVerifiedProfessionalOnOurPlatform:
      "Envoyer un contact à un utilisateur qui vous a invité sur l’application",
  LanguageKeys.shareViaEmailOrMessagingPlatforms:
      "Envoyer un contact avec un contrat de recommandation gratuit via un lien d’invitation",

  LanguageKeys.inviteBusinessReferrer:
      "Inviter votre apporteur d’affaires à l'app",
  LanguageKeys.inviteBusinessReferrerDescription:
      "Partagez votre contrat d’apport d’affaires à un prescripteur professionnel ou particulier",
  LanguageKeys.qrCode: "Code QR",
  LanguageKeys.letThemScanToJoin: "Laissez-les scanner pour rejoindre",
  LanguageKeys.copyOrShareDirectly: "Copier ou partager directement",
  LanguageKeys.copy: "Copier",
  LanguageKeys.bySharingYourReferral:
      "En partageant votre contrat d’apport d’affaires, vous invitez des prescripteurs à rejoindre en utilisant les termes de votre contrat. ",

  LanguageKeys.scanToJoinTheReferralProgram:
      "Scannez pour rejoindre le programme de parrainage",
  LanguageKeys.referallink: "Lien de parrainage",
  LanguageKeys.howToUse: "Comment l’utiliser:",
  LanguageKeys.showQRCodeToPotentialReferrers:
      "Montrez ce code QR à vos apporteurs d’affaires potentiels",
  LanguageKeys.theyCanScanItWithTheirPhoneCamera:
      "Ils peuvent le scanner avec la caméra de leur téléphone",
  LanguageKeys.itWillOpenTheReferralLinkAutomatically:
      "Cela ouvrira automatiquement le contrat d’apport d’affaires une fois l’application installé et leur compte créé",
  LanguageKeys.referralAgreement: "Contrat d’apport d’affaires",
  LanguageKeys
          .iAcceptTheTermsAndConditionsOfTheReferralPartnershipAgreementAndUnderstandTheCommissionStructure:
      "J'accepte les termes et conditions de l'accord de partenariat de parrainage et comprends la structure de commission.",
  LanguageKeys.acceptPartnership: "Accepter le Partenariat",
  LanguageKeys.decline: "Décliner",
  LanguageKeys.partnership: "Partenariat",
  LanguageKeys.invitation: "Invitation",

  // Share Form Bottom Sheet
  LanguageKeys.shareReferenceForm: "Partager le Formulaire de Référence",
  LanguageKeys.shareExternalForm: "Partager le Formulaire Externe",
  LanguageKeys.shareExternalFormDescription:
      "Ce formulaire peut être rempli par toute personne en dehors de l'application. Partagez-le avec des références potentielles pour collecter leurs informations.",
  LanguageKeys.formPreview: "Aperçu du Formulaire",
  LanguageKeys.formPreviewDescription:
      "Voir comment le formulaire apparaîtra aux destinataires",
  LanguageKeys.chooseSharingMethod: "Choisir la Méthode de Partage",
  LanguageKeys.link: "Lien",
  LanguageKeys.shareLinks: "Partager le Lien",
  LanguageKeys.copyLinkOrShareDirectly:
      "Copier le lien ou partager directement sur les réseaux sociaux",
  LanguageKeys.shareOnSocialNetworks: "Partager sur les réseaux sociaux",
  LanguageKeys.twitter: "Twitter",
  LanguageKeys.whatsapp: "WhatsApp",
  LanguageKeys.linkedin: "LinkedIn",
  LanguageKeys.linkCopied: "Lien copié",

  LanguageKeys.createAccount: "Créer un compte",
  LanguageKeys.joinOurProfessionalNetwork:
      "Rejoignez notre réseau professionnel",
  LanguageKeys.orComplete: "ou compléter",

  LanguageKeys.signIn: "Se connecter",
  LanguageKeys.professionalreeferr:
      "Gestion professionnelle de recommandations",
  LanguageKeys.welcomeBack: "Bon retour",
  LanguageKeys.signInToYourProfessionalAccount:
      "Connectez-vous à votre compte professionnel",
  LanguageKeys.continueWithGoogle: "Continuer avec Google",
  LanguageKeys.orSignInWithEmail: "ou connectez-vous avec email",
  LanguageKeys.rememberMe: "Se souvenir de moi",
  LanguageKeys.bySigningInYouAgreeToOur:
      "En vous connectant, vous acceptez nos ",
  LanguageKeys.termsOfService:
      "Conditions d'utilisation et notre Politique de confidentialité",
  LanguageKeys.and: " et ",
  LanguageKeys.signupNew: "S'inscrire",
  LanguageKeys.signinNew: "Se connecter",

  // Share Document Bottom Sheet
  LanguageKeys.shareProfessionalDocuments:
      "Partager les Documents Professionnels",
  LanguageKeys.amplifyRecommendationNetwork:
      "Amplifiez votre réseau de recommandations avec des documents de qualité",
  LanguageKeys.improveRecommendationQuality:
      "Améliorez la Qualité de vos Recommandations",
  LanguageKeys.shareProfessionalDocumentsDescription:
      "Partagez ces documents professionnels avec votre réseau pour envoyer des recommandations plus qualifiées et aider vos contacts à prendre des décisions éclairées.",
  LanguageKeys.quickShareOptions: "Options de Partage Rapide",
  LanguageKeys.shareLink: "Lien de Partage",
  LanguageKeys.secureLinkExpires30Days: "Lien sécurisé expire dans 30 jours",
  LanguageKeys.whyShareDocuments: "Pourquoi Partager les Documents ?",
  LanguageKeys.betterQualityRecommendations:
      "Recommandations de Meilleure Qualité",
  LanguageKeys.informedClientsMakeBetterChoices:
      "Des clients informés font de meilleurs choix",
  LanguageKeys.buildTrustCredibility: "Construire Confiance & Crédibilité",
  LanguageKeys.transparencyIncreasesConversion:
      "La transparence augmente les taux de conversion",
  LanguageKeys.expandYourNetwork: "Élargir Votre Réseau",
  LanguageKeys.easySharingDevelopsInfluence:
      "Le partage facile développe votre influence",
  LanguageKeys.impactStatistics: "Statistiques d'Impact",
  LanguageKeys.higherConversionRate: "Taux de conversion plus élevé",
  LanguageKeys.customerSatisfaction: "Satisfaction client",

  // initial language
  LanguageKeys.chooseYourLanguage: "Choisir votre langue",
  LanguageKeys.connect: "Connecter",
  LanguageKeys.reward: "Récompenser",
  LanguageKeys.grow: "Grandir",
  LanguageKeys.growLikeThousandsOfOthers: "Grandir comme mille autres",
  LanguageKeys.allThroughThePowerOfReferrals:
      "Tout grâce au pouvoir des références",
  LanguageKeys.yourAppForBusinessReferrals:
      "Votre app pour les références professionnelles",

  LanguageKeys.confirmPassword: "Confirmer le mot de passe",

  // Professional Account Activation Dialog
  LanguageKeys.professionalAccountActivationTitle: "Important",
  LanguageKeys.professionalAccountActivationMessage:
      "Pour créer votre propre contrat d'apport d'affaires et commencer à recevoir des prospects via Referaly, vous devez activer un compte professionnel.",
  LanguageKeys.professionalAccountActivationQuestion:
      "Souhaitez-vous activer votre compte professionnel maintenant ?",
  LanguageKeys.yesActivateProfessionalAccount:
      "Oui, activer mon compte professionnel",
  LanguageKeys.noContinueWithoutActivating: "Non, continuer sans activer",
  LanguageKeys.passwordDoNotMatch: "Les mots de passe ne correspondent pas",

  // Detailed Statistics
  LanguageKeys.detailedStatistics: "Statistiques détaillées",
  LanguageKeys.rankings: "Classements",
  LanguageKeys.leadsRanking: "Classement prospects",
  LanguageKeys.basedOnNumberOfLeadsSent:
      "Basé sur le nombre de prospects envoyés",
  LanguageKeys.conversionRanking: "Classement conversion",
  LanguageKeys.basedOnConversionRate: "Basé sur le taux de conversion",
  LanguageKeys.leadStatistics: "Statistiques prospects",
  LanguageKeys.leadsSent: "Prospects envoyés",
  LanguageKeys.lostLeads: "Prospects perdus",
  LanguageKeys.successfulLeads: "Prospects réussis",
  LanguageKeys.pendingLeads: "En attente",
  LanguageKeys.performance: "Performances",
  LanguageKeys.conversionRate: "Taux de conversion",
  LanguageKeys.completedLeads: "complétés",
  LanguageKeys.successfulOutOf: " réussis sur",
  LanguageKeys.referrersStatistics: "parrains",
  // Financial statistics
  LanguageKeys.financialData: "Données financières",
  LanguageKeys.totalCommissionPaid: "Commission totale versée",
  LanguageKeys.turnoverGenerated: "Chiffre d'affaires généré",
  LanguageKeys.profitGenerated: "Bénéfice généré",

  LanguageKeys.monthlyConversionRate: "Moyenne mensuelle",
  LanguageKeys.leadsPerMonth: "Prospects par mois",


  // Overall Statistics
  LanguageKeys.referralStatistics: "Statistiques Parrainages",
  LanguageKeys.filterByCriteria: "Filtrer par critère",
  LanguageKeys.overallStatistics: "Statistiques Générales",
  LanguageKeys.avgPerReferrer: "Moy. Par Parrain",
  LanguageKeys.receivedPerMonth: "Reçus/Mois",
  LanguageKeys.totalIncomeGenerated: "Revenu Total Généré",

  LanguageKeys.quickFillForm: "Remplir rapidement le formulaire avec les informations de contact existantes",

  LanguageKeys.shareFormTitle: "Formulaire de Contact Partageable",
  LanguageKeys.shareFormDescription: "Envoyez un lien personnalisé à votre prospect pour qu'il puisse remplir ses informations directement",
  LanguageKeys.benefitsOfTheShareableForm: "Avantages du formulaire partageable:",
  LanguageKeys.automaticInformationCollection: "Collecte automatique des informations",
  LanguageKeys.realTimeSubmissionTracking: "Suivi des soumissions en temps réel",
  LanguageKeys.automaticAttributionToYourReferral: "Attribution automatique à votre parrainage",
    LanguageKeys.yourPersonalizedLink: "Votre Lien Personnalisé",
  LanguageKeys.shareForm: "Partager le Formulaire",

};

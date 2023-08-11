import 'package:get/get.dart';

class MyLocale implements Translations {
  @override

  /// this class for languages
  Map<String, Map<String, String>> get keys => {
        'ar': {
          "patients verified": "المرضى الموثوق بهم",
          "doctors verified": "الأطباء الموثوق بهم",
          "doctors requests": "طلبات الأطباء",
          "connection error": "خطأ في الاتصال",
          "empty data": "بيانات فارغة",
          "search for patient": "البحث عن مريض",
          "Want to meet the doctor ?": "هل ترغب في مقابلة الطبيب؟",
          "Topic": "الموضوع",
          "meeting reason": "سبب اللقاء",
          "topic can't be empty": "لا يمكن أن يكون الموضوع فارغًا",
          "You need to pick a date": "تحتاج إلى اختيار تاريخ",
          "appointment request has been sent": "تم إرسال طلب الموعد",
          "appointment request error": "خطأ في طلب الموعد",
          "Time": "الوقت",
          "Max Safe": "الحد الأقصى",
          "Average": "متوسط",
          "notification sent": "تم إرسال الإشعار",
          "notifications error": "خطأ في الإشعارات",
          "user deleted": "تم حذف المستخدم",
          "doctor request accepted": "تم قبول طلب الطبيب",
          "Language": "اللغة",
          "Select your preferred language": "اختر لغتك المفضلة",
          "French": "الفرنسية",
          "french": "الفرنسية",
          "English": "الإنجليزية",
          "english": "الإنجليزية",
          "Arabic": "العربية",
          "arabic": "العربية",
          "Real-time Tracking": "تتبع في الوقت الحقيقي",
          "Stay informed about your heart health ,real-time heart rate monitoring at your fingertips.": "ابقَ على اطلاع على صحة قلبك ، مراقبة معدل ضربات القلب في الوقت الحقيقي بأطراف أصابعك.",
          "Secure Communication": "التواصل الآمن",
          "connect with your assigned doctor through a secure and private chat system for personalized consultations and timely support.": "اتصِل بطبيبك المعين من خلال نظام محادثة آمن وخاص للاستشارات الشخصية والدعم في الوقت المناسب.",
          "Intelligent Insights": "اشعارات ذكية",
          "Our advanced AI model intelligently adapts heart rate thresholds based on your activities and ensuring accurate health monitoring.": "يقوم نموذج الذكاء الاصطناعي المتقدم لدينا بتكييف عتبات معدل ضربات القلب بذكاء استنادًا إلى أنشطتك وضمان مراقبة صحية دقيقة.",
          "Done": "تم",
          "Skip": "تخطى",
          "please verify network": "يرجى التحقق من الشبكة",
          "Failed to Connect": "فشل الاتصال",
          "Please wait": "يرجى الانتظار",
          "Failure": "فشل",
          "Ok": "موافق",
          "Stop": "توقف",
          "Verification": "التحقق",
          "Your email is not verified\nVerify now?": "بريدك الإلكتروني غير مُتحقق\nهل ترغب في التحقق الآن؟",
          "Verify": "التحقق",
          "Cancel": "إلغاء",
          "Are you sure you want to delete this image": "هل أنت متأكد أنك تريد حذف هذه الصورة؟",
          "cancel": "إلغاء",
          "Choose source": "اختر المصدر",
          "Gallery": "المعرض",
          "Camera": "الكاميرا",
          "Connecting": "جاري الاتصال",
          "User not found": "المستخدم غير موجود",
          "Wrong password": "كلمة مرور خاطئة",
          "Weak password": "كلمة مرور ضعيفة",
          "Email already in use": "البريد الإلكتروني قيد الاستخدام بالفعل",
          "password reset has been sent to your mailbox": "تم إرسال إعادة تعيين كلمة المرور إلى صندوق البريد الخاص بك",
          "Enter a valid email": "أدخل عنوان بريد إلكتروني صحيح",
          "your account has been verified\nplease reconnect": "تم التحقق من حسابك\nيرجى إعادة الاتصال",
          "Forgot Your password ?": "هل نسيت كلمة المرور؟",
          "Email": "البريد الإلكتروني",
          "Enter your email": "أدخل بريدك الإلكتروني",
          "email can't be empty": "لا يمكن أن يكون البريد الإلكتروني فارغًا",
          "Connecting": "جاري الاتصال",
          "Your health is a priority": "صحتك هي الأولوية",
          "Password": "كلمة المرور",
          "Enter your password": "أدخل كلمة المرور الخاصة بك",
          "password can't be empty": "لا يمكن أن تكون كلمة المرور فارغة",
          "Enter a valid password of at least 6 characters": "أدخل كلمة مرور صالحة مكونة من 6 أحرف على الأقل",
          "forgot password ?": "هل نسيت كلمة المرور؟",
          "you have no account ?": "ليس لديك حساب؟",
          "Sign Up": "الاشتراك",
          "your account has been created successfully": "تم إنشاء حسابك بنجاح",
          "Register": "تسجيل",
          "Patient": "مريض",
          "Doctor": "طبيب",
          "Name": "الاسم",
          "Enter your name": "أدخل اسمك",
          "name can't be empty": "لا يمكن أن يكون الاسم فارغًا",
          "Age": "العمر",
          "Enter your age": "أدخل عمرك",
          "age can't be empty": "لا يمكن أن يكون العمر فارغًا",
          "Speciality": "التخصص",
          "Enter your speciality": "أدخل تخصصك",
          "speciality can't be empty": "لا يمكن أن يكون التخصص فارغًا",
          "Address": "العنوان",
          "Enter your address": "أدخل عنوانك",
          "address can't be empty": "لا يمكن أن يكون العنوان فارغًا",
          "Phone": "الهاتف",
          "Enter your number": "أدخل رقمك",
          "number can't be empty": "لا يمكن أن يكون الرقم فارغًا",
          "Code": "الكود",
          "Enter your esp code": "أدخل كود ESP الخاص بك",
          "code can't be empty": "لا يمكن أن يكون الكود فارغًا",
          "Please tell us who you are ?": "يرجى إخبارنا من أنت؟",
          "An email has been sent to": "تم إرسال بريد إلكتروني إلى",
          "Please Verify": "يرجى التحقق",
          "choose language": "اختر اللغة",
          "Settings": "الإعدادات",
          "Common": "شائع",
          "Language": "اللغة",
          "Environment": "البيئة",
          "Production": "إنتاج",
          "Account": "الحساب",
          "Phone number": "رقم الهاتف",
          "Sign out": "تسجيل الخروج",
          "Security": "الأمان",
          "Lock app in background": "قفل التطبيق في الخلفية",
          "Use fingerprint": "استخدام بصمة الإصبع",
          "Allow application to access stored fingerprint IDs": "السماح للتطبيق بالوصول إلى معرّفات بصمة الإصبع المخزنة",
          "Change password": "تغيير كلمة المرور",
          "Enable notifications": "تمكين الإشعارات",
          "Misc": "متنوع",
          "Terms of Service": "شروط الخدمة",
          "Open source license": "رخصة المصدر المفتوح",
          "Create account": "إنشاء حساب",
          "Male": "ذكر",
          "Female": "أنثى",
          "History": "التسجيلات",
          "Available": "متاح",
          "Not Available": "غير متاح",
          "Chat": "الدردشة",
          "Disconnected": "مفصول",
          "Connected": "متصل",
          "Enable custom theme": "تمكين سمة مخصصة",
          "Are you sure you want to remove this patient ?": "هل أنت متأكد أنك تريد إزالة هذا المريض؟",
          "Are you sure you want to accept this user ?": "هل أنت متأكد أنك تريد قبول هذا المستخدم؟",
          "add": "إضافة",
          "Are you sure you want to remove this user ?": "هل أنت متأكد أنك تريد إزالة هذا المستخدم؟",
          "Are you sure you want to remove this doctor ?": "هل أنت متأكد أنك تريد إزالة هذا الطبيب؟",
          "Remove": "إزالة",
          "removed from my patients list": "تمت إزالته من قائمة المرضى الخاصة بي",
          "Accept": "قبول",
          "Decline": "رفض",
          "My Patients": "مرضاي",
          "Patients List": "قائمة المرضى",
          "added to my patients list": "تمت إضافته إلى قائمة مرضاي",
          "you have no patients yet": "ليس لديك مرضى حتى الآن",
          "no patients verified yet": "لا يوجد مرضى تم التحقق منهم بعد",
          "no patients found": "لم يتم العثور على مرضى",
          "no patients attached": "لا يوجد مرضى مرتبطين",
          "no doctors verified yet": "لا يوجد أطباء تم التحقق منهم بعد",
          "no doctors requests yet": "لا يوجد طلبات أطباء حتى الآن",
          "no appointments found": "لم يتم العثور على مواعيد",
          "no notifications found": "لم يتم العثور على إشعارات",
          "no attached doctor \nto send Appointment": "لا يوجد طبيب مرتبط \nلإرسال موعد",
          "no attached doctor yet": "لا يوجد طبيب مرتبط حتى الآن",
          "no history data saved yet": "لا توجد بيانات سابقة محفوظة حتى الآن",
          "bpm Live": "معدل النبضات",
          "Tax number": "الرقم الضريبي",

          "An Apple a Day": "تفاحة في اليوم",
          "Savor the goodness of apples for a healthier you. Packed with fiber, vitamins, and antioxidants, apples contribute to overall well-being. Snack on this crunchy fruit to boost your immune system, support digestion, and promote heart health. Embrace the natural sweetness of apples and discover a delicious way to nourish your body.": "استمتع بفوائد التفاح لتحافظ على صحتك. يحتوي التفاح على الألياف والفيتامينات ومضادات الأكسدة، ويساهم في العافية العامة. استمتع بتناول هذه الفاكهة المقرمشة لتعزيز جهاز المناعة، ودعم الهضم، وتعزيز صحة القلب. اغمر نفسك في الحلاوة الطبيعية للتفاح واكتشف طريقة لذيذة لتغذية جسمك.",
          "Take Charge of Your Health": "تحكم في صحتك",
          "Nurture your heart with love and care. Stay active, eat well, manage stress, and prioritize regular check-ups. Your heart is the lifeline to your well-being, so make heart health a top priority. Embrace a heart-healthy lifestyle and enjoy a life full of vitality and happiness.": "اعتني بقلبك بالحب والرعاية. ابقى نشيطًا، وتناول طعامًا صحيًا، وتعامل مع الضغوط، واعطِ الأولوية للكشوفات الدورية. قلبك هو الحبل الحياة لصحتك، لذا اجعل صحة القلب أولوية قصوى. اعتمد نمط حياة صحي للقلب واستمتع بحياة مليئة بالحيوية والسعادة.",
          "Prioritize Cardiovascular Health": "اعطِ أولوية لصحة القلب والأوعية الدموية",
          "Your heart is the engine that keeps you going. Show it some love by making heart-healthy choices. Engage in regular physical activity, such as brisk walking or cycling, to keep your heart strong. Opt for a balanced diet rich in fruits, vegetables, whole grains, and lean proteins. Minimize salt, sugar": "قلبك هو المحرك الذي يبقيك في حركة. أظهر له الحب من خلال اتخاذ خيارات صحية للقلب. اشترك في نشاطات بدنية منتظمة مثل المشي السريع أو ركوب الدراجة للحفاظ على قوة قلبك. اختر نظامًا غذائيًا متوازنًا يحتوي على فواكه وخضروات وحبوب كاملة وبروتينات نباتية. قلل من استهلاك الملح والسكر",
          "Resting":"في راحة",
          "Training":"في تمرين",
          "Send": "إرسال",
          "Login": "دخول",
          "Google": "جوجل",
        },
        /// ////////////////////////////////// //////////////////////////////////////
        /// ////////////////////////////// English //////////////////////////////////////
        /// ////////////////////////////////// //////////////////////////////////////
    ///
    ///
    ///
        'en': {
          "check Connexion": "check Connexion",
          "Failed to Connect": "Failed to Connect",
          "please verify network": "please verify network",
          "Retry": "Retry",
          "Please wait": "Please wait",
          "Camera": "Camera",
          "Failure": "Failure",
          "Gallery": "Gallery",
          "Ok": "Ok",
          "Add": "Add",
          "cancel": "cancel",
          "Cancel": "Cancel",
          "Stop": "Stop",
          "Description": "Description",
          "Clients": "Clients",
          "Price": "Price",
          "Treasury": "Treasury",
          "price can't be empty": "price can't be empty",
          "Please enter a valid price": "Please enter a valid price",
          "Choose source": "Choose source",
          "no invoices added yet": "no invoices added yet",
          "Send": "Send",
          "Language": "Language",
          "Invoices": "Invoices",
          "Change Language": "Change Language",
          "Connecting": "Connecting",
          "graphic study": "graphic study",
          "Select your preferred language": "Select your preferred language",
          "Workers": "Workers",
          "French": "French",
          "Arabic": "Arabic",
          "English": "English",
          "Are you sure you want to check this invoice ?": "Are you sure you want to check this invoice ?",
          "Check": "Check",
          "Invoice has been checked": "Invoice has been checked",
          "Are you sure you want to send this invoice ?": "Are you sure you want to send this invoice ?",
          "Change price/qty": "Change price/qty",
          "Change total sell": "Change total sell",
          "Invoice type": "Invoice type",
          "Multiple": "Multiple",
          "Delivery": "Delivery",
          "Client": "Client",
          "Email:": "Email:",
          "Print Invoice": "Print Invoice",
          "total:": "total:",
          "price:": "price:",
          "ID:": "ID:",
          "Total Kridi:": "Total Kridi:",
          "Verified:": "Verified:",
          "Total Expenses:": "Total Expenses:",
          "Salary:": "Salary:",
          "Speciality:": "Speciality:",
          "Role:": "Role:",
          "Join Date:": "Join Date:",
          "Address:": "Address:",
          "Phone:": "Phone:",
          "Sex:": "Sex:",
          "no expenses found": "no expenses found",
          "no kridi found": "no kridi found",
          "income:": "income:",
          "society:": "society:",
          "qty:": "qty:",
          "January": "January",
          "February": "February",
          "March": "March",
          "April": "April",
          "May": "May",
          "June": "June",
          "July": "July",
          "August": "August",
          "September": "September",
          "October": "October",
          "November": "November",
          "December": "December",
          "Unknown": "Unknown",
          "delete": "delete",
          "Are you sure you want to delete this image": "Are you sure you want to delete this image",
          "empty data": "empty data",
          "total Buy:": "total Buy:",
          "total Sell:": "total Sell:",
          "not valid": "not valid",
          "empty": "empty",
          "invoice": "invoice",
          "removed": "removed",
          "Remove": "Remove",
          "Income:": "Income:",
          "Total:": "Total:",
          "rest quantity:": "rest quantity:",
          "Are you sure you want to remove this product ?": "Are you sure you want to remove this product ?",
          "Are you sure you want to remove this client ?": "Are you sure you want to remove this client ?",
          "buy Price:": "buy Price:",
          "sell Price:": "sell Price:",
          "type:": "type:",
          "Tel:": "Tel:",
          "Are you sure you want to remove this worker ?": "Are you sure you want to remove this worker ?",
          "expenses:": "expenses:",
          "kridi:": "kridi:",
          "desc:": "desc:",
          "Manual Changes": "Manual Changes",
          "Sell History": "Sell History",
          "Buy History": "Buy History",
          "Info": "Info",
          "Expenses": "Expenses",
          "Kridi": "Kridi",
          "Update Worker": "Update Worker",
          "Add Worker": "Add Worker",
          "New Worker": "New Worker",
          "Enter name": "Enter name",
          "Name": "Name",
          "name can't be empty": "name can't be empty",
          "Age": "Age",
          "Enter age": "Enter age",
          "Phone": "Phone",
          "Enter number": "Enter number",
          "number can't be empty": "number can't be empty",
          "Enter address": "Enter address",
          "Address": "Address",
          "address can't be empty": "address can't be empty",
          "Email": "Email",
          "Enter email": "Enter email",
          "Role": "Role",
          "Enter role": "Enter role",
          "Speciality": "Speciality",
          "Enter speciality": "Enter speciality",
          "Salary": "Salary",
          "Enter salary": "Enter salary",
          "salary can't be empty": "salary can't be empty",
          "Please enter a valid salary": "Please enter a valid salary",
          "choose language": "choose language",

        },
    // /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        'fr': {
          "choose language": "choisir language",

          "check Connexion": "Vérifier la connexion",
          "Failed to Connect": "Échec de la connexion",
          "please verify network": "Veuillez vérifier le réseau",
          "Retry": "Réessayer",
          "Please wait": "Veuillez patienter",
          "Camera": "Caméra",
          "Failure": "Échec",
          "Gallery": "Galerie",
          "Ok": "OK",
          "Add": "Ajouter",
          "cancel": "Annuler",
          "Cancel": "Annuler",
          "Stop": "Arrêter",
          "Description": "Description",
          "Clients": "Clients",
          "Price": "Prix",
          "Treasury": "Trésorerie",
          "price can't be empty": "le prix ne peut pas être vide",
          "Please enter a valid price": "Veuillez entrer un prix valide",
          "Choose source": "Choisir la source",
          "no invoices added yet": "Aucune facture ajoutée pour l'instant",
          "Send": "Envoyer",
          "Language": "Langue",
          "Invoices": "Factures",
          "Change Language": "Changer de langue",
          "Connecting": "Connexion en cours",
          "graphic study": "Étude graphique",
          "Select your preferred language": "Sélectionnez votre langue préférée",
          "Workers": "Travailleurs",
          "French": "Français",
          "Arabic": "Arabe",
          "English": "Anglais",
          "Are you sure you want to check this invoice ?": "Êtes-vous sûr de vouloir vérifier cette facture ?",
          "Check": "Vérifier",
          "Invoice has been checked": "La facture a été vérifiée",
          "Are you sure you want to send this invoice ?": "Êtes-vous sûr de vouloir envoyer cette facture ?",
          "Change price/qty": "Changer prix/qty",
          "Change total sell": "Changer le total vendu",
          "Invoice type": "Type de facture",
          "Multiple": "Multiples",
          "Delivery": "Livraison",
          "Client": "Client",
          "Email:": "Email:",
          "Print Invoice": "Imprimer la facture",
          "total:": "total:",
          "price:": "prix:",
          "ID:": "ID:",
          "Total Kridi:": "Total Kridi:",
          "Verified:": "Vérifié:",
          "Total Expenses:": "Total des dépenses:",
          "Salary:": "Salaire:",
          "Speciality:": "Spécialité:",
          "Role:": "Rôle:",
          "Join Date:": "Date d'adhésion:",
          "Address:": "Adresse:",
          "Phone:": "Téléphone:",
          "Sex:": "Sexe:",
          "no expenses found": "Aucune dépense trouvée",
          "no kridi found": "Aucun Kridi trouvé",
          "income:": "revenu:",
          "society:": "société:",
          "qty:": "qty:",
          "January": "Janvier",
          "February": "Février",
          "March": "Mars",
          "April": "Avril",
          "May": "Mai",
          "June": "Juin",
          "July": "Juillet",
          "August": "Août",
          "September": "Septembre",
          "October": "Octobre",
          "November": "Novembre",
          "December": "Décembre",
          "Unknown": "Inconnu",
          "delete": "supprimer",
          "Are you sure you want to delete this image": "Êtes-vous sûr de vouloir supprimer cette image",
          "empty data": "données vides",
          "total Buy:": "total achat:",
          "total Sell:": "total vente:",
          "not valid": "non valide",
          "empty": "vide",
          "invoice": "facture",
          "removed": "supprimé",
          "Remove": "Supprimer",
          "Income:": "Revenu:",
          "Total:": "Total:",
          "rest quantity:": "quantité restante:",
          "Are you sure you want to remove this product ?": "Êtes-vous sûr de vouloir supprimer ce produit ?",
          "Are you sure you want to remove this client ?": "Êtes-vous sûr de vouloir supprimer ce client ?",
          "buy Price:": "Prix d'achat:",
          "sell Price:": "Prix de vente:",
          "type:": "type:",
          "Tel:": "Tél:",
          "Are you sure you want to remove this worker ?": "Êtes-vous sûr de vouloir supprimer ce travailleur ?",
          "expenses:": "dépenses:",
          "kridi:": "Kridi:",
          "desc:": "desc:",
          "Manual Changes": "Changements manuels",
          "Sell History": "Historique de vente",
          "Buy History": "Historique d'achat",
          "Info": "Info",
          "Expenses": "Dépenses",
          "Kridi": "Kridi",
          "Update Worker": "Mettre à jour le travailleur",
          "Add Worker": "Ajouter un travailleur",
          "New Worker": "Nouveau travailleur",
          "Enter name": "Entrez le nom",
          "Name": "Nom",
          "name can't be empty": "le nom ne peut pas être vide",
          "Age": "Âge",
          "Enter age": "Entrez l'âge",
          "Phone": "Téléphone",
          "Enter number": "Entrez le numéro",
          "number can't be empty": "le numéro ne peut pas être vide",
          "Enter address": "Entrez l'adresse",
          "Address": "Adresse",
          "address can't be empty": "l'adresse ne peut pas être vide",
          "Email": "Email",
          "Enter email": "Entrez l'email",
          "Role": "Rôle",
          "Enter role": "Entrez le rôle",
          "Speciality": "Spécialité",
          "Enter speciality": "Entrez la spécialité",
          "Salary": "Salaire",
          "Enter salary": "Entrez le salaire",
          "salary can't be empty": "le salaire ne peut pas être vide",
          "Please enter a valid salary": "Veuillez entrer un salaire valide"
        }

  };
}

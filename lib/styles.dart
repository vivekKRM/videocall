import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kMarqueeColor = Color(0xFF17535b);
final kBoxInActiveColor = Color(0xFFDFDFDF);
final kBottomNavColor = Color(0xFFED8A87);
final kFABColor = Color(0xFF384064);
final kToastColor = Color(0xFFD14D4D); //Color(0xFFE35858);
final kLoginTextFieldFillColor = Color(0xFFF6F7FB);
final kLoginIconColor = Color(0xFF8F9FB7);
final kSecondBoxColor = Color(0xFFFEF4E5);
final kboxColor = Color(0xFFE6F7F8); // #FEF4E5
final kHorizonatlColor = Color(0xFFECEDF5); // #FEF4E5
final kAppBarColor = Color(0xFFF6F7FB); //#09B3BE
final kDashboardColor = Color(0xFF09B3BE);

final topHeaderBar = Color(0xFFF6F7FB);
final backgroundColor = Color(0xFFF6F7FB);
final kButtonColor = Color(0xFFD14D4D);
final kCursorErrorColor = Color(0xFFD14D4D);

//OnBoarding
TextStyle kObsTitle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w600,
  color: Color(0xFF282828),
);

TextStyle kObsText = TextStyle(
  fontSize: 18,
  color: Color(0xFF72839D),
  fontWeight: FontWeight.w400,
);

TextStyle kButtonTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

//Added for Event
TextStyle kEventHeadStyle = TextStyle(
  fontSize: 15,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);
TextStyle kEventSubHeadStyle = TextStyle(
  fontSize: 12,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);
TextStyle kEventDateStyle = TextStyle(
  fontSize: 10,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle kMesssageTextStyle = const TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w600,
);

TextStyle kProfileTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle kEmailTextStyle = TextStyle(
  fontSize: 18,
  color: kButtonColor,
  fontWeight: FontWeight.w600,
);
TextStyle kNotesTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w600,
  color: Color(0xFF9FABC5),
);

TextStyle kSettingsTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle kAlertButtonTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.w800,
);

TextStyle kTermsTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
  fontWeight: FontWeight.w600,
);

TextStyle kMarqueeTextStyle = TextStyle(
  fontSize: 15,
  color: kButtonColor,
  decoration: TextDecoration.underline,
  decorationColor: kButtonColor,
  fontWeight: FontWeight.w600,
);
TextStyle kPdfdownloadTextStyle = TextStyle(
  fontSize: 13,
  color: kButtonColor,
  decoration: TextDecoration.underline,
  decorationColor: kButtonColor,
  fontWeight: FontWeight.w600,
);

TextStyle kGraphButtonTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

TextStyle kAcceptRejectButtonTextStyle = TextStyle(
  fontSize: 10,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

TextStyle kButtonSmallTextStyle = TextStyle(
  fontSize: 12,
  color: Colors.white,
);

TextStyle kReqTimeSlotTextStyle = TextStyle(
  fontSize: 15,
  color: Color(0xFF4D5463),
  fontWeight: FontWeight.w500,
);

TextStyle kLabelTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w500,
);

TextStyle kLabelTextStylePain = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle kNameTextStyle = TextStyle(
  color: Color(0xFF454F63),
  fontSize: 17, //19 28 Aug
  fontWeight: FontWeight.w700,
);
TextStyle kCameraOptionTextStyle = TextStyle(
  color: Color(0xFF454F63),
  fontSize: 16, //19 28 Aug
  fontWeight: FontWeight.w700,
);

TextStyle kupgradeTextStyle = TextStyle(
  color: Color(0xFF454F63),
  fontSize: 14, //19 28 Aug
  fontWeight: FontWeight.w900,
);

TextStyle kNamePainStyle = TextStyle(
  color: Color(0xFF454F63),
  fontSize: 19, //19 28 Aug
  fontWeight: FontWeight.w700,
);
TextStyle kNamePainTextStyle = TextStyle(
  color: Color(0xFF454F63),
  fontSize: 18, //19 28 Aug
  fontWeight: FontWeight.w700,
);

TextStyle kHomeTextStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w500,
);

TextStyle kCardHeadTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);

TextStyle kBackTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

TextStyle kCardValueTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF454F63),
);

TextStyle kNotesCardNameTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xFF454F63),
);

TextStyle kCardTextTextStyle = TextStyle(
  fontSize: 15,
  color: Color(0xFF636C80),
);

TextStyle kHeartRateTextTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.black,
);

TextStyle kStatusTimeTextStyle = TextStyle(
  fontSize: 12,
  color: Color(0xFF78849E),
);

TextStyle kCompanyNameTextStyle = TextStyle(
    fontSize: 12, color: Color(0xFF78849E), fontStyle: FontStyle.italic);

TextStyle kTableHeaderTextStyle = TextStyle(
  fontSize: 14,
  color: Color(0xFF484B5C),
  fontWeight: FontWeight.w600,
);

TextStyle kTableHeaderTextStyleCustom = TextStyle(
  fontSize: 10,
  color: Color(0xFF484B5C),
  fontWeight: FontWeight.w600,
);

TextStyle kTableCellTextStyle = TextStyle(
  fontSize: 13,
  color: Color(0xFF575D6E),
  fontWeight: FontWeight.w500,
);

TextStyle kTableCellTextStyleCustom = TextStyle(
  fontSize: 9,
  color: Color(0xFF575D6E),
  fontWeight: FontWeight.w500,
);

TextStyle kNotesCardVitalTextStyle = TextStyle(
  fontSize: 12,
  color: Color(0xFF6E7485),
  fontWeight: FontWeight.w300,
);

TextStyle kCardHeadingTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

TextStyle kGoalCardHeadingTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
);

TextStyle kGoalCardNameTextStyle = TextStyle(
  fontSize: 13,
  color: Color(0xFF777B81),
);

TextStyle kGoalCardSetGoalTextStyle = TextStyle(
  fontSize: 13,
  color: Color(0xFF515151),
);

TextStyle kCardInactiveHeadingTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

TextStyle kCardMinMaxTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Color(0xFF9FABC5),
);

TextStyle kGoalCardTextStyle = TextStyle(
  color: Color(0xFF8B8B8B),
  fontSize: 14,
);

TextStyle kGraphCardValueTextStyle = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  color: Color(0xFF454F63),
);

TextStyle kGraphCardTextTextStyle = TextStyle(
  fontSize: 11,
  color: Color(0xFF78849E),
);

TextStyle kProfileDeviceStatsTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Color(0xFF4D5463),
);

TextStyle kSetGoalBoxHeadingTextStyle = TextStyle(
  color: Color(0xFFCE6278),
  fontSize: 15,
);

TextStyle kSetGoalTextFieldHeadingTextStyle = TextStyle(
  color: Color(0xFF4D5463),
  fontSize: 12,
);

TextStyle kCGValueTextStyle = TextStyle(
  fontSize: 22,
  color: Color(0xFF979797),
  fontWeight: FontWeight.w700,
);

TextStyle kCGTextStyle = TextStyle(
  fontSize: 10,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

TextStyle kDrawerNameTextStyle = TextStyle(
  fontSize: 22,
  color: Colors.white,
);

TextStyle kDrawerEmailTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white.withOpacity(0.56),
);

TextStyle kDrawerTileTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.white,
);

TextStyle kDrawerTileTextStyleDisabled = TextStyle(
  fontSize: 14,
  color: Colors.white38,
);

TextStyle kTipsTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w900,
  color: Color(0xFF535C6E),
);

TextStyle kTipTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF828282),
);

TextStyle kReqVisitTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 13,
  color: Color(0xFF4D5463),
);

TextStyle kProfileDateTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 10,
  color: Color(0xFF4D5463),
);

TextStyle kReqVisitValueTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: Color(0xFF4D5463).withOpacity(0.72),
);

TextStyle kChartNotSelectedTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: Color(0xFF4D5463),
);
TextStyle kChartSelectedTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: Colors.white,
);

TextStyle kChartSelectedValueTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 12,
  color: Colors.white.withOpacity(0.72),
);

TextStyle kPopupTitleTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 23,
  color: Color(0xFF3F4551),
);

TextStyle kPopupTitleSubTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 18,
  color: Color(0xFF3F4551),
);

TextStyle kPopupContentTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF767D8B),
);

TextStyle kPopupMessageTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFF9E9E9E),
);

TextStyle kPopupVitalTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF78849E),
);

TextStyle kPopupValueTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Color(0xFF454F63),
);

TextStyle kPopupDescriptionTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  color: Color(0xFF5A5B5E),
);

// TextStyle klogoutcTextStyle = TextStyle(
//   fontSize: 20,
//   color: kbuttonColor,
//   fontWeight: FontWeight.w600,
// );
// TextStyle klogoutTextStyle = TextStyle(
//   fontSize: 20,
//   color: kStatusTextColorCrisis,
//   fontWeight: FontWeight.w600,
// );

TextStyle kLoginTextStyle = TextStyle(
  fontSize: 32,
  fontWeight: FontWeight.w600,
  color: Color(0xFF282828),
);

TextStyle kLoginSubTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Color(0xFF282828),
);

TextStyle kLoginLabelText = TextStyle(
  fontSize: 17,
  color: Colors.black54,
  fontWeight: FontWeight.w500,
);

TextStyle kLoginErrorText = TextStyle(
  fontSize: 19,
  color: kCursorErrorColor,
  fontWeight: FontWeight.w500,
);

TextStyle kLoginTextFieldTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Color(0xFF8F9FB7),
);

TextStyle kLoginTextFieldLabel = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xFF8F9FB7),
);

InputDecoration customInputDecoration({
  required IconData icon,
  required String labelText,
  required String hintText,
  String? errorText,
  required Color iconColor,
  required Color focusedBorderColor,
  required Color enabledBorderColor,
  required Color errorBorderColor,
  required TextStyle labelStyle,
  required TextStyle hintStyle,
  required TextStyle errorStyle,
}) {
  return InputDecoration(
    icon: Icon(icon, size: 20, color: iconColor),
    border: UnderlineInputBorder(),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: focusedBorderColor, width: 2.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: enabledBorderColor, width: 2.0),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor, width: 2.0),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: errorBorderColor, width: 2.0),
    ),
    labelStyle: labelStyle,
    labelText: labelText,
    errorStyle: errorStyle,
    errorText: errorText,
    isDense: true,
    hintText: hintText,
    hintStyle: hintStyle,
  );
}

TextStyle kDropDownTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Color(0xFF282828),
);

TextStyle kHeaderTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Color(0xFF282828),
);

TextStyle kHeaderStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Color(0xFF282828),
);

TextStyle kDashboardTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

TextStyle kCongratsTextStyle = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.w600,
  color: Color(0xFF282828),
);

TextStyle kalertTitleTextStyle = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    color: Colors.black //Color(0xFF5B5B5B),
    );

TextStyle kvaccineTextStyle = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    color: Colors.black //Color(0xFF5B5B5B),
    );

TextStyle kForgotDetailTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: kButtonColor,
);

TextStyle kForgotPasswordTextFieldTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Color(0xFF5B5B5B),
);

TextStyle kForgotPasswordTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w500,
  color: Color(0xFF72839D),
);

TextStyle kSignUpTextStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w600,
  color: kButtonColor,
);
TextStyle kNotesCardTimeTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Color(0xFF9FABC5),
);

TextStyle kBarButtonTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w600,
  color: kButtonColor,
);
TextStyle kMessageDayTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFFA8A8A8),
);

TextStyle kMessageNameTimeTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Color(0xFF8F949E),
);

TextStyle kMessageSenderTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFFFFFFFF),
);

TextStyle kMessageReceivingTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF3A3D40),
);

TextStyle kUploadsBoxTextStyle =
    TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white);

TextStyle kUploadsBoxCaptionTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

TextStyle kUploadsBoxSizeTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFFA0A4AC),
);

TextStyle kPHPopupTitleTextStyle = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

TextStyle kPHPopupOptionsTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Color(0xFF848484),
);

TextStyle kPHPopupOptionsSelectedTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w500,
  color: Colors.white,
);

TextStyle kPHPopupCheckListTitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xFF757575),
);

TextStyle kPHPopupUnderlineCheckListTitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  decoration: TextDecoration.underline,
);

TextStyle kPHPopupCheckListSmallNoteTextStyle = TextStyle(
  fontSize: 10,
  color: Color(0xFF949494),
);

TextStyle kCgNotesTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF78849E),
);

TextStyle kCheckBoxTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Color(0xFF686868),
);

TextStyle kPsyNumTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFFA9ABAF),
);

TextStyle kPsyQueTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFF767D8B),
);

TextStyle kPsyAnsTextStyle = TextStyle(
  fontSize: 10,
  fontWeight: FontWeight.w500,
  color: Color(0xFF474343),
);

TextStyle kPsyLastQuesTextStyle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Color(0xFF757575),
);

TextStyle kPhScoreTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w700,
  color: Color(0xFF4CB550),
);

TextStyle kMedicineNameTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: Colors.white,
);

TextStyle kMedicineNotesTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Color(0xFF4A5359),
);

TextStyle PainHeading = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

TextStyle kMedicineDateTextStyle = TextStyle(
  fontSize: 11,
  color: Color(0xFF939cad),
);

TextStyle kDosageTextStyle = TextStyle(
  fontSize: 12,
  color: Color(0xFF808080),
);

TextStyle kDosageTakenOnTextStyle = TextStyle(
  fontSize: 11,
  color: Colors.white,
);

TextStyle kDosageTakenOffTextStyle = TextStyle(
  fontSize: 11,
  color: Color(0xFF9E9E9E),
);

TextStyle kTabSelectedTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Color(0xFFE67C93),
);

TextStyle kTabTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w500,
  color: Color(0xFFAFB4BF),
);

TextStyle kProfileDeviceNameTextStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: Color(0xFF464950),
);

TextStyle kProfileDeviceValueTextStyle = TextStyle(
  fontSize: 23,
  fontWeight: FontWeight.w700,
  color: Color(0xFF144DD2),
);

TextStyle kGoodPainTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: Color(0xFF00B60F),
);

TextStyle kMildPainTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: Color(0xFF8DD400),
);

TextStyle kModeratePainTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: Color(0xFFFFBB03),
);

TextStyle kSeverePainTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: Color(0xFFFF8B00),
);

TextStyle kWorstPainTextStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: Color(0xFFF11E01),
);

TextStyle kBigGoodPainTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w900,
  color: Color(0xFF00B60F),
);

TextStyle kToastTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
  fontWeight: FontWeight.w400,
);
TextStyle kDisabledColor = TextStyle(
  fontSize: 14,
  color: Colors.white60,
);
TextStyle kContainerColor = TextStyle(
  fontSize: 21,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

TextStyle kCardTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

TextStyle kCardSubTextStyle = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

TextStyle kConsentPageTextStyle =
    GoogleFonts.poppins(fontSize: 15, color: Colors.black);

TextStyle kConsentNameTextStyle =
    GoogleFonts.poppins(fontSize: 20, color: Colors.black);

TextStyle kConsentNumberTextStyle = GoogleFonts.poppins(
  fontWeight: FontWeight.bold,
  fontSize: 14,
  color: Colors.black,
);
TextStyle kUnderlineTextStyle = GoogleFonts.poppins(
  fontWeight: FontWeight.bold,
  fontSize: 17,
  color: Colors.black,
  decoration: TextDecoration.underline,
);
TextStyle kConsentTableTextStyle = GoogleFonts.poppins(
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: Colors.black,
);
TextStyle kConsentsubHeadTextStyle = GoogleFonts.poppins(
  fontWeight: FontWeight.w600,
  fontSize: 15,
  color: Colors.black,
);

String capitalizeFirstLetter(String s) =>
    (s?.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

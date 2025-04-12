import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {

  static final TextStyle title = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle loginNovoEsqueci = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle textLogin = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.0

  );
  static TextStyle loginHint = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle titlePet = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle titleCardVacina = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 25,
    fontWeight: FontWeight.w400,
  );

  static TextStyle textoSentimentoNegritoWhite(int tamanho, BuildContext context){

    return TextStyle(
      fontFamily: "Netflix",
      fontWeight: FontWeight.w600,
      fontSize:  MediaQuery.of(context).size.width / tamanho,
      letterSpacing: 0.0,
      color: Colors.black,
    );
  }
  static TextStyle titleAppBarUsuario(int numero, BuildContext context) {

    return GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize:  MediaQuery.of(context).size.width / numero,
    fontWeight: FontWeight.w400,
  ) ;

}
  static TextStyle subTitleCardWhite(int numero, BuildContext context) {

    return GoogleFonts.notoSans(
      color: AppColors.white,
      fontSize:  MediaQuery.of(context).size.width / numero,
      fontWeight: FontWeight.normal,
    ) ;

  }
  static TextStyle subTitleGeneric(int numero, var width, Color color, FontWeight fontWeight) {

    return GoogleFonts.notoSans(
      color: color,
      fontSize:  width / numero,
      fontWeight: fontWeight,
    ) ;

  }
  static TextStyle titleCardBlack(int numero, BuildContext context) {

    return GoogleFonts.notoSans(
      color: AppColors.black,
      fontSize:  MediaQuery.of(context).size.width / numero,
      fontWeight: FontWeight.w600,
    ) ;

  }
  static TextStyle titleCardWhite(int numero, BuildContext context) {

    return GoogleFonts.notoSans(
      color: AppColors.white,
      fontSize:  MediaQuery.of(context).size.width / numero,
      fontWeight: FontWeight.w600,
    ) ;

  }
  static TextStyle subTitleCardBlack(int numero, BuildContext context) {

    return GoogleFonts.notoSans(
      color: AppColors.black,
      fontSize:  MediaQuery.of(context).size.width / numero,
      fontWeight: FontWeight.normal,
    ) ;

  }

  static TextStyle titleLogin(){
    return  GoogleFonts.notoSans(
      color: AppColors.white,
      fontSize: 25,
      fontWeight: FontWeight.w600,
      );
    }

  static final TextStyle titleBold = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle subTitleBold = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );



  static final TextStyle heading = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static final TextStyle dataText = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading40 = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 40,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading25 = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 25,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle heading15 = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 13,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyBold = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 13,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle vacinaNaoAplicada = GoogleFonts.notoSans(
    color: AppColors.vermelho,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal

  );
  static final TextStyle vacinaDose = GoogleFonts.notoSans(
      color: AppColors.black,
      fontSize: 13,
      fontWeight: FontWeight.normal,


  );
  static final TextStyle vacinaNome = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 13,
    fontWeight: FontWeight.bold,


  );
  static final TextStyle total = GoogleFonts.notoSans(
    color: AppColors.black,
    fontSize: 13,
    backgroundColor: Colors.transparent,
    fontWeight: FontWeight.bold,


  );
  static final TextStyle vacinaAplicada = GoogleFonts.notoSans(
    color: AppColors.verde,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal

  );

  static final TextStyle bodylightGrey = GoogleFonts.notoSans(
    color: AppColors.lightGreen,
    fontSize: 13,
    fontWeight: FontWeight.normal
  );
  static final TextStyle bodyDarkGreen = GoogleFonts.notoSans(
    color: AppColors.darkGreen,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyDarkRed = GoogleFonts.notoSans(
    color: AppColors.darkRed,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle body20 = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle bodyLightGrey20 = GoogleFonts.notoSans(
    color: AppColors.lightGrey,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );

  static final TextStyle bodyWhite20 = GoogleFonts.notoSans(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.normal,
  );
  static final TextStyle body11 = GoogleFonts.notoSans(
    color: AppColors.grey,
    fontSize: 11,
    fontWeight: FontWeight.normal,
  );
}

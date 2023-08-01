import 'dart:ffi';

import 'package:the_chess_master/Case.dart';

class ChessBoard {
  String? Position;
  Map<String,Case>? cases;
  ChessBoard(){
    String numericalVals = "0123456789";
    String alphaVals = "abcdefgh";
    Position = "r6k/pp2r2p/4Rp1Q/3p4/8/1N1P2R1/PqP2bPP/7K b - - 0 24";
    cases = new Map<String,Case>();
    List<String> parts = Position!.split(" ");
    String extractedFENposition = parts[0];
    List<String> rows = Position!.split('/');
    for (int i = 0; i < rows.length; i++) {
      String s = rows[i];
      for(int j = 0;j<s.length;j++){
        if ( ! numericalVals.contains(s[j])) {
          String casePos = alphaVals[j]+numericalVals[j+1];
          cases?[casePos] = new Case(s[j]);
        }
      }
    }
  }
}
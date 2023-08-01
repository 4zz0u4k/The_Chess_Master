import 'package:the_chess_master/Piece.dart';

class Case {
  bool? isEmpty;
  bool? isTargeted;
  Piece? piece;
  Case(String name){
    isEmpty = false;
    isTargeted = false;
    piece = new Piece(name);
  }
}
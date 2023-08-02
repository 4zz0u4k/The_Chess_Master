import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;


void main() => runApp(MaterialApp(
  home: ChessBoard(),
));

class ChessBoard extends StatefulWidget {
  @override
  _ChessBoardState createState() => _ChessBoardState();

}
class _ChessBoardState extends State<ChessBoard> {
  List HighLightPosition = [];
  chess.Chess position = chess.Chess.fromFEN('r6r/1pNk1ppp/2np4/b3p3/4P1b1/N1Q5/P4PPP/R3KB1R w KQ - 3 18');
  String AlphCars = "abcdefgh";
  String NumCars = "012345678";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridCellSize = screenWidth / 8;
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1.0, // Makes sure the cells are square
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
              onTap: () {
                //get the position
                String TappedPosition;
                if(position.turn == chess.Color.BLACK){
                  TappedPosition = AlphCars[7-(index % 8)]+NumCars[(index ~/ 8)+1];
                }else{
                  TappedPosition = AlphCars[index % 8]+NumCars[8-((index ~/ 8))];
                }
                if(position.get(TappedPosition) != null){
                  if(position.get(TappedPosition)?.color == position.turn){
                    Map options = {'asObjects': true};
                    List Positions =  position.moves(options).where((move) => move.from == chess.Chess.SQUARES[TappedPosition]!).toList();
                    setState(() {
                      HighLightPosition = Positions;
                      print(HighLightPosition);
                    });
                  }else{
                    setState(() {
                      HighLightPosition = [];
                    });
                  }
                }else{
                  setState(() {
                    HighLightPosition = [];
                  });
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children : [
                  Container(
                    width: gridCellSize,//Size
                    height: gridCellSize,//Size
                    color: (((index ~/ 8 ) % 2) == 0 ) ? ((index % 2 == 0) ? Colors.yellow[100] : Colors.green ) : ((index % 2 != 0) ? Colors.yellow[100] : Colors.green ),//The case color
                    child: Center(//The piece
                      child : (){
                        if(position.turn == chess.Color.BLACK){
                          if(position.get(AlphCars[7-(index % 8)]+NumCars[(index ~/ 8)+1]) != null){
                            if(position.get(AlphCars[7-(index % 8)]+NumCars[(index ~/ 8)+1])?.color == chess.Color.BLACK){
                              switch(position.get(AlphCars[7-(index % 8)]+NumCars[(index ~/ 8)+1])?.type) {
                                case chess.PieceType.KING:
                                  return Image.asset("assets/BlackKing.png");
                                case chess.PieceType.KNIGHT:
                                  return Image.asset("assets/BlackKnight.png");
                                case chess.PieceType.BISHOP:
                                  return Image.asset("assets/BlackBishop.png");
                                case chess.PieceType.QUEEN:
                                  return Image.asset("assets/BlackQueen.png");
                                case chess.PieceType.PAWN:
                                  return Image.asset("assets/BlackPawn.png");
                                case chess.PieceType.ROOK:
                                  return Image.asset("assets/BlackRook.png");
                                default:
                                  return null;
                              }
                            }
                            else{
                              switch(position.get(AlphCars[7-(index % 8)]+NumCars[(index ~/ 8)+1])?.type) {
                                case chess.PieceType.KING:
                                  return Image.asset("assets/WhiteKing.png");
                                case chess.PieceType.KNIGHT:
                                  return Image.asset("assets/WhiteKnight.png");
                                case chess.PieceType.BISHOP:
                                  return Image.asset("assets/WhiteBishop.png");
                                case chess.PieceType.QUEEN:
                                  return Image.asset("assets/WhiteQueen.png");
                                case chess.PieceType.PAWN:
                                  return Image.asset("assets/WhitePawn.png");
                                case chess.PieceType.ROOK:
                                  return Image.asset("assets/WhiteRook.png");
                                default:
                                  return null;
                              }
                            }
                          }
                          return null;
                        }else{
                          if(position.get(AlphCars[index % 8]+NumCars[8-((index ~/ 8))]) != null){
                            if(position.get(AlphCars[index % 8]+NumCars[8-((index ~/ 8))])?.color == chess.Color.BLACK){
                              switch(position.get(AlphCars[index % 8]+NumCars[8-((index ~/ 8))])?.type) {
                                case chess.PieceType.KING:
                                  return Image.asset("assets/BlackKing.png");
                                case chess.PieceType.KNIGHT:
                                  return Image.asset("assets/BlackKnight.png");
                                case chess.PieceType.BISHOP:
                                  return Image.asset("assets/BlackBishop.png");
                                case chess.PieceType.QUEEN:
                                  return Image.asset("assets/BlackQueen.png");
                                case chess.PieceType.PAWN:
                                  return Image.asset("assets/BlackPawn.png");
                                case chess.PieceType.ROOK:
                                  return Image.asset("assets/BlackRook.png");
                                default:
                                  return null;
                              }
                            }
                            else{
                              switch(position.get(AlphCars[index % 8]+NumCars[8-((index ~/ 8))])?.type) {
                                case chess.PieceType.KING:
                                  return Image.asset("assets/WhiteKing.png");
                                case chess.PieceType.KNIGHT:
                                  return Image.asset("assets/WhiteKnight.png");
                                case chess.PieceType.BISHOP:
                                  return Image.asset("assets/WhiteBishop.png");
                                case chess.PieceType.QUEEN:
                                  return Image.asset("assets/WhiteQueen.png");
                                case chess.PieceType.PAWN:
                                  return Image.asset("assets/WhitePawn.png");
                                case chess.PieceType.ROOK:
                                  return Image.asset("assets/WhiteRook.png");
                                default:
                                  return null;
                              }
                            }
                          }
                          return null;
                        }
                      }(),
                    ),
                  ),
                  Container(
                    child: (){
                      String currentPos = '';
                      if(position.turn == chess.Color.BLACK){
                        currentPos = AlphCars[7-(index % 8)]+NumCars[(index ~/ 8)+1];
                      }
                      else{
                        currentPos = AlphCars[index % 8]+NumCars[8-((index ~/ 8))];
                      }
                      for(chess.Move move in HighLightPosition){
                        if(move.toAlgebraic == currentPos){
                          return Image.asset(
                            "assets/Ring.png",
                            width: gridCellSize-4,
                            height: gridCellSize-4,
                            //opacity: const AlwaysStoppedAnimation(.8),
                          );
                        }
                      }
                    }(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}







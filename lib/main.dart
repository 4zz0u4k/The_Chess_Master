import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;


void main() {
  String Solution = "e5f6 e8e1 g1f2 e1f1";
  chess.Chess initialePos = chess.Chess.fromFEN('4r3/1k6/pp3r2/1b2P2p/3R1p2/P1R2P2/1P4PP/6K1 w - - 0 35');
  List<String> initSolutions = Solution.split(' ');
  Map options = {'asObjects': true};
  for(chess.Move move in initialePos.moves()){
    if(move.toAlgebraic == initSolutions[0].substring(4-2)){
      //Move the piece
      initialePos.move(move);
    }
  }
  initSolutions.removeAt(0);

  runApp(MaterialApp(
    home: ChessBoard(
      position : initialePos,
      solution: initSolutions,
    ),
  ));
}

class ChessBoard extends StatefulWidget {
  final chess.Chess position;
  final List<String> solution;
  ChessBoard({required this.position, required this.solution});
  @override
  _ChessBoardState createState() => _ChessBoardState();

}
class _ChessBoardState extends State<ChessBoard> {
  List HighLightPosition = [];
  bool isOnSelection = false;
  bool first = true;
  chess.Chess position = chess.Chess();
  String AlphCars = "abcdefgh";
  String NumCars = "012345678";
  @override
  void initState() {
    super.initState();
    position = widget.position;
    List<String> solutionMoves = widget.solution;
    // Now you can use the extracted strings from the solution
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridCellSize = screenWidth / 8;
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 1.0,
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
                if(!isOnSelection){
                  if(position.get(TappedPosition) != null){
                    if(position.get(TappedPosition)?.color == position.turn){
                      Map options = {'asObjects': true};
                      List Positions =  position.moves(options).where((move) => move.from == chess.Chess.SQUARES[TappedPosition]!).toList();
                      if(Positions.isNotEmpty){
                        isOnSelection = true;
                        setState(() {
                          HighLightPosition = Positions;
                        });
                      }
                    }
                  }
                }else{ //About to select a Square or just leave the choices
                  for(chess.Move move in HighLightPosition){
                    if(move.toAlgebraic == TappedPosition){
                      //Move the piece
                      position.move(move);
                      setState(() {
                        HighLightPosition = [];
                      });
                    }
                  }
                  isOnSelection = false;
                  if(!HighLightPosition.isEmpty){
                    setState(() {
                      HighLightPosition = [];
                    });
                  }
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







import 'dart:async';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

void SetUpThePuzzle(String Solution,chess.Chess initialePos,List<String> initSolutions){
  initSolutions.clear();
  initSolutions.addAll(Solution.split(' '));
  Map options = {'asObjects': true};
  for(chess.Move move in initialePos.moves(options)){
    if(move.toAlgebraic == initSolutions[0].substring(2)){
      //Move the piece
      initialePos.move(move);
      break;
    }
  }
  initSolutions.removeAt(0);
}

void updatePuzzle(chess.Chess position,List<String> initSolutions) {
  position.clear();
  position.load("2rq2k1/1R3pp1/p5bp/8/1P2RQ1P/8/6P1/7K b - - 0 38");
  SetUpThePuzzle("g6e4 f4f7 g8h8 f7g7",position,initSolutions);
  print("heheheheh rana hna !!");
  print(initSolutions);
  print(position.move_number);
}

void main() {

  List<String> initSolutions = [];
  String Solution = "e5f6 e8e1 g1f2 e1f1";
  chess.Chess initialePos = chess.Chess.fromFEN('4r3/1k6/pp3r2/1b2P2p/3R1p2/P1R2P2/1P4PP/6K1 w - - 0 35');
  SetUpThePuzzle(Solution,initialePos,initSolutions);
  print(initSolutions);
  runApp(MaterialApp(
    home: Center(
      child: ChessBoard(
      position : initialePos,
      solution: initSolutions,
      onPuzzleSolved: updatePuzzle,
      ),
    ),
  ));
}

class ChessBoard extends StatefulWidget {
  chess.Chess position;
  List<String> solution;
  final Function onPuzzleSolved;

  ChessBoard({required this.position, required this.solution,required this.onPuzzleSolved});

  @override
  _ChessBoardState createState() => _ChessBoardState();

}
class _ChessBoardState extends State<ChessBoard> {
  List HighLightPosition = [];
  bool isOnSelection = false;
  List<String> solutionMoves = [];
  chess.Chess position = chess.Chess();
  String AlphCars = "abcdefgh";
  String NumCars = "012345678";

  @override
  void initState() {
    super.initState();
    position = widget.position;
    solutionMoves = widget.solution;
  }

  void _handlePuzzleSolved(chess.Chess position , List<String> Solutions) {
    // Perform any logic you need when the puzzle is solved
    widget.onPuzzleSolved(position , Solutions); // Call the callback function
    print(Solutions);
    print(position.move_number);
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
                      if(TappedPosition != solutionMoves[0].substring(2)){
                        print("Nein BYE BYE !!");
                      }
                      else{
                        //Move the piece
                        chess.Color lastOne = position.turn;
                        position.move(move);
                        solutionMoves.removeAt(0);
                        if(solutionMoves.isEmpty){
                          print("c bon frr");
                          position.turn = lastOne;
                        }
                        else{
                          Map options = {'asObjects': true};
                          for(chess.Move move in position.moves(options)){
                            if(move.toAlgebraic == solutionMoves[0].substring(2)){
                              //Move the piece
                              position.move(move);
                              break;
                            }
                          }
                          solutionMoves.removeAt(0);
                        }
                        setState(() {
                          HighLightPosition = [];
                        });
                        if(solutionMoves.isEmpty){
                          print("heheheheh rana hna !!");
                          _handlePuzzleSolved(position , solutionMoves);
                          print(solutionMoves);
                          print(position.move_number);
                          setState(() {});
                        }
                      }
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







import 'dart:html';

import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;

bool SolvedGlobal = false;


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


void main() {
  runApp(MyApp());
}




class ChessBoard extends StatefulWidget {
  chess.Chess position;
  List<String> solution;
  final Function onPuzzleSolved;
  bool showHint;

  ChessBoard({required this.showHint ,required this.position, required this.solution,required this.onPuzzleSolved});

  @override
  _ChessBoardState createState() => _ChessBoardState();

}
class _ChessBoardState extends State<ChessBoard> {

  List HighLightPosition = [];

  String HintedSquare = "";
  bool showHint = false;

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
    showHint = widget.showHint;
  }

  void updateHintedPositon(){
    setState(() {
      showHint = true;
    });
  }

  void _handlePuzzleSolved(chess.Chess position , List<String> Solutions) {
    // Perform any logic you need when the puzzle is solved
    SolvedGlobal = true;
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridCellSize = screenWidth / 8;
    double aspectRatio = 1.0;
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: aspectRatio,
        ),
        itemCount: 64,
        itemBuilder: (context, index) {
          return Container(
            width: gridCellSize,
            height: gridCellSize,
            child : GestureDetector(
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
                      if((TappedPosition != solutionMoves[0].substring(2)) || (move.fromAlgebraic.toString() != solutionMoves[0].substring(0,2))){
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
                    child: Container(//The piece
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
                          return Container(
                            child: Image.asset(
                              "assets/Ring.png",
                              width: gridCellSize-4,
                              height: gridCellSize-4,
                              //opacity: const AlwaysStoppedAnimation(.8),,
                          )

                          );
                        }
                      }
                    }(),
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
                      if( (currentPos == solutionMoves[0].substring(0,2)) && (showHint) ){
                        return Container(
                          color: Colors.blue.withOpacity(0.5),
                          width: gridCellSize,
                          height: gridCellSize,
                        );
                      }
                    }()
                  ),
                ],
              ),
            ),
          );
        },
    );
  }
}
enum Level{
  hard,
  beginner,
  master,
  intermediate
}

void updatePuzzle(chess.Chess position,List<String> initSolutions) {
  position.clear();
  position.load("2rq2k1/1R3pp1/p5bp/8/1P2RQ1P/8/6P1/7K b - - 0 38");
  SetUpThePuzzle("g6e4 f4f7 g8h8 f7g7",position,initSolutions);
  print("heheheheh rana hna !!");
  print(initSolutions);
  print(position.move_number);
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  Widget build(BuildContext context) {

    List<String> initSolutions = [];
    String Solution = "e5f6 e8e1 g1f2 e1f1";
    chess.Chess initialePos = chess.Chess.fromFEN('4r3/1k6/pp3r2/1b2P2p/3R1p2/P1R2P2/1P4PP/6K1 w - - 0 35');
    SetUpThePuzzle(Solution,initialePos,initSolutions);
    double screenWidth = MediaQuery.of(context).size.width;

    bool showHint = false;

    void HintButtonTriggered(){
      setState(() {
        showHint = true;
      });
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: screenWidth,
                color: Colors.brown,
                child : UpperInfos(
                  challengeId: "04DX",
                  elo: 750,
                  Theme: "Double King Atack mate in 2",
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.brown,
                child: ChessBoard(
                 position : initialePos,
                 solution: initSolutions,
                 onPuzzleSolved: updatePuzzle,
                  showHint : showHint,
              ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blueAccent,
                width: screenWidth,
                child: GameInfos(
                  Hint: HintButtonTriggered,
                  showOptions: SolvedGlobal,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}





class GameInfos extends StatefulWidget {
  void Hint;
  bool showOptions;
  GameInfos({required this.showOptions , required this.Hint});

  @override
  State<GameInfos> createState() => _GameInfosState();
}

class _GameInfosState extends State<GameInfos> {

  int solvedPuzzles = 0;
  int avreageElo = 0;
  int highestSolvedElo = 0;
  bool showOptions = false;


  _callForHint(){
    widget.Hint;
  }


  @override
  void initState() {
    showOptions = widget.showOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Solved Puzzles : ${solvedPuzzles}",
          style: TextStyle(
            fontFamily: "Magra",
            fontSize: 20,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          "Average Elo : ${avreageElo}",
          style: TextStyle(
            fontFamily: "Magra",
            fontSize: 20,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          "Highest Solved Puzzle Elo : ${highestSolvedElo}",
          style: TextStyle(
            fontFamily: "Magra",
            fontSize: 20,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: (){},
                child: const Text("...")
            ),
            ElevatedButton(
                onPressed: (){
                  _callForHint();
                  },
                child: const Text("Hint")),
          ],
        )
        ,
      ],
    );
  }
}
























class UpperInfos extends StatefulWidget {
  String challengeId;
  int elo;
  String Theme;
  UpperInfos({required this.challengeId,required this.elo,required this.Theme});
  @override
  State<UpperInfos> createState() => _UpperInfosState();
}

class _UpperInfosState extends State<UpperInfos> {
  String challengeId = "";
  int elo = 0;
  String Theme = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    challengeId = widget.challengeId;
    elo = widget.elo;
    Theme = widget.Theme;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LevelDeficulty(elo: elo),
        SizedBox(height: 8.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Elo : ${elo}",
              style: TextStyle(
                fontFamily: "Magra",
                fontSize: 18,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              "Puzzle ID : ${challengeId}",
              style: TextStyle(
                fontFamily: "Magra",
                fontSize: 18,
              ),
            ),
            SizedBox(height: 2.0),
            Text(
              "Theme : ${Theme}",
              style: TextStyle(
                fontFamily: "Magra",
                fontSize: 18,
              ),
            ),
          ],
        )
      ],
    );
  }
}


class LevelDeficulty extends StatefulWidget {
  int elo;

  LevelDeficulty({required this.elo});

  @override
  State<LevelDeficulty> createState() => _LevelDeficultyState();
}

class _LevelDeficultyState extends State<LevelDeficulty> {
  int elo = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    elo = widget.elo;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: (){
            Color color;
            if(elo<=500){
              color = Color.fromRGBO(96, 244, 119, 1.0);
              return(
                  Container(
                    width: screenWidth*0.5,
                    height: screenHeight*0.055,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                    ),
                  )
              );
            }else if(500< elo && elo <= 1000){
              color = Color.fromRGBO(241, 200, 63, 1.0);
              return(
                  Container(
                    width: screenWidth*0.5,
                    height: screenHeight*0.055,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                    ),
                  )
              );
            }else{
              color = Color.fromRGBO(234, 42, 42, 1.0);
              return(
                  Container(
                    width: screenWidth*0.5,
                    height: screenHeight*0.055,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                    ),
                  )
              );
            }
          }(),
        ),
        Container(
          child: (){
            String text;
            if(elo<=500){
              text = "Beginner";
            }else if(500< elo && elo <= 1000){
              text = "intermediate";
            }else{
              text = "expert";
            }
            return(
                Text(
                  "${text}",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white, // Set the color here
                  ),
                )
            );
          }(),
        ),
      ],
    );
  }
}









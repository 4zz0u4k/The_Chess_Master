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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double gridCellSize = screenWidth / 8;
    chess.Chess position = chess.Chess.fromFEN('4r3/1k6/pp3r2/1b2P2p/3R1p2/P1R2P2/1P4PP/6K1 w - - 0 35');
    String AlphCars = "abcdefgh";
    String NumCars = "012345678";
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
              },
              child: Container(
                width: gridCellSize,
                height: gridCellSize,
                color: (((index ~/ 8 ) % 2) == 0 ) ? ((index % 2 == 0) ? Colors.yellow[100] : Colors.green ) : ((index % 2 != 0) ? Colors.yellow[100] : Colors.green ),
                child: Center(
                  child : (){
                    if(position.get(AlphCars[index % 8]+NumCars[(index ~/ 8)+1]) != null){
                      print(position.get(AlphCars[index % 8]+NumCars[(index ~/ 8)+1])?.type);
                      switch(position.get(AlphCars[index % 8]+NumCars[(index ~/ 8)+1])?.type) {
                        case 'k':
                          return Image.asset("assets/BlackKing.png");
                        case 'n':
                          return Image.asset("assets/BlackKnight.png");
                        case 'b':
                          return Image.asset("assets/BlackBishop.png");
                        case 'q':
                          return Image.asset("assets/BlackQueen.png");
                        case 'p':
                          return Image.asset("assets/BlackPawn.png");
                        case 'r':
                          return Image.asset("assets/BlackRook.png");
                        default:
                          return null;
                      }
                    }
                    return null;
                  }(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}







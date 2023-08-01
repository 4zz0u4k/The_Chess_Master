import 'package:flutter/material.dart';

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
                print('$index');
              },
              child: Container(
                width: gridCellSize,
                height: gridCellSize,
                color: (((index ~/ 8 ) % 2) == 0 ) ? ((index % 2 == 0) ? Colors.yellow[100] : Colors.green ) : ((index % 2 != 0) ? Colors.yellow[100] : Colors.green ),
                child: Center(
                  child: Text(
                    '$index',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}







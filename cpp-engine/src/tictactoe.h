#ifndef TICTACTOE_H
#define TICTACTOE_H

#include <vector>

enum class Player { NONE,
                    X,
                    O };

class TicTacToe {
   public:
    TicTacToe();
    void reset();
    bool makeMove(int row, int col);
    void makeAiMove();
    Player getCurrentPlayer() const;
    Player checkWinner() const;
    const std::vector<std::vector<Player>>& getBoard() const;
    bool isBoardFull() const;

   private:
    std::vector<std::vector<Player>> board;
    Player currentPlayer;

    int minimax(std::vector<std::vector<Player>> board, bool isMaximizing);
};

#endif  // TICTACTOE_H

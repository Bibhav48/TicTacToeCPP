#include "tictactoe_c_api.h"

#include "tictactoe.h"

// C wrapper functions
extern "C" {

TicTacToeGame create_game() {
    return reinterpret_cast<TicTacToeGame>(new TicTacToe());
}

void destroy_game(TicTacToeGame game) {
    if (game) {
        delete reinterpret_cast<TicTacToe*>(game);
    }
}

void reset_game(TicTacToeGame game) {
    if (game) {
        reinterpret_cast<TicTacToe*>(game)->reset();
    }
}

int get_current_player(TicTacToeGame game) {
    if (!game) return 0;

    Player player = reinterpret_cast<TicTacToe*>(game)->getCurrentPlayer();
    switch (player) {
        case Player::X:
            return 1;
        case Player::O:
            return 2;
        default:
            return 0;
    }
}

int check_winner(TicTacToeGame game) {
    if (!game) return 0;

    TicTacToe* ticTacToe = reinterpret_cast<TicTacToe*>(game);
    Player winner = ticTacToe->checkWinner();

    switch (winner) {
        case Player::X:
            return 1;
        case Player::O:
            return 2;
        default:
            return 0;
    }
}

int is_board_full(TicTacToeGame game) {
    if (!game) return 0;
    return reinterpret_cast<TicTacToe*>(game)->isBoardFull() ? 1 : 0;
}

const int* get_board(TicTacToeGame game) {
    if (!game) return nullptr;

    TicTacToe* ticTacToe = reinterpret_cast<TicTacToe*>(game);
    const auto& board = ticTacToe->getBoard();

    // Static array to hold the flattened board
    static int flatBoard[9];

    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            switch (board[i][j]) {
                case Player::X:
                    flatBoard[i * 3 + j] = 1;
                    break;
                case Player::O:
                    flatBoard[i * 3 + j] = 2;
                    break;
                default:
                    flatBoard[i * 3 + j] = 0;
                    break;
            }
        }
    }

    return flatBoard;
}

int make_move(TicTacToeGame game, int row, int col) {
    if (!game) return 0;
    return reinterpret_cast<TicTacToe*>(game)->makeMove(row, col) ? 1 : 0;
}

void make_ai_move(TicTacToeGame game) {
    if (game) {
        reinterpret_cast<TicTacToe*>(game)->makeAiMove();
    }
}
}

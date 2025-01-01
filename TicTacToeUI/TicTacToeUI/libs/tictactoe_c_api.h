#ifndef TICTACTOE_C_API_H
#define TICTACTOE_C_API_H

#ifdef __cplusplus
extern "C" {
#endif

// Opaque pointer to the game object
typedef void* TicTacToeGame;
typedef TicTacToeGame GameHandle;

// Game management functions
TicTacToeGame create_game(void);
void destroy_game(TicTacToeGame game);
void reset_game(TicTacToeGame game);

// Game state functions
int get_current_player(TicTacToeGame game);
int check_winner(TicTacToeGame game);
int is_board_full(TicTacToeGame game);
const int* get_board(TicTacToeGame game);

// Move functions
int make_move(TicTacToeGame game, int row, int col);
void make_ai_move(TicTacToeGame game);

#ifdef __cplusplus
}
#endif

#endif  // TICTACTOE_C_API_H

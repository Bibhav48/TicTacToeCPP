#include "tictactoe.h"

#include <algorithm>
#include <iostream>

TicTacToe::TicTacToe() {
    reset();
}

void TicTacToe::reset() {
    board.assign(3, std::vector<Player>(3, Player::NONE));
    currentPlayer = Player::X;
}

bool TicTacToe::makeMove(int row, int col) {
    if (row >= 0 && row < 3 && col >= 0 && col < 3 && board[row][col] == Player::NONE) {
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == Player::X) ? Player::O : Player::X;
        return true;
    }
    return false;
}

void TicTacToe::makeAiMove() {
    int bestScore = -1000;
    int bestMoveRow = -1;
    int bestMoveCol = -1;

    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if (board[i][j] == Player::NONE) {
                board[i][j] = Player::O;
                int score = minimax(board, false);
                board[i][j] = Player::NONE;
                if (score > bestScore) {
                    bestScore = score;
                    bestMoveRow = i;
                    bestMoveCol = j;
                }
            }
        }
    }

    if (bestMoveRow != -1) {
        makeMove(bestMoveRow, bestMoveCol);
    }
}

Player TicTacToe::getCurrentPlayer() const {
    return currentPlayer;
}

Player TicTacToe::checkWinner() const {
    // Check rows and columns
    for (int i = 0; i < 3; ++i) {
        if (board[i][0] != Player::NONE && board[i][0] == board[i][1] && board[i][1] == board[i][2]) return board[i][0];
        if (board[0][i] != Player::NONE && board[0][i] == board[1][i] && board[1][i] == board[2][i]) return board[0][i];
    }
    // Check diagonals
    if (board[0][0] != Player::NONE && board[0][0] == board[1][1] && board[1][1] == board[2][2]) return board[0][0];
    if (board[0][2] != Player::NONE && board[0][2] == board[1][1] && board[1][1] == board[2][0]) return board[0][2];

    return Player::NONE;
}

const std::vector<std::vector<Player>>& TicTacToe::getBoard() const {
    return board;
}

bool TicTacToe::isBoardFull() const {
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
            if (board[i][j] == Player::NONE) {
                return false;
            }
        }
    }
    return true;
}

int TicTacToe::minimax(std::vector<std::vector<Player>> currentBoard, bool isMaximizing) {
    TicTacToe tempGame;
    tempGame.board = currentBoard;
    Player winner = tempGame.checkWinner();

    if (winner == Player::O) return 10;
    if (winner == Player::X) return -10;
    if (tempGame.isBoardFull()) return 0;

    if (isMaximizing) {
        int bestScore = -1000;
        for (int i = 0; i < 3; ++i) {
            for (int j = 0; j < 3; ++j) {
                if (currentBoard[i][j] == Player::NONE) {
                    currentBoard[i][j] = Player::O;
                    bestScore = std::max(bestScore, minimax(currentBoard, false));
                    currentBoard[i][j] = Player::NONE;
                }
            }
        }
        return bestScore;
    } else {
        int bestScore = 1000;
        for (int i = 0; i < 3; ++i) {
            for (int j = 0; j < 3; ++j) {
                if (currentBoard[i][j] == Player::NONE) {
                    currentBoard[i][j] = Player::X;
                    bestScore = std::min(bestScore, minimax(currentBoard, true));
                    currentBoard[i][j] = Player::NONE;
                }
            }
        }
        return bestScore;
    }
}

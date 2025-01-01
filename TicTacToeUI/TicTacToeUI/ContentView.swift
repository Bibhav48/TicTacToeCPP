import SwiftUI
import TicTacToeEngine

struct ContentView: View {
    @StateObject private var game = TicTacToeViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.95, green: 0.97, blue: 1.0), Color(red: 0.89, green: 0.94, blue: 1.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color(red: 0.35, green: 0.62, blue: 0.98).opacity(0.18))
                .frame(width: 260, height: 260)
                .offset(x: -170, y: -210)
                .blur(radius: 2)

            Circle()
                .fill(Color(red: 0.14, green: 0.35, blue: 0.72).opacity(0.16))
                .frame(width: 220, height: 220)
                .offset(x: 180, y: 230)
                .blur(radius: 1)

            VStack(spacing: 22) {
                Text("Tic Tac Toe")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(game.status)
                    .font(.system(size: 21, weight: .semibold, design: .serif))
                    .foregroundStyle(Color(red: 0.07, green: 0.2, blue: 0.43))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(.white.opacity(0.8))
                    )

                VStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { row in
                        HStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { col in
                                Button(action: {
                                    game.makeMove(row: row, col: col)
                                }) {
                                    Text(game.board[row][col])
                                        .font(.system(size: 56, weight: .heavy, design: .rounded))
                                        .foregroundStyle(symbolColor(for: game.board[row][col]))
                                        .frame(width: 95, height: 95)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .fill(.white.opacity(0.9))
                                        )
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .stroke(Color(red: 0.75, green: 0.83, blue: 0.95), lineWidth: 1.5)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.white.opacity(0.45))
                        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 10)
                )

                Button("New Game") {
                    game.resetGame()
                }
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(Color(red: 0.11, green: 0.38, blue: 0.86))
                        .shadow(color: Color(red: 0.11, green: 0.38, blue: 0.86).opacity(0.45), radius: 10, x: 0, y: 6)
                )
                .buttonStyle(.plain)
            }
            .padding(28)
        }
        .frame(minWidth: 430, minHeight: 560)
        .animation(.easeInOut(duration: 0.2), value: game.board)
    }

    private func symbolColor(for symbol: String) -> Color {
        switch symbol {
        case "X":
            return Color(red: 0.13, green: 0.41, blue: 0.9)
        case "O":
            return Color(red: 0.87, green: 0.31, blue: 0.2)
        default:
            return .clear
        }
    }
}

class TicTacToeViewModel: ObservableObject {
    @Published var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    @Published var status: String = "Your Turn (X)"
    private var game: TicTacToeGame?

    init() {
        self.game = create_game()
        updateBoard()
    }
    
    deinit {
        if let game = self.game {
            destroy_game(game)
        }
    }

    func makeMove(row: Int, col: Int) {
        guard let game = self.game else { return }
        
        if check_winner(game) != 0 || is_board_full(game) != 0 {
            return
        }

        if make_move(game, Int32(row), Int32(col)) != 0 {
            updateBoard()
            updateStatus()

            if check_winner(game) == 0 && is_board_full(game) == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    make_ai_move(game)
                    self.updateBoard()
                    self.updateStatus()
                }
            }
        }
    }

    func resetGame() {
        guard let game = self.game else { return }
        reset_game(game)
        updateBoard()
        updateStatus()
    }

    private func updateBoard() {
        guard let game = self.game else { return }
        let cBoard = get_board(game)
        for i in 0..<3 {
            for j in 0..<3 {
                let player = cBoard![i * 3 + j]
                switch player {
                case 1:
                    self.board[i][j] = "X"
                case 2:
                    self.board[i][j] = "O"
                default:
                    self.board[i][j] = ""
                }
            }
        }
    }
    
    private func updateStatus() {
        guard let game = self.game else { return }
        let winner = check_winner(game)
        if winner == 1 {
            status = "You Win!"
        } else if winner == 2 {
            status = "AI Wins!"
        } else if is_board_full(game) != 0 {
            status = "It's a Tie!"
        } else {
            status = "Your Turn (X)"
        }
    }
}

#Preview {
    ContentView()
}


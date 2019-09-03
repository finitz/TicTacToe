//
//  main.swift
//  TicTacToe
//
//  Created by 17 on 8/25/19.
//  Copyright © 2019 17. All rights reserved.
//



class Game {
    enum Turn: Character {
        case x = "X"
        case o = "O"
        
        var next: Turn {
            switch self {
            case .x: return .o
            case .o: return .x
            }
        }
    }
    
    enum Mode: Int {
        case easy = 1
        case medium
        case pro
        
        var size: Int{
            switch self {
            case .easy: return 3
            case .medium: return 5
            case .pro: return 7
            }
        }
    }
    
    enum GameError: Error {
        case exitGame
    }
    
    struct Board {
        let size: Int
        var grid = [[Character]]()
        
        init(mode: Int) {
            self.size = mode
            //grid= Array(repeating: Array(repeating: " ", count: mode.size), count: mode.size)
        }
        
        subscript(move: Move) -> Character {
            get {
                //index check
                return grid[move.i][move.j]
            }
            set {
                //index check
                grid[move.i][move.j] = newValue
            }
        }
    }

    
    var playerTurn: Turn = .x
    var move = Move()
    //var board: Board
    var board = [[Character]]()
    var isActive = true
    let gameMode: Mode
    var moveCount = 0
    
    init(mode: Mode) {
        //board = Board(mode)
        gameMode = mode
        //
        board = Array(repeating: Array(repeating: " ", count: mode.size), count: mode.size)
        printBoard(board)
    }
    
    struct Move {
        let i: Int
        let j: Int
        
        init() {
            i = 0
            j = 0
        }
        init?(elements: [Int]) {
            guard elements.count == 2 else {
                return nil
            }
            i = elements[0]
            j = elements[1]
        }
    }

    
    
    func printBoard(_ board: [[Character]]) {
        for _ in 0..<gameMode.size{
            print(" ---", terminator: "")
        }
        print("\n", terminator: "")
        for i in 0..<gameMode.size {
            for j in 0..<gameMode.size{
                print("| \(board[i][j])", terminator: " ")
            }
            print("|\n", terminator: "")
            for _ in 0..<gameMode.size {
                print(" ---", terminator: "")
            }
            print("\n", terminator: "")
            
        }
    }
    
    func updateBoard(with move: Move, _ player: Turn) {
        board[move.i][move.j] = player.rawValue
    }
    
    func canMake(_ move: Move) -> Bool {
        guard move.i < gameMode.size, move.j < gameMode.size,
            board[move.i][move.j].isWhitespace else {
                return false
        }
        return true
    }
    
    func makeMove() throws {
        print("Please make a move (\(playerTurn.rawValue)): ", terminator: "")
        guard let input = readLine() else {
            throw GameError.exitGame
        }
        
        let elements = input.split(separator: " ").compactMap { Int($0) }
        guard let move = Move(elements: elements), canMake(move) else {
            print("Invalid move.")
            try makeMove()
            return
        }
        
        self.move = move
        updateBoard(with: move, playerTurn)
        moveCount += 1
        printBoard(board)
        
        checkState()
        playerTurn = playerTurn.next
    }
    
    func checkState() {
        // row
        for j in 0..<board.count {
            if board[move.i][j] != board[move.i][move.j] {
                break
            }
            checkWinState(with: j)
        }
        
        // column
        for i in 0..<board.count {
            if board[i][move.j] != board[move.i][move.j] {
                break
            }
            checkWinState(with: i)
        }
        
        // diagonal1
        if move.i == move.j {
            for k in 0..<board.count {
                if board[k][k] != board[move.i][move.j] {
                    break
                }
                checkWinState(with: k)
            }
        }
        
        // diagonal2
        if move.i + move.j == board.count - 1 {
            for p in 0..<board.count {
                if board[p][board.count - p - 1] != board[move.i][move.j] {
                    break
                }
                checkWinState(with: p)
            }
        }
        
        // draw
        if moveCount == board.count * board.count {
            print("**** DRAW ****")
            isActive = false
        }
    }
    
    func checkWinState(with count: Int) {
        if count == board.count - 1 {
            print("**** \(playerTurn.rawValue) WON ****")
            isActive = false
        }
    }
}

var input: String?
gameLoop: repeat {
    print("Select a mode: ", terminator: "")
    input = readLine()
    
    guard
        let input = input,
        let inputNum = Int(input),
        let mode = Game.Mode(rawValue: inputNum) else {
            continue
    }
    
    let game = Game(mode: mode)
    
    while game.isActive {
        do {
            try game.makeMove()
        } catch Game.GameError.exitGame {
            break gameLoop
        } catch {
            fatalError("Unknown error occurred!")
        }
    }
   

} while input != nil


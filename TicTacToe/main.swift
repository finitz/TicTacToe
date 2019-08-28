//
//  main.swift
//  TicTacToe
//
//  Created by 17 on 8/25/19.
//  Copyright © 2019 17. All rights reserved.
//

enum Turn: String {
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

class Game {
    
    var playerTurn: Turn = .x
    var move = (x: 0, y: 0)
    var board = [[String]]()
    var isActive = true
    let gameMode: Mode
    var moveCount = 0
    
    
    init(mode: Mode) {
        gameMode = mode
        board = Array(repeating: Array(repeating: " ", count: mode.size), count: mode.size)
        printBoard(board)
    }

    func printBoard(_ board: [[String]]) {
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
    
    
    func updateBoard(_ tuple: (Int, Int), _ player: Turn) {
        board[tuple.0][tuple.1] = player.rawValue
    }
    
    func makeMove() {
        print("Please make a move.\n\(playerTurn.rawValue): ", terminator: "")
        
        var m = readLine()!
        var movArr = m.split(separator: " ")
        var invalidMove = movArr.count != 2
        
        while invalidMove {
            print("Please input a valid move.\n\(playerTurn.rawValue): ", terminator: "")
            m = readLine()!
            movArr = m.split(separator: " ")
            invalidMove = movArr.count != 2
        }
        
        invalidMove = Int(movArr[0])! >= gameMode.size || Int(movArr[1])! >= gameMode.size || board[Int(movArr[0])!][Int(movArr[1])!] != " "
        
        while invalidMove {
            print("Please input a valid move.\n\(playerTurn.rawValue): ", terminator: "")
            m = readLine()!
            movArr = m.split(separator: " ")
            invalidMove = Int(movArr[0])! >= gameMode.size || Int(movArr[1])! >= gameMode.size || board[Int(movArr[0])!][Int(movArr[1])!] != " " || movArr.count != 2
        }
        
        
        move.x = Int(movArr[0])!
        move.y = Int(movArr[1])!
        
        updateBoard(move, playerTurn)
        moveCount += 1
        printBoard(board)
        
        
        checkState()
        playerTurn = playerTurn.next
    }
    
    func checkState() {
        
        //row
        for j in 0..<board.count {
            if board[move.x][j] != board[move.x][move.y] {
                break
            }
            if j == board.count - 1 {
                print("**** \(playerTurn.rawValue) WON ****")
                isActive = false
            }
        }
        
        //column
        for i in 0..<board.count {
            if board[i][move.y] != board[move.x][move.y] {
                break
            }
            if i == board.count - 1 {
                print("**** \(playerTurn.rawValue) WON ****")
                isActive = false
            }
        }
        
        //diagonal1
        if move.x == move.y {
            for k in 0..<board.count {
                if board[k][k] != board[move.x][move.y] {
                    break
                }
                if k == board.count - 1 {
                    print("**** \(playerTurn.rawValue) WON ****")
                    isActive = false
                }
            }
        }
        
        //diagonal2
        if move.x + move.y == board.count - 1 {
            for p in 0..<board.count {
                if board[p][board.count - p - 1] != board[move.x][move.y] {
                    break
                }
                if p == board.count - 1 {
                    print("**** \(playerTurn.rawValue) WON ****")
                    isActive = false
                }
            }
        }
        
        //draw
        if moveCount == board.count * board.count {
            print("**** DRAW ****")
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
        let mode = Mode(rawValue: inputNum) else {
            continue
    }
    
    let game = Game(mode: mode)
    
    
    while game.isActive {
        game.makeMove()
    }
   

} while input != nil
















//
//  Board.swift
//  Chess
//
//  Created by Ts SaM on 5/4/2023.
//

import Foundation

class Board {
	private let rowRange: ClosedRange<Int> = 1...8
	private let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
	private var board: [[Piece?]] = Array(repeating: Array(repeating: nil, count: 8), count: 8)
	
	init() {
		// Initialize the board with starting pieces
		for i in 0..<8 {
			board[1][i] = Pawn(row: 2, column: columnRange[i])
			board[6][i] = Pawn(row: 7, column: columnRange[i], isWhite: false)
		}
		
		// Rooks
		board[0][0] = Rook(row: 1, column: "a")
		board[0][7] = Rook(row: 1, column: "h")
		board[7][0] = Rook(row: 8, column: "a", isWhite: false)
		board[7][7] = Rook(row: 8, column: "h", isWhite: false)
		
		// Knights
		board[0][1] = Knight(row: 1, column: "b")
		board[0][6] = Knight(row: 1, column: "g")
		board[7][1] = Knight(row: 8, column: "b", isWhite: false)
		board[7][6] = Knight(row: 8, column: "g", isWhite: false)
		
		// Bishops
		board[0][2] = Bishop(row: 1, column: "c")
		board[0][5] = Bishop(row: 1, column: "f")
		board[7][2] = Bishop(row: 8, column: "c", isWhite: false)
		board[7][5] = Bishop(row: 8, column: "f", isWhite: false)
		
		// Queens
		board[0][3] = Queen(row: 1, column: "d")
		board[7][3] = Queen(row: 8, column: "d", isWhite: false)
		
		// Kings
		board[0][4] = King(row: 1, column: "e")
		board[7][4] = King(row: 8, column: "e", isWhite: false)
	}
	
	func printBoard() {
		for i in (0..<8).reversed() {
			print("\(i+1) ", terminator: "")
			for j in 0..<8 {
				if let piece = board[i][j] {
					print(piece, terminator: "")
				} else {
					print(".", terminator: "")
				}
				print(" ", terminator: "")
			}
			print("")
		}
		print("  a b c d e f g h")
	}
}

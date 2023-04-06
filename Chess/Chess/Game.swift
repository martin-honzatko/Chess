//
//  Game.swift
//  Chess
//
//  Created by Martin Honzatko on 2023-04-04.
//

import Foundation

class Game {
	private static var pieces: [Piece] = []
	private static let rowRange: ClosedRange<Int> = 1...8
	private static let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
//	private var piecesPositions: [(p: String, isWhite: Bool)] = []
//	static func ckeckPositions(positions: [String], isWhite: Bool) -> [String] {
//		var res: [String] = []
//		for pos in positions {
//			if piecesPositions.p {
//				res.append(pos)
//			}
//		}
//
//		return res
//	}
	
	static func play() {
		Game.createDefaultBoard()
		Game.printBoard()
	}
	
	static func printBoard() {
		print()
		for row in rowRange.reversed() {
			for col in columnRange {
				if !Game.printPiece(row: row, column: col) {
					print(".", terminator: " ")
				}
			}
			print(row)
		}
		print("a b c d e f g h")
	}
	
	private static func printPiece(row: Int, column: Character) -> Bool {
		for piece in Game.pieces {
			if piece.row == row && piece.column == column {
				print(piece, terminator: " ")
				return true
			}
		}
		
		return false
	}
	
	private static func createDefaultBoard() {
		//Pawns
		for col in Game.columnRange {
			pieces.append(Pawn(row: 2, column: col))
			pieces.append(Pawn(row: 7, column: col, isWhite: false))
		}
		
		//Kings
		pieces.append(King(row: 1, column: "e"))
		pieces.append(King(row: 8, column: "e", isWhite: false))
		
		//Queens
		pieces.append(Queen(row: 1, column: "d"))
		pieces.append(Queen(row: 8, column: "d", isWhite: false))
		
		//Bishops
		pieces.append(Bishop(row: 1, column: "c"))
		pieces.append(Bishop(row: 1, column: "f"))
		pieces.append(Bishop(row: 8, column: "c", isWhite: false))
		pieces.append(Bishop(row: 8, column: "f", isWhite: false))
		
		//Knights
		pieces.append(Knight(row: 1, column: "b"))
		pieces.append(Knight(row: 1, column: "g"))
		pieces.append(Knight(row: 8, column: "b", isWhite: false))
		pieces.append(Knight(row: 8, column: "g", isWhite: false))
		
		//Rooks
		pieces.append(Rook(row: 1, column: "a"))
		pieces.append(Rook(row: 1, column: "h"))
		pieces.append(Rook(row: 8, column: "a", isWhite: false))
		pieces.append(Rook(row: 8, column: "h", isWhite: false))
	}
}

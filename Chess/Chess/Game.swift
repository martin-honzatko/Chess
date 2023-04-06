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
	
	static func printMoves(isWhite: Bool) {
		print("Possible moves:")
		for piece in Game.pieces {
			if piece.isWhite == isWhite {
				print("\(piece.getPosition()) - {", terminator: "")
				let poss: (correct: Bool, moves: [String]) = piece.getPossibleMoves()
				if poss.correct {
					for i in 0..<(poss.moves.count - 1) {
						print("\(poss.moves[i])", terminator: ", ")
					}
					print("\(poss.moves[poss.moves.count - 1])}")
				}
			}
		}
	}
	
	static func printMoves(_ pos: String) {
		guard pos.count == 2 else {
			return
		}
		for piece in Game.pieces {
			if piece.getPosition() == pos {
				print("Possible moves of \(piece.getPosition()): {", terminator: "")
				let poss: (correct: Bool, moves: [String]) = piece.getPossibleMoves()
				if poss.correct {
					for i in 0..<(poss.moves.count - 1) {
						print("\(poss.moves[i])", terminator: ", ")
					}
					print("\(poss.moves[poss.moves.count - 1])}")
				}
			}
		}
	}
	
	static func move(isWhite: Bool, row: Int, column: Character, newRow: Int, newColumn: Character) {
		for piece in Game.pieces {
			if piece.getPosition() == "\(column)\(row)" && piece.isWhite == isWhite {
				if piece.move(row: newRow, column: newColumn) {
					print("Successfuly moved!")
				} else {
					if piece is King {
						if Game.check(isWhite: isWhite) {
							print("Check on \((isWhite) ? "Black" : "White")!")
						}
					}
					print("Illegal move, please try again")
				}
			}
		}
	}
	
	static func check(isWhite: Bool) -> Bool {
		var king = Piece(row: 1, column: "a")
		for piece in Game.pieces {
			if piece is King && piece.isWhite != isWhite {
				king = piece
			}
		}
		
		for piece in Game.pieces {
			let poss: (correct: Bool, moves: [String]) = piece.getPossibleMoves()
			if poss.correct && piece != king {
				if poss.moves.contains(king.getPosition()) {
					return true
				}
			}
		}
		
		return false
	}
	
	static func checkPossCheck(_ moves: [String]) -> [String] {
		var moves = moves
		for piece in Game.pieces {
			let poss: (correct: Bool, moves: [String]) = piece.getPossibleMoves()
			if poss.correct {
				for move in moves {
					if poss.moves.contains(move) {
						if let i = moves.firstIndex(of: move) {
							moves.remove(at: i)
						}
					}
				}
			}
		}
		
		return moves
	}
	
	static func checkMoves(_ moves: [String]) -> [String] {
		var moves = moves
		for piece in Game.pieces {
			for move in moves {
				if piece.getPosition() == move {
					if let i = moves.firstIndex(of: move) {
						moves.remove(at: i)
					}
				}
			}
		}
		
		return moves
	}
	
	static func checkMoves(_ moves: [String], _ isWhite: Bool) -> [String] {
		var moves = moves
		for piece in Game.pieces {
			for move in moves {
				if piece.getPosition() == move && piece.isWhite == isWhite {
					if let i = moves.firstIndex(of: move) {
						moves.remove(at: i)
					}
				}
			}
		}
		
		return moves
	}
	
	static func checkMoves(_ move: String) -> (Bool, Bool) {
		var isPiece: Bool = false
		var wOrB: Bool = false
		for piece in Game.pieces {
			if piece.getPosition() == move {
				wOrB = piece.isWhite
				isPiece = true
			}
		}
		
		return (isPiece, wOrB)
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
	
	static func createDefaultBoard() {
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

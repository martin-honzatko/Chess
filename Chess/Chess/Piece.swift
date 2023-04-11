//
//  Piece.swift
//  Chess
//
//  Created by Martin Honzatko on 2023-04-02.
//

import Foundation

// TODO:
// Implement move functionality + figure how to implement Pawn taking because it's 1 forward vertically
// Add and implement casting functionality
// Add and implement en passant functionality

class Piece {
	private var _value: Int = 0
	private var _row: Int = 0
	private var _column: Character = Character("a")
	private let rowRange: ClosedRange<Int> = 1...8
	private let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
	
	var value: Int {
		get {
			return _value
		}
		
		set {
			_value = newValue
		}
	}
	var row: Int {
		get {
			return _row
		}
		
		set {
			if rowRange.contains(newValue) {
				_row = newValue
			} else {
				print("ERROR: Incorrect horizontal coordinate!")
			}
		}
	}
	var column: Character {
		get {
			return _column
		}
		set {
			if columnRange.contains(newValue) {
				_column = newValue
			} else {
				print("ERROR: Incorrect vertical coordinate!")
			}
		}
	}
	
	var isWhite: Bool = true
	var moveCounter = 0
	
	
	init(row: Int, column: Character, isWhite: Bool = true) {
		self.row = row
		self.column = column
		self.isWhite = isWhite
	}
	
	/// Method to get Piece position
	/// - Returns: position as String - columnRow -> exp. "a1"
	func getPosition() -> String {
		return "\(self.column)\(self.row)"
	}
	
	func getPossibleMoves() -> (Bool, [String]) { return (true, [])}
	
	/// Method to move piece = Set new position
	/// - Parameters:
	///   - row: Int value representing row in range 1-8
	///   - column: Strring value representing column in range a-h
	func move(row: Int, column: Character) -> Bool {
		let possible: (correct: Bool, moves: [String]) = self.getPossibleMoves()
		if possible.correct {
			let move: String = "\(column)\(row)"
			if possible.moves.contains(move) {
				self.row = row
				self.column = column
				self.moveCounter += 1
				return true
			}
		}
		
		return false
	}
}

extension Piece: CustomStringConvertible {
	@objc var description: String {
		return "Piece()"
	}
}

extension Piece: Equatable {
	static func ==(lhs: Piece, rhs: Piece) -> Bool {
		return lhs.value == rhs.value && lhs.isWhite == rhs.isWhite
	}
}

class Pawn: Piece {
	private(set) var promoted: Bool = false
	private(set) var newPiece: Piece?
	
	init(row: Int, column: Character, isWhite: Bool = true, promoted: Bool = false, newPiece: Piece? = nil) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 1
		self.promoted = promoted
		self.newPiece = Pawn.checkPromote(newPiece, row, column, isWhite)
	}
	
	override func getPossibleMoves() -> (Bool, [String]) {
		let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var moves: [String] = []
		var attacks: [String] = []
		var res: [String] = []
		
		if self.isWhite {
			moves.append("\(self.column)\(self.row + 1)")
			if self.moveCounter == 0 {
				moves.append("\(self.column)\(self.row + 2)")
			}
			res = Game.checkMoves(moves)
			moves = []
			if let i = columnRange.firstIndex(of: self.column) {
				if (i - 1) >= 0 {
					attacks.append("\(columnRange[i - 1])\(self.row + 1)")
				}
				if (i + 1) <= 7 {
					attacks.append("\(columnRange[i + 1])\(self.row + 1)")
				}
			}
			res += Game.checkMoves(moves, self.isWhite) + Game.checkAttacks(attacks, self.isWhite)
		} else {
			moves.append("\(self.column)\(self.row - 1)")
			if self.moveCounter == 0 {
				moves.append("\(self.column)\(self.row - 2)")
			}
			res = Game.checkMoves(moves)
			moves = []
			if let i = columnRange.firstIndex(of: self.column) {
				if (i - 1) >= 0 {
					attacks.append("\(columnRange[i - 1])\(self.row - 1)")
				}
				if (i + 1) <= 7 {
					attacks.append("\(columnRange[i + 1])\(self.row - 1)")
				}
			}
			res += Game.checkMoves(moves, self.isWhite) + Game.checkAttacks(attacks, self.isWhite)
		}
		
		return ((res.isEmpty) ? false : true, res)
	}
	
	override var description: String {
		return "\(self.isWhite ? "♟" : "♙")"
	}
}

extension Pawn {
	/// Method to check promotion through initializer
	/// - Parameters:
	///   - newPiece: Piece we're promoting to
	///   - row: row value
	///   - column: column value
	///   - isWhite: isWhite value
	/// - Returns: checked Piece
	static func checkPromote(_ newPiece: Piece?, _ row: Int, _ column: Character, _ isWhite: Bool) -> Piece? {
		guard newPiece != nil else {
			return newPiece
		}
		
		guard newPiece is Knight || newPiece is Bishop || newPiece is Rook || newPiece is Queen  else {
			print("New piece can't be King or Pawn, so it's Queen!")
			return Queen(row: row, column: column, isWhite: isWhite)
		}
		
		if let newPiece = newPiece {
			newPiece.row = row
			newPiece.column = column
			newPiece.isWhite = isWhite
			return newPiece
		}
		
		return newPiece
	}
	
	/// Promote method
	/// - Parameter newPiece: Piece we want to promote - can have any position because we replace it by current position within method
	func promote(_ newPiece: Piece) {
		guard newPiece is Knight || newPiece is Bishop || newPiece is Rook || newPiece is Queen  else {
			print("New piece can't be King or Pawn!")
			return
		}
		
		self.promoted = true
		newPiece.row = self.row
		newPiece.column = self.column
		newPiece.isWhite = self.isWhite
		newPiece.moveCounter = self.moveCounter
		self.newPiece = newPiece
	}
}

extension Pawn {
	static func ==(lhs: Pawn, rhs: Pawn) -> Bool {
		return lhs.promoted == true && rhs.promoted == true && lhs.newPiece == rhs.newPiece
	}
}

class Knight: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 2
	}
	
	override func getPossibleMoves() -> (Bool, [String]) {
		//"Like an L"
		let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var moves: [String] = []
		var res: [String] = []
		if let i = columnRange.firstIndex(of: self.column) {
			if (i - 2) >= 0 {
				if self.row > 1 { moves.append("\(columnRange[i - 2])\(self.row - 1)") }
				if self.row < 8 { moves.append("\(columnRange[i - 2])\(self.row + 1)") }
			}
			if (i + 2) <= 7 {
				if self.row > 1 { moves.append("\(columnRange[i + 2])\(self.row - 1)") }
				if self.row < 8 { moves.append("\(columnRange[i + 2])\(self.row + 1)") }
			}
			let row = self.row
			if (row - 2) >= 1 {
				if (i - 1) >= 0 {
					moves.append("\(columnRange[i - 1])\(self.row - 2)")
				}
				if (i + 1) <= 7 {
					moves.append("\(columnRange[i + 1])\(self.row - 2)")
				}
			}
			if (row + 2) <= 8 {
				if (i - 1) >= 0 {
					moves.append("\(columnRange[i - 1])\(self.row + 2)")
				}
				if (i + 1) <= 7 {
					moves.append("\(columnRange[i + 1])\(self.row + 2)")
				}
			}
		}
		res = Game.checkMoves(moves, self.isWhite)
		
		return ((res.isEmpty) ? false : true, res)
	}
	
	override var description: String {
		return "\(self.isWhite ? "♞" : "♘")"
	}
}

class Bishop: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 3
	}
	
	override func getPossibleMoves() -> (Bool, [String]) {
		let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var res: [String] = []
		if let ind = columnRange.firstIndex(of: self.column) {
			var row = self.row
			var i = ind
			while (i < 7) && (row < 8) {
				i += 1
				row += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			i = ind
			while (i > 0) && (row < 8) {
				i -= 1
				row += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			i = ind
			while (i < 7) && (row > 1) {
				i += 1
				row -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			i = ind
			while (i > 0) && (row > 1) {
				i -= 1
				row -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
		}
		
		return ((res.isEmpty) ? false : true, res)
	}
	
	override var description: String {
		return "\(self.isWhite ? "♝" : "♗")"
	}
}

class Rook: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 5
	}
	
	override func getPossibleMoves() -> (Bool, [String]) {
		let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var res: [String] = []
		if let ind = columnRange.firstIndex(of: self.column) {
			var row = self.row
			var i = ind
			while i < 7 {
				i += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			i = ind
			while i > 0 {
				i -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			i = ind
			while row < 8 {
				row += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			while row > 1 {
				row -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
		}
		return ((res.isEmpty) ? false : true, res)
	}
	
	override var description: String {
		return "\(self.isWhite ? "♜" : "♖")"
	}
}

class Queen: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 9
	}
	
	override func getPossibleMoves() -> (Bool, [String]) {
		let res: [String] = self.getPossibleMovesB() + self.getPossibleMovesR()
		
		return ((res.isEmpty) ? false : true, res)
	}
	
	private func getPossibleMovesB() -> [String] {
		let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var res: [String] = []
		if let ind = columnRange.firstIndex(of: self.column) {
			var row = self.row
			var i = ind
			while (i < 7) && (row < 8) {
				i += 1
				row += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			i = ind
			while (i > 0) && (row < 8) {
				i -= 1
				row += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			i = ind
			while (i < 7) && (row > 1) {
				i += 1
				row -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			i = ind
			while (i > 0) && (row > 1) {
				i -= 1
				row -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
		}
		
		return res
	}
	
	private func getPossibleMovesR() -> [String] {
		let columnRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var res: [String] = []
		if let ind = columnRange.firstIndex(of: self.column) {
			var row = self.row
			var i = ind
			while i < 7 {
				i += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			i = ind
			while i > 0 {
				i -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			i = ind
			while row < 8 {
				row += 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
			row = self.row
			while row > 1 {
				row -= 1
				let move: String = "\(columnRange[i])\(row)"
				let moveCheck: (isPiece: Bool, isWhite: Bool) = Game.checkMoves(move)
				if moveCheck.isPiece {
					break
				} else {
					res.append(move)
				}
			}
		}
		return res
	}
	
	override var description: String {
		return "\(self.isWhite ? "♛" : "♕")"
	}
}

class King: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 1000
	}
	
	override func getPossibleMoves() -> (Bool, [String]) {
		//"One square"
		let colRange: [Character] = ["a", "b", "c", "d", "e", "f", "g", "h"]
		var moves: [String] = []
		var res: [String] = []
		if let i = colRange.firstIndex(of: self.column) {
			let row = self.row
			if i > 0 {
				moves.append("\(colRange[i - 1])\(row)")
				if row > 1 { moves.append("\(colRange[i - 1])\(row - 1)") }
				if row < 8 { moves.append("\(colRange[i - 1])\(row + 1)") }
			}
			
			if i < 7 {
				moves.append("\(colRange[i + 1])\(row)")
				if row > 1 { moves.append("\(colRange[i + 1])\(row - 1)") }
				if row < 8 { moves.append("\(colRange[i + 1])\(row + 1)") }
			}
			
			if row > 1 { moves.append("\(colRange[i])\(row - 1)") }
			if row < 8 { moves.append("\(colRange[i])\(row + 1)") }
		}
		let temp: [String] = Game.checkMoves(moves)
		//res = Game.checkPossCheck(temp)
		res = temp
		
		return ((res.isEmpty) ? false : true, res)
	}
	
	override var description: String {
		return "\(self.isWhite ? "♚" : "♔")"
	}
}



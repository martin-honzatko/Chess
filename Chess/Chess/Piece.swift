//
//  Piece.swift
//  Chess
//
//  Created by Martin Honzatko on 2023-04-02.
//

import Foundation

// FOR SAM: Pawn can move forward by 2 from default position otherwise only by 1 - it's going to be implemented in move method -> only for info

// TODO:
// Implement move functionality + figure how to implement Pawn taking because it's 1 forward vertically
// Add and implement casting functionality
// Add and implement casting functionality

class Piece {
	private var _value: Int = 0
	private var _row: Int = 0
	private var _column: Character = Character("")
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
	
	init(row: Int, column: Character, isWhite: Bool = true) {
		self.row = row
		self.column = column
		self.isWhite = isWhite
	}
	
	/// Method to get Piece position
	/// - Returns: position as String - columnRow -> exp. "a1"
	func getPosition() -> String {return ""}
	
	/// Method to move piece = Set new position
	/// - Parameters:
	///   - row: Int value representing row in range 1-8
	///   - column: Strring value representing column in range a-h
	func move(row: Int, column: Character) {}
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
	private var newPiece: Piece?
	
	init(row: Int, column: Character, isWhite: Bool = true, promoted: Bool = false, newPiece: Piece? = nil) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 1
		self.promoted = promoted
		self.newPiece = Pawn.checkPromote(newPiece, row, column, isWhite)
	}
	
	override func getPosition() -> String {
		return "\(column)\(row)"
	}
	
	override func move(row: Int, column: Character) {
		print("Forward by 1 or 2")
	}
	
	override var description: String {
		return "Pawn(position: \(self.getPosition()), value: \(self.value), \(self.isWhite ? "white" : "black"))"
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
	
	override func getPosition() -> String {
		return "\(column)\(row)"
	}
	
	override func move(row: Int, column: Character) {
		print("Like an L")
	}
	
	override var description: String {
		return "Knight(position: \(self.getPosition()), value: \(self.value), \(self.isWhite ? "white" : "black"))"
	}
}

class Bishop: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 3
	}
	
	override func getPosition() -> String {
		return "\(column)\(row)"
	}
	
	override func move(row: Int, column: Character) {
		print("Diagonally")
	}
	
	override var description: String {
		return "Bishop(position: \(self.getPosition()), value: \(self.value), \(self.isWhite ? "white" : "black"))"
	}
}

class Rook: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 5
	}
	
	override func getPosition() -> String {
		return "\(column)\(row)"
	}
	
	override func move(row: Int, column: Character) {
		print("Horizontally or vertically")
	}
	
	override var description: String {
		return "Rook(position: \(self.getPosition()), value: \(self.value), \(self.isWhite ? "white" : "black"))"
	}
}

class Queen: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 9
	}
	
	override func getPosition() -> String {
		return "\(column)\(row)"
	}
	
	override func move(row: Int, column: Character) {
		print("Like bishop and rook")
	}
	
	override var description: String {
		return "Queen(position: \(self.getPosition()), value: \(self.value), \(self.isWhite ? "white" : "black"))"
	}
}

class King: Piece {
	override init(row: Int, column: Character, isWhite: Bool = true) {
		super.init(row: row, column: column, isWhite: isWhite)
		self.value = 1000
	}
	
	override func getPosition() -> String {
		return "\(column)\(row)"
	}
	
	override func move(row: Int, column: Character) {
		print("One square")
	}
	
	override var description: String {
		return "King(position: \(self.getPosition()), value: \(self.value), \(self.isWhite ? "white" : "black"))"
	}
}


//
//  main.swift
//  Chess
//
//  Created by Martin Honzatko on 2023-04-02.
//

import Foundation

play()


func play() {
	Game.createDefaultBoard()
	var run: Bool = true
	var isWhite: Bool = true
	var check: Bool = false
	var checkCountW: Int = 0
	var checkCountB: Int = 0
	var checkRound: Int = 0
	var checkMate: Bool = false
	print("Welcome to chess!")
	
	while run {
		Game.printBoard()
		check = Game.check(isWhite: isWhite) //ERROR! - Thread 1: EXC_BAD_ACCESS (code=2, address=0x16f603b00) - Pawn.getPossibleMoves() constant columnRange
		if check {
			if checkRound >= 2 { checkMate = true }
		} else { checkRound = 0 }
		print("[type 'help' for help] \((isWhite) ? "White:" : "Black:")", terminator: " ")
		let usrInput: String = readLine() ?? ""
		if usrInput.lowercased() == "help" {
			help()
		} else if usrInput.lowercased() == "board" {
			Game.printBoard()
		} else if usrInput.lowercased() == "resign" {
			print("\((isWhite) ? "Black" : "White") has won!")
			run = false
		} else if usrInput.lowercased() == "moves" {
			print("ERROR! - Thread 1: EXC_BAD_ACCESS (code=2, address=0x16f603b00) - For King's - Wasn't able to solve!")
			Game.printMoves(isWhite: isWhite)
		} else {
			if usrInput.count == 2 {
				Game.printMoves(usrInput)
			} else if usrInput.count == 4 {
				if !checkMate {
					let input = Array(usrInput)
					Game.move(isWhite: isWhite, row: Int(String(input[1])) ?? 0, column: input[0], newRow: Int(String(input[3])) ?? 0, newColumn: input[2])
					check = Game.check(isWhite: isWhite)
					if check {
						print("\((isWhite) ? "White:" : "Black:") calls check on \((isWhite) ? "Black" : "White")")
						if isWhite { checkCountW += 1 } else { checkCountB += 1 }
						checkRound += 1
					} else {
						if isWhite { checkCountW = 0 } else { checkCountB = 0 }
						if checkRound >= 1 { checkRound += 1 }
					}
				}
			} else {
				print("Illegal command, please try again")
			}
		}
		
		if checkCountW == 3 || checkCountB == 3 { checkMate = true }
		
		if checkMate { print("Check Mate! \((isWhite) ? "White" : "Black") has won!"); run = false }
		
		if isWhite { isWhite = false } else { isWhite = true }
	}
}

private func help() {
	print("* type 'help' for help")
	print("* type 'board' to see the board again")
	print("* type 'resign' to resign")
	print("* type 'moves' to list all possible moves")
	print("* type a square (e.g. b1, e2) to list possible moves for that square")
	print("* type UCI (e.g. b1c3, e7e8q) to make a move")
}

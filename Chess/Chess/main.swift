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
	print("Welcome to chess!")
	
	while run {
		Game.printBoard()
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
			Game.printMoves(isWhite: isWhite)
		} else {
			if usrInput.count == 2 {
				Game.printMoves(usrInput)
			} else if usrInput.count == 4 {
				let input = Array(usrInput)
				Game.move(isWhite: isWhite, row: Int(String(input[1])) ?? 0, column: input[0], newRow: Int(String(input[3])) ?? 0, newColumn: input[2])
			} else {
				print("Illegal command, please try again")
			}
		}
		
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

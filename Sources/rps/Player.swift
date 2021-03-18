//
//  Player.swift
//  
//
//  Created by Tim Savage on 3/16/21.
//

class Player {

	let name: String
	let weights: [Int]
	var wins = 0
	var totalThrows = 0
	var throwCounts = [Hand.rock: 0, Hand.paper: 0, Hand.scissors: 0]
	var currentHand = Hand.rock

	init(name: String) {
		self.name = name
		self.weights = [1, 1, 1]
	}

	init(name: String, weights: [Int]) {
		self.name = name
		self.weights = weights
	}

	func countWin() {
		self.wins += 1
	}

	func countThrow(_ hand: Hand) {
		self.throwCounts[hand]! += 1
		self.totalThrows += 1
	}

}

//
//  ScoreTable.swift
//  
//
//  Created by Tim Savage on 3/17/21.
//

class ScoreTable {
	
	static let SCORE_TABLE = [
		Hand.rock: [
			Hand.rock: Result.draw,
			Hand.paper: Result.loss,
			Hand.scissors: Result.win
		],
		Hand.paper: [
			Hand.rock: Result.win,
			Hand.paper: Result.draw,
			Hand.scissors: Result.loss
		],
		Hand.scissors: [
			Hand.rock: Result.loss,
			Hand.paper: Result.win,
			Hand.scissors: Result.draw
		]
	]
	
	
	static func getScore(playerA: Player, playerB: Player) -> Result {
		return SCORE_TABLE[playerA.currentHand]?[playerB.currentHand] ?? Result.draw
	}
	
	
}

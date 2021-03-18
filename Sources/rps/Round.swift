//
//  Round.swift
//  
//
//  Created by Tim Savage on 3/17/21.
//

import Foundation

class Round {
	
	let maxThrows: Int
	let verbose: Bool

	init(maxThrows: Int, verbose: Bool) {
		self.maxThrows = maxThrows
		self.verbose = verbose
	}


	func play(players: [Player]) -> (Player?, Int) {

		var remainingPlayers = players
		var throwCount = 0
		
		while throwCount < maxThrows {

			// if only one player remains, return as winner
			if remainingPlayers.count <= 1 {
				return (players.first!, throwCount)
			}

			throwCount += 1

			printThrowHeader(throwCount)

			// throw hand for each player
			for player in remainingPlayers {
				player.currentHand = Hand.getRandom(weights: player.weights)
				player.countThrow(player.currentHand)
				printPlayerThrow(player)
			}

			// iterate over players and compute scores against opponents
			for thisPlayer in remainingPlayers {

				var scores = [Result]()

				for otherPlayer in remainingPlayers where thisPlayer.name != otherPlayer.name {

					// get score vs opponent from score table
					scores.append(ScoreTable.getScore(playerA: thisPlayer, playerB: otherPlayer))
				}

				// if all scores are losses, eliminate this player
				if scores.max() == Result.loss {
					remainingPlayers = remainingPlayers.filter { $0.name != thisPlayer.name }
					if verbose {
						print("\t" + thisPlayer.name, "has been eliminated.")
					}

					// if only one player remaining after an elimination, return remaining player
					if remainingPlayers.count == 1 {
						return (remainingPlayers.first!, throwCount)
					}
				}
				// if all scores are wins against more than one opponent, return this player
				else if remainingPlayers.count > 2 && scores.min() == Result.win {
					return (thisPlayer, throwCount)
				}
			}
		}

		// return draw result
		return (Player?.none, throwCount)
	}


	func printHeader(_ n: Int) {
		if verbose {
			let lineLength = "Round \(n)".count
			print("Round \(n)")
			print(String(repeating: "-", count: lineLength))
		}
	}


	func printFooter() {
		if verbose {
			print()
		}
	}


	func printThrowHeader(_ n: Int) {
		if verbose {
			print("Throw \(n):")
		}
	}


	func printPlayerThrow(_ player: Player) {
		if verbose {
			print("\t\(player.name) throws \(player.currentHand)")
		}
	}
}

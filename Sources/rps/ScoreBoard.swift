//
//  ScoreBoard.swift
//  
//
//  Created by Tim Savage on 3/17/21.
//

import Foundation

class ScoreBoard {

	var verbose: Bool

	// aggregate statistics
	var draws = 0
	var mostThrows = 0
	var cumulativeThrows = 0


	init(verbose: Bool = false) {
		self.verbose = verbose
	}


	func scoreRound(winner: Player?, throwCount: Int) {

		cumulativeThrows += throwCount
		mostThrows = max(throwCount, mostThrows)

		if winner == nil {
			draws += 1
			if verbose {
				print("The round ended in a draw after \(throwCount) throws.")
			}
		}
		else {
			winner!.countWin()
			if verbose {
				print("\(winner!.name) wins after \(throwCount) throws.")
			}
		}
	}


	func printResultHeader() {
		if verbose {
			print("+-------------------+")
			print("| --== Results ==-- |")
			print("+-------------------+")
		}
		else {
			print()
		}
	}


	func printResult(_ players: [Player],_ rounds: Int) {

		printResultHeader()

		let percentFormatter = NumberFormatter()
		percentFormatter.numberStyle = .percent
		percentFormatter.multiplier = 100
		percentFormatter.minimumFractionDigits = 2
		percentFormatter.maximumFractionDigits = 2

		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.minimumFractionDigits = 0
		numberFormatter.maximumFractionDigits = 4


		// calculate max character width of formatted throw counts values for all players
		var maxCountWidth: Int = 0
		var maxPercentWidth: Int = 0
		for player in players {
			for hand in Hand.allCases {
				maxCountWidth = max(maxCountWidth, numberFormatter
										.string(from: NSNumber(value: player.throwCounts[hand] ?? 0))?.count ?? 0)
				let throwCountPercentage: Float = Float(player.throwCounts[hand] ?? 0) / Float(player.totalThrows)
				maxPercentWidth = max(maxPercentWidth, percentFormatter
										.string(from: NSNumber(value: throwCountPercentage))?.count ?? 0)
			}
		}

		for player in players {
			let winPercentage: Float = Float(player.wins) / Float(rounds)
			print("\(player.name) won",
				  numberFormatter.string(from: NSNumber(value: player.wins))!, "times",
				  "(" + percentFormatter.string(from: NSNumber(value: winPercentage))! + ")",
				  "in", numberFormatter.string(from: NSNumber(value: player.totalThrows))!, "throws.")

			for hand in Hand.allCases {
				let throwCountPercentage: Float = Float(player.throwCounts[hand] ?? 0) / Float(player.totalThrows)
				print("\t\(hand):".padding(toLength: 10, withPad: " ", startingAt: 0),
					  numberFormatter.string(from: NSNumber(value: player.throwCounts[hand] ?? 0))!
						.leftPadding(toLength: maxCountWidth, withPad: " "),
					  ("(" + percentFormatter.string(from: NSNumber(value: throwCountPercentage))! + ")")
						.leftPadding(toLength: maxPercentWidth+2, withPad: " "))
			}
			print()
		}

		let throwsPerRound: Float = Float(cumulativeThrows) / Float(rounds)
		print("Average throws per round:", numberFormatter.string(from: NSNumber(value: throwsPerRound))!)
		print("Maximum throws in a round:", numberFormatter.string(from: NSNumber(value: mostThrows))!)

		if draws > 0 {
			let drawPercentage: Float = Float(draws) / Float(rounds)
			print()
			print(numberFormatter.string(from: NSNumber(value: draws))!, "rounds out of",
				  numberFormatter.string(from: NSNumber(value: rounds))!,
				  "(" + percentFormatter.string(from: NSNumber(value: drawPercentage))! + ")",
				  "ended in a draw after",
				  numberFormatter.string(from: NSNumber(value: mostThrows))!, "throws.")
		}
	}

}

extension String {
	func leftPadding(toLength: Int, withPad character: Character) -> String {
		let stringLength = self.count
		if stringLength < toLength {
			return String(repeatElement(character, count: toLength - stringLength)) + self
		} else {
			return String(self.suffix(toLength))
		}
	}
}

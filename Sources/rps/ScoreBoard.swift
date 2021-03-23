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

		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .decimal
		numberFormatter.minimumFractionDigits = 0
		numberFormatter.maximumFractionDigits = 4

		let percentFormatter = NumberFormatter()
		percentFormatter.numberStyle = .percent
		percentFormatter.multiplier = 100
		percentFormatter.minimumFractionDigits = 2
		percentFormatter.maximumFractionDigits = 2


		// calculate max character width of formatted throw count values for all players
		var widthCol1 = 0
		var widthCol2 = 0
		var widthCol3 = 0
		for player in players {
			for hand in Hand.allCases {
				widthCol1 = max(widthCol1, String(describing: hand).count)
				widthCol2 = max(widthCol2, numberFormatter.string(from: NSNumber(value: player.throwCounts[hand] ?? 0))?.count ?? 0)
				widthCol3 = max(widthCol3, percentFormatter.string(from: NSNumber(value: player.getThrowRatio(hand)))?.count ?? 0)
			}
		}

		for player in players {
			print("\(player.name) won",
				  numberFormatter.string(from: NSNumber(value: player.wins))!, "times",
				  "(" + percentFormatter.string(from: NSNumber(value: player.getWinRatio(rounds)))! + ")",
				  "in", numberFormatter.string(from: NSNumber(value: player.totalThrows))!, "throws.")

			for hand in Hand.allCases {
				print("\t\(hand):".padding(toLength: widthCol1 + 2, withPad: " ", startingAt: 0),
					  numberFormatter.string(from: NSNumber(value: player.throwCounts[hand] ?? 0))!
						.leftPadding(toLength: widthCol2, withPad: " "),
					  ("(" + percentFormatter.string(from: NSNumber(value: player.getThrowRatio(hand)))! + ")")
						.leftPadding(toLength: widthCol3 + 2, withPad: " "))
			}
			print()
		}

		let throwsPerRound = Float(cumulativeThrows) / Float(rounds)
		print("Average throws per round:", numberFormatter.string(from: NSNumber(value: throwsPerRound))!)
		print("Maximum throws in a round:", numberFormatter.string(from: NSNumber(value: mostThrows))!)

		if draws > 0 {
			print()
			print(numberFormatter.string(from: NSNumber(value: draws))!, "rounds out of",
				  numberFormatter.string(from: NSNumber(value: rounds))!,
				  "(" + percentFormatter.string(from: NSNumber(value: getDrawRatio(rounds)))! + ")",
				  "ended in a draw after",
				  numberFormatter.string(from: NSNumber(value: mostThrows))!, "throws.")
		}
	}


	func getDrawRatio(_ rounds: Int) -> Float {
		return Float(draws) / Float(rounds)
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

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


	func scoreRound(_ winner: Player?, _ throwCount: Int) {

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


		// calculate max character width of formatted throw_counts values for all players
		//max_width = max(len(str("{:,}".format(max(player.throw_counts.values())))) for player in players)

		for player in players {
			let winPercentage: Float = Float(player.wins) / Float(rounds)
			print("\(player.name) won",
				  numberFormatter.string(from: NSNumber(value: player.wins))!, "times",
				  "(" + percentFormatter.string(from: NSNumber(value: winPercentage))! + ")",
				  "in", numberFormatter.string(from: NSNumber(value: player.totalThrows))!, "throws.")

			for hand in Hand.allCases {
				let throwCountPercentage: Float = Float(player.throwCounts[hand] ?? 0) / Float(player.totalThrows)
				print("\t\(hand):", numberFormatter.string(from: NSNumber(value: player.throwCounts[hand] ?? 0))!,
					  "(" + percentFormatter.string(from: NSNumber(value: throwCountPercentage))! + ")")
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


	func printRoundHeader(_ n: Int) {
		if verbose {
			let lineLength = "Round \(n)".count
			print("Round \(n)")
			print(String(repeating: "-", count: lineLength))
		}
	}


	func printRoundFooter() {
		if verbose {
			print()
		}
	}


}

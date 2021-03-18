import Foundation
import ArgumentParser


struct rps: ParsableCommand {

	static var configuration = CommandConfiguration(
		commandName: "rps",
		abstract: "Simulate a game of rock, paper, scissors.",
		version: "rps 1.0.0\nCopyright (C) 2021 Tim Savage"
	)

	@Flag(name: .shortAndLong, help: "display results for each throw")
	var verbose: Bool = false

	@Option(name: .shortAndLong, help: "number of throws until round is called in a draw")
	var maxThrows: Int = 10

	func run() throws {
		
		let scoreboard = ScoreBoard(verbose: verbose)
		
		print("Enter number of rounds to play: ", terminator: "")
		let rounds = Int(readLine(strippingNewline: true)!)!

		// declare list of players
		let players = [
			Player(name: "Player 1"),
			Player(name: "Player 2"),
			Player(name: "Player 3", weights: [50, 25, 25])
		]

		var count = 0
		while count < rounds {
			count += 1
			let round = Round(maxThrows: maxThrows, verbose: verbose)
			round.printHeader(count)
			let (winner, throwCount) = round.play(players: players)
			scoreboard.scoreRound(winner: winner, throwCount: throwCount)
			round.printFooter()
		}
		
		// print results
		scoreboard.printResult(players, count)
	}
}


rps.main()

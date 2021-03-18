//
//  Hand.swift
//  
//
//  Created by Tim Savage on 3/16/21.
//

enum Hand: CaseIterable {
	case rock
	case paper
	case scissors
	
	static func getRandom(weights: [Int]) -> Hand {
		
		let r = Int.random(in: 1...weights.sum())
		if r <= weights[0] {
			return .rock
		}
		else if r <= weights[0] + weights[1] {
			return .paper
		}
		return .scissors
	}
}

extension Sequence where Element: AdditiveArithmetic {
	func sum() -> Element { reduce(.zero, +) }
}

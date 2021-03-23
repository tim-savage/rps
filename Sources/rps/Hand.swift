//
//  Hand.swift
//  
//
//  Created by Tim Savage on 3/16/21.
//

enum Hand: Int, CaseIterable {
	case rock
	case paper
	case scissors
	
	static func getRandom(weights: [Int]) -> Hand {

		// if array contains at least one element, compute weights
		if (weights.count > 0) {

			var mutableWeights = weights
			
			// populate array with zeros to fill to length of this enum
			while (mutableWeights.count < self.allCases.count) {
				mutableWeights.append(0)
			}

			// if array is not all zeros, choose weighted element
			if !mutableWeights.elementsEqual(repeatElement(0, count: self.allCases.count)) {
				let r = Int.random(in: 1...mutableWeights.sum())
				for element in self.allCases {
					if r <= mutableWeights[0...element.rawValue].sum() {
						return element
					}
				}
			}
		}

		// fallback returns unweighted random element
		return self.allCases.randomElement()!
	}
}

extension Sequence where Element: AdditiveArithmetic {
	func sum() -> Element { reduce(.zero, +) }
}

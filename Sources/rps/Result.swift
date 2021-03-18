//
//  Result.swift
//  
//
//  Created by Tim Savage on 3/16/21.
//

enum Result: Int, Comparable {

	case loss = -1
	case draw = 0
	case win = 1

	static func < (lhs: Self, rhs: Self) -> Bool {
	   return lhs.rawValue < rhs.rawValue
	 }

}

import XCTest

import rpsTests

var tests = [XCTestCaseEntry]()
tests += rpsTests.allTests()
XCTMain(tests)

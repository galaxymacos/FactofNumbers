//
//  ExpressionFilter.swift
//  FactofNumbers
//
//  Created by xunruan on 2021-11-30.
//

import Foundation
import SwiftUI

struct ExpressionFilter {
    var urlAddition = "https://x-math.herokuapp.com/api/add"
    var urlSubtraction = "https://x-math.herokuapp.com/api/sub"
    var urlMultiplication = "https://x-math.herokuapp.com/api/mul"
    var urlDivision = "https://x-math.herokuapp.com/api/div"
    var additionToggle = true
    var subtractionToggle = false
    var multiplicationToggle = false
    var divisionToggle = false
    var max: Int = 99
    var min: Int = 1
    var activeUrls: [String] = []
    var showNotPickedAlert = false
    mutating func randomURL() -> String {
        if additionToggle {
            activeUrls.append(urlAddition)
        }
        if subtractionToggle {
            activeUrls.append(urlSubtraction)
        }
        if multiplicationToggle {
            activeUrls.append(urlMultiplication)
        }
        if divisionToggle {
            activeUrls.append(urlDivision)
        }
        if activeUrls.isEmpty {
            fatalError("You haven't picked a type of expression to generate")
        }
        var randomExpression = activeUrls.randomElement()!
        randomExpression.append("?max=\(max)")
        randomExpression.append("&min=\(min)")
        return randomExpression
    }
}

////
////  Card.swift
////  Set
////
////  Created by Alexander Angelov on 15.10.22.
////

import Foundation

class Card: Identifiable {
    
    var id = UUID()
    var isSelected: Bool = false
    var isSet: Bool = false
    var isMatch: MatchState = .NotSetYet
    
    let numberOfShapes: NumberOfShapes
    let shape: Shape
    let color: Color
    let shading: Shading
    
    init(numberOfShapes: NumberOfShapes, shape: Shape, color: Color, shading: Shading) {
        self.numberOfShapes = numberOfShapes
        self.shape = shape
        self.color = color
        self.shading = shading
    }
    
    enum MatchState {
        case Match
        case MissMatch
        case NotSetYet
    }
    
    enum NumberOfShapes: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }
    enum Shape: CaseIterable {
        case triangle
        case square
        case oval
    }
    enum Color: CaseIterable {
        case red
        case blue
        case purple
    }
    enum Shading: CaseIterable {
        case filled
        case striped
        case empty
    }
}

////
////  Card.swift
////  Set
////
////  Created by Alexander Angelov on 15.10.22.
////
//
//import Foundation
//
//class Card : Hashable {
//
//    var isSelected : Bool = false
//    var indexOnField: Int = 0
//    var id: Int = 0
//    var color: Color = .red
//    var shading: Shading = .striped
//    var shape: Shape = .triangle
//    var elementCount: ElementCount = .one
//
//    static func == (lhs: Card, rhs: Card) -> Bool {
//        lhs.id == rhs.id
//    }
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//
//    init() {
//
//    }
//
//    init(id: Int, color: Color, shading: Shading, shape: Shape, elementCount: ElementCount) {
//        self.id = id
//        self.color = color
//        self.shading = shading
//        self.shape = shape
//        self.elementCount = elementCount
//    }
//
//    init(shape: Shape, elementCount: ElementCount, color: Color, shading: Shading) {
//        self.shape = shape
//        self.elementCount = elementCount
//        self.color = color
//        self.shading = shading
//    }
//
//    enum Color : CaseIterable {
//        case red
//        case blue
//        case purple
//    }
//    enum Shading : CaseIterable {
//        case filled
//        case striped
//        case empty
//    }
//
//    enum Shape : CaseIterable {
//        case oval
//        case triangle
//        case square
//    }
//    enum ElementCount : CaseIterable {
//        case one
//        case two
//        case three
//    }
//}

//
//  CardView.swift
//  Set
//
//  Created by Alexander Angelov on 17.10.22.
//

import UIKit

class CardView: UIView {
    
    private var color: UIColor = .clear
    private var shapePaths: [UIBezierPath] = []
    private var stripedPaths: [UIBezierPath] = []
    private var shading: CGFloat = .zero
    private var cardBack = UIImageView()
    
    override var frame: CGRect {
        didSet {
            cardBack.frame = bounds
        }
    }
    
    override func draw(_ rect: CGRect) {
        color.setStroke()
        color.withAlphaComponent(shading).setFill()
        for (index, shapePath) in shapePaths.enumerated() {
            shapePath.lineWidth = CardViewConstant.shapeLineWidth
            if !stripedPaths.isEmpty {
                drawStripedPath(at: index)
            }
            shapePath.stroke()
            shapePath.fill()
        }
    }
    
    func configure(with card: Card) {
        setupCardView()
        let numberOfShapes = card.numberOfShapes.rawValue
        let rectsForShapes = createRectsForShapes(count: numberOfShapes)
        
        for rect in rectsForShapes {
            if card.shading == .striped {
                let stripedPath = createStripedPath(in: rect)
                stripedPaths.append(stripedPath)
            }
            let paddingX = rect.width * CardViewConstant.rectPaddingMultiplier
            let paddingY = rect.height * CardViewConstant.rectPaddingMultiplier
            let rect = rect.insetBy(dx: paddingX, dy: paddingY)
            
            let bezierPath: UIBezierPath
            switch card.shape {
                case .square:
                    bezierPath = createDiamondPath(in: rect)
                case .oval:
                    bezierPath = createOvalPath(in: rect)
                case .triangle:
                    bezierPath = createSquigglePath(in: rect)
            }
            shapePaths.append(bezierPath)
        }
        
        switch card.color {
            case .red:
                color = .systemRed
            case .blue:
                color = .systemGreen
            case .purple:
                color = .systemPurple
        }
        
        switch card.shading {
            case .filled:
                shading = 1.0
            case .empty:
                shading = 0.0
            case .striped:
                shading = 0.0
        }
    }
    
    func showBackSide() {
        setupCardView()
        cardBack.image = UIImage(named: "cardBackCurvedEdges")
        addSubview(cardBack)
    }
    
    func removeBackSide() {
        cardBack.removeFromSuperview()
    }
    
    private func setupCardView() {
        backgroundColor = .white
        layer.masksToBounds = true
        layer.cornerRadius = CardViewConstant.cornerRadius
    }
}

private extension CardView {
    func createRectsForShapes(count: Int) -> [CGRect] {
        let size = CGSize(width: bounds.size.width,
                          height: bounds.size.height / CardViewConstant.maxNumberOfShapes)
        let grid = Grid(layout: .fixedCellSize(size), frame: bounds)
        var rects: [CGRect] = []
        for index in 0..<count {
            guard var rect = grid[index] else {
                break
            }
            rect.displace(in: bounds, count: count)
            rects.append(rect)
        }
        return rects
    }
    
    func createDiamondPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.close()
        return path
    }
    
    func createOvalPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height)
        return path
    }
    
    func createSquigglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 104.0, y: 15.0))
        path.addCurve(to: CGPoint(x: 63.0, y: 54.0),
                      controlPoint1: CGPoint(x: 112.4, y: 36.9),
                      controlPoint2: CGPoint(x: 89.7, y: 60.8))
        path.addCurve(to: CGPoint(x: 27.0, y: 53.0),
                      controlPoint1: CGPoint(x: 52.3, y: 51.3),
                      controlPoint2: CGPoint(x: 42.2, y: 42.0))
        path.addCurve(to: CGPoint(x: 5.0, y: 40.0),
                      controlPoint1: CGPoint(x: 9.6, y: 65.6),
                      controlPoint2: CGPoint(x: 5.4, y: 58.3))
        path.addCurve(to: CGPoint(x: 36.0, y: 12.0),
                      controlPoint1: CGPoint(x: 4.6, y: 22.0),
                      controlPoint2: CGPoint(x: 19.1, y: 9.7))
        path.addCurve(to: CGPoint(x: 89.0, y: 14.0),
                      controlPoint1: CGPoint(x: 59.2, y: 15.2),
                      controlPoint2: CGPoint(x: 61.9, y: 31.5))
        path.addCurve(to: CGPoint(x: 104.0, y: 15.0),
                      controlPoint1: CGPoint(x: 95.3, y: 10.0),
                      controlPoint2: CGPoint(x: 100.9, y: 6.9))
        
        let pathRect = path.bounds
        let scaleX: CGFloat = (rect.width) / pathRect.width
        let scaleY: CGFloat = (rect.height) / pathRect.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        path.apply(transform)
        
        let scaledPathRect = path.bounds
        let translationX: CGFloat = rect.minX - scaledPathRect.minX
        let translationY: CGFloat = rect.minY - scaledPathRect.minY
        let translate = CGAffineTransform(translationX: translationX, y: translationY)
        path.apply(translate)
        
        return path
    }
    
    func createStripedPath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        for x in stride(from: rect.minX, to: rect.maxX, by: CardViewConstant.stripeLineWidth * 3.3) {
            path.move(to: CGPoint(x: rect.minX + x, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX + x, y: rect.maxY))
        }
        return path
    }
    
    func drawStripedPath(at index: Int) {
        let stripedPath = stripedPaths[index]
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        shapePaths[index].addClip()
        stripedPath.lineWidth = CardViewConstant.stripeLineWidth
        stripedPath.stroke()
        context?.restoreGState()
    }
}

enum CardViewConstant {
    static let aspectRatio: CGFloat = 5 / 7
    static let insetMultiplier = 0.05
    static let borderWidth: CGFloat = 3
    static let shapeLineWidth: CGFloat = 2
    static let stripeLineWidth: CGFloat = 4
    static let rectPaddingMultiplier = 0.12
    static let cornerRadius: CGFloat = 5
    static let maxNumberOfShapes: CGFloat = 3
}


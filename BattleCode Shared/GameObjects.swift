//
//  GameObjects.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/15/22.
//

import Foundation
import SpriteKit

public struct CardObj {
    var card: SKShapeNode
    let height = 400
    let width = 200
    init () {
        let card = SKShapeNode()
        let path = CGMutablePath()
        path.addRect(CGRect(x: -width / 2, y: -height / 2, width: width, height: height))
        card.path = path
        card.lineWidth = 1
        card.fillColor = .white
        card.strokeColor = .black
        card.glowWidth = 0.5
        self.card = card
//        let card = SKShapeNode()
//        let path = CGMutablePath()
//        path.addArc(center: CGPoint.zero,
//                    radius: 15,
//                    startAngle: 0,
//                    endAngle: CGFloat.pi * 2,
//                    clockwise: true)
//        card.path = path
//        card.lineWidth = 1
//        card.fillColor = .blue
//        card.strokeColor = .white
//        card.glowWidth = 0.5
//        self.card = card
    }
}

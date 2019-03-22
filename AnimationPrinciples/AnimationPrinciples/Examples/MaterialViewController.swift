//
//  MaterialViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 07/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class MaterialViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let duration = 1.0
        let sideSize = 100.0
        let coeff = 1.2
        let posDelta = sideSize * (1 - coeff) / 2
        let rect = RoundRect(rect: Rect(x: 0, y: 0, w: sideSize, h: sideSize), rx: 5, ry: 5)
        
        let springyShape = Shape(
            form: rect,
            fill: color,
            place: .move(dx: 30, dy: 30)
        )
        
        let springyGrow = springyShape.placeVar.animation(to: springyShape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), during: duration, delay: 0.5).easing(.elasticInOut(elasticity: 5))
        let springyShrink = springyShape.placeVar.animation(from: springyShape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), to: springyShape.place, during: duration, delay: 0.5).easing(.elasticInOut(elasticity: 5))
        let springAnimation = [springyGrow, springyShrink].sequence()
        
        let shape = Shape(
            form: rect,
            fill: color,
            place: .move(dx: 180, dy: 30)
        )
        
        let grow = shape.placeVar.animation(to: shape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), during: duration, delay: 0.5).easing(.easeInOut)
        let shrink = shape.placeVar.animation(from: shape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), to: shape.place, during: duration, delay: 0.5).easing(.easeInOut)
        let regularAnimation = [grow, shrink].sequence()

        animation = [springAnimation, regularAnimation].combine().cycle()
        svgView.node = Group(contents: [springyShape, shape])
    }

}

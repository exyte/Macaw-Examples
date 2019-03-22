//
//  SecondaryViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 09/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class SecondaryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sideSize = 100.0
        let coeff = 1.7
        let duration = 0.4
        let posDelta = sideSize * (1 - coeff) / 4
        
        let springyShape = Shape(
            form: RoundRect(rect: Rect(w: sideSize, h: sideSize), rx: 5, ry: 5),
            fill: color,
            place: .move(dx: 60, dy: 90)
        )
        
        let springyGrow = springyShape.placeVar.animation(to: springyShape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), during: duration, delay: 0.5).easing(.elasticInOut(elasticity: 5))
        let springyShrink = springyShape.placeVar.animation(from: springyShape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), to: springyShape.place, during: duration, delay: 0.5).easing(.elasticInOut(elasticity: 5))
        let growingAnimation = [springyGrow, springyShrink].sequence()
        
        let rotatingShape = Shape(
            form: RoundRect(rect: Rect(w: 50, h: 50), rx: 5, ry: 5),
            fill: color,
            place: .move(dx: 230, dy: 20)
        )
        
        let g = [rotatingShape].group()
        let there = g.contentsVar.animation( { (t) -> [Node] in
            return [Shape(form: rotatingShape.form,
                          fill: color,
                          place: GeomUtils.centerRotation(node: rotatingShape, place: rotatingShape.place, angle: 0.interpolate(.pi*5/4, progress: t)))]
        }, during: duration, delay: 0.5)
        let back = g.contentsVar.animation( { (t) -> [Node] in
            return [Shape(form: rotatingShape.form,
                          fill: color,
                          place: GeomUtils.centerRotation(node: rotatingShape, place: rotatingShape.place, angle: (.pi*5/4).interpolate(0, progress: t)))]
        }, during: duration, delay: 0.5)
        let rotationAnimation = [there, back].sequence()

        animation = [growingAnimation, rotationAnimation].combine().cycle()
        svgView.node = [springyShape, g].group()
    }

}

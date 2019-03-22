//
//  OverlappingViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 09/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class OverlappingViewController: BaseViewController {
    
    let width = 90.0
    let heigth = 150.0
    let x = 30.0
    let y = 50.0
    let radius = 15.0
    let distance = 200.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let (rect, anim1) = createMovingRect(
            easing: .easeIn,
            rect: RoundRect(rect: Rect(x: 0, y: 0, w: width, h: heigth), rx: 5, ry: 5),
            place: .move(dx: x, dy: y), distance: distance)
        
        let (circleOne, anim2) = createMovingCircle(place: .move(dx: x + width/2, dy: y + heigth/4), delay: 0.7, duration: 0.8)
        let (circleTwo, anim3) = createMovingCircle(place: .move(dx: x + width/2, dy: y + 2*heigth/4), delay: 0.8, duration: 0.7)
        let (circleThree, anim4) = createMovingCircle(place: .move(dx: x + width/2, dy: y + 3*heigth/4), delay: 1, duration: 0.5)

        animation = [anim1, anim2, anim3, anim4].combine().cycle()
        svgView.node = [rect, circleOne, circleTwo, circleThree].group()
    }
    
    func createMovingCircle(place: Transform, delay: Double, duration: Double) -> (Node, Animation) {
        let circle = Shape(
            form: Circle(cx: 0, cy: 0, r: radius),
            fill: secondaryColor,
            place: place
        )
        let there = circle.placeVar.animation(to: circle.place.move(dx: distance, dy: 0), during: duration, delay: delay)
        let back = circle.placeVar.animation(from: circle.place.move(dx: distance, dy: 0), to: circle.place.move(dx: 0, dy: 0), during: 0.5).easing(.easeIn)
        return (circle, [there, back].sequence())
    }
    
    func createMovingRect(easing: Easing, rect: RoundRect, place: Transform, distance: Double) -> (Node, Animation) {
        let g = Group(contents: [Shape(form: rect, fill: color)], place: place)
        let there = g.contentsVar.animation( { (t) -> [Node] in
            return [Shape(form: createRightDistortedRoundedRectBothways(parameter: t, distortion: 20, width: rect.rect.w, height: rect.rect.h), fill: color, place: .move(dx: t * distance, dy: 0))]
        }, during: 0.5, delay: 0.5).easing(easing)
        let back = g.contentsVar.animation( { (t) -> [Node] in
            return [Shape(form: createLeftDistortedRoundedRectBothways(parameter: t, distortion: 20, width: rect.rect.w, height: rect.rect.h), fill: color, place: .move(dx: distance + t * -distance, dy: 0))]
        }, during: 0.5, delay: 0.5).easing(easing)
        return (g, [there, back].sequence())
    }

}

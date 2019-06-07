//
//  TrajectoryViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 08/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class TrajectoryViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let origin = Point(x: 60, y: 60)
        let distance = 200.0
        let duration = 0.7
        
        let circle = Shape(
            form: Circle(r: 30),
            fill: color,
            place: .move(dx: 60, dy: 60)
        )
        
        let m = PathSegment(type: .M, data: [origin.x, origin.y])
        let q = PathSegment(type: .Q, data: [origin.x + distance/2, origin.y - 30, origin.x + distance, origin.y])
        let circleAnimation = circle.placeVar.animation(along: Path(segments: [m, q]), during: duration).easing(.linear)
        
        let rect = Shape(
            form: RoundRect(rect: Rect(w: 60, h: 60), rx: 5, ry: 5),
            fill: color,
            place: .move(dx: 30, dy: 150)
        )
        let rectAnimation = rect.placeVar.animation(to: .move(dx: distance + rect.place.dx, dy: rect.place.dy), during: duration)
        
        animation = [circleAnimation, rectAnimation].combine().autoreversed().cycle()
        svgView.node = Group(contents: [circle, rect])
    }

}

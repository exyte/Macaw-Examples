//
//  FocusViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 08/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class FocusViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let radius = 20.0
        
        let rect = Shape(
            form: RoundRect(rect: Rect(x: 0, y: 0, w: 100, h: 100), rx: 5, ry: 5),
            fill: color,
            place: .move(dx: 50, dy: 100)
        )
        
        let innerCircle = Shape(form: Circle(cx: 0, cy: 0, r: radius), fill: color, place: .move(dx: 250, dy: 50))
        let innerAnimation = innerCircle.placeVar.animation(to: innerCircle.place.scale(sx: 0.9, sy: 0.9), during: 0.4).autoreversed()
        
        let outerCircle = Shape(form: Circle(cx: 0, cy: 0, r: radius), fill: color)
        let outerGroup = Group(contents: [outerCircle], place: .move(dx: 250, dy: 50))
        let outerAnimation = outerGroup.contentsVar.animation({ t in
            let newColor = color.with(a: 1 - t)
            return [Circle(r: (1 + t) * radius).fill(with: newColor)]
            }, during: 0.8)

        animation = [innerAnimation, outerAnimation].combine().cycle()
        svgView.node = [rect, innerCircle, outerGroup].group()
    }

}

//
//  AnticipationViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 09/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class AnticipationViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = createMovingRect(easing: .elasticInOut, rect: Rect(w: 60, h: 120), place: .move(dx: 30, dy: 30), distortion: 20, delay: 0, during: 2)
        
//        let rect = Group(contents: [Shape(form: Rect(w: 60, h: 120), fill: color)], place: .move(dx: 30, dy: 30))
//        rect.contentsVar.animation( { (t) -> [Node] in
//            return [Shape(form: Rect(w: 60, h: 120), fill: color, place: .move(dx: t * 200.0, dy: 0))]
//        }, during: 2.5, delay: 0.5).easing(.spring()).autoreversed().cycle().play()
        //rect.placeVar.animation(to: .move(dx: 200, dy: 30)).autoreversed().cycle().play()
        svgView.node = rect
    }

}

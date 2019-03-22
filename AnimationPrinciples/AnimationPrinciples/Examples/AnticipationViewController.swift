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

        let (rect, anim) = createMovingRect(easing: .elasticInOut, rect: Rect(w: 60, h: 120), place: .move(dx: 30, dy: 30), distortion: 20, delay: 0, during: 2)
        
        animation = anim.cycle()
        svgView.node = rect
    }

}

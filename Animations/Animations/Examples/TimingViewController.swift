//
//  TimingViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 08/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class TimingViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = Rect(w: 60, h: 60)
        
        let (rectOne, anim1) = createMovingRect(easing: .easeIn,
                                       rect: rect,
                                       place: .move(dx: 30, dy: 50))
        
        let (rectTwo, anim2) = createMovingRect(easing: .easeOut,
                                       rect: rect,
                                       place: .move(dx: 30, dy: 150))

        let (rectThree, anim3) = createMovingRect(easing: .easeInOut,
                                         rect: rect,
                                         place: .move(dx: 30, dy: 250))

        animation = [anim1, anim2, anim3].combine().cycle()
        svgView.node = [rectOne, rectTwo, rectThree].group()
    }
    
}

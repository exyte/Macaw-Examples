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
        
        let rectOne = createMovingRect(easing: .easeIn,
                                       rect: rect,
                                       place: .move(dx: 30, dy: 50))
        
        let rectTwo = createMovingRect(easing: .easeOut,
                                       rect: rect,
                                       place: .move(dx: 30, dy: 150))
        
        let rectThree = createMovingRect(easing: .easeInOut,
                                         rect: rect,
                                         place: .move(dx: 30, dy: 250))
        
        svgView.node = Group(contents: [rectOne, rectTwo, rectThree])
    }
    
}

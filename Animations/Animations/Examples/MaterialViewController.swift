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

        let sideSize = 100.0
        let coeff = 1.2
        let posDelta = sideSize * (1 - coeff) / 2
        let rect = RoundRect(rect: Rect(x: 0, y: 0, w: sideSize, h: sideSize), rx: 5, ry: 5)
        
        let springyShape = Shape(
            form: rect,
            fill: color,
            place: .move(dx: 30, dy: 30)
        )
        
        let springyGrow = springyShape.placeVar.animation(to: springyShape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), during: 0.5, delay: 0.5).easing(.elasticInOut(elasticity: 5))
        let springyShrink = springyShape.placeVar.animation(from: springyShape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), to: springyShape.place, during: 0.5, delay: 0.5).easing(.elasticInOut(elasticity: 5))
        [springyGrow, springyShrink].sequence().cycle().play()
        
        let shape = Shape(
            form: rect,
            fill: color,
            place: .move(dx: 180, dy: 30)
        )
        
        let grow = shape.placeVar.animation(to: shape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), during: 0.5, delay: 0.5).easing(.easeInOut)
        let shrink = shape.placeVar.animation(from: shape.place.scale(sx: coeff, sy: coeff).move(dx: posDelta, dy: posDelta), to: shape.place, during: 0.5, delay: 0.5).easing(.easeInOut)
        [grow, shrink].sequence().cycle().play()

//        shape.onTap { _ in
//            print("tap!")
//            shape.fillVar.animation(from: Color.white, to: Color(val: 0x333333), during: 1.8).play()
//        }

        svgView.node = Group(contents: [springyShape, shape])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        
        let circle = Shape(
            form: Circle(r: 30),
            fill: color,
            place: .move(dx: origin.x, dy: origin.y)
        )
        
        let m = PathSegment(type: .M, data: [origin.x, origin.y])
        let q = PathSegment(type: .Q, data: [origin.x + distance/2, origin.y - 30, origin.x + distance, origin.y])
        circle.placeVar.animation(along: Path(segments: [m, q]), during: 0.8).easing(.linear).autoreversed().cycle().play()
        
        let rect = Shape(
            form: RoundRect(rect: Rect(w: 60, h: 60), rx: 5, ry: 5),
            fill: color,
            place: .move(dx: 30, dy: 150)
        )
        
        rect.placeVar.animation(to: .move(dx: distance + rect.place.dx, dy: rect.place.dy), during: 0.8).autoreversed().cycle().play()
        
        svgView.node = Group(contents: [circle, rect])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

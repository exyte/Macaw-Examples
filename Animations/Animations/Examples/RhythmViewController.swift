//
//  RhythmViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 11/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class RhythmViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let duration = 0.2
        let delay = 0.2
        
        // rect animations
        
        let rect = Shape(
            form: RoundRect(rect: Rect(w: 60, h: 60), rx: 5, ry: 5),
            fill: color,
            place: .move(dx: 60, dy: 150)
        )
        
        let move = rect.place.move(dx: 60, dy: 0)
        let scale = move.move(dx: 60 * -0.3/2, dy: 60 * -0.3/2).scale(sx: 1.3, sy: 1.3)
        
        let anim1 = rect.placeVar.animation(to: move, during: duration, delay: delay)
        let anim2 = rect.placeVar.animation(from: move, to: scale, during: duration, delay: delay)
        let anim3 = rect.placeVar.animation(from: scale, to: move, during: duration, delay: delay)
        let anim4 = rect.placeVar.animation(from: move, to: rect.place, during: duration, delay: delay)
        
        let rectAnimations = [anim1, anim2, anim3, anim4].sequence()
        
        // little things
        
        let littleRect = Rect(w: 8, h: 8)
        
        let r1 = Shape(form: littleRect, fill: color, place: .move(dx: 10, dy: 1))
        let r2 = Shape(form: littleRect, fill: color, place: .move(dx: 30, dy: 1))
        let r3 = Shape(form: littleRect, fill: color, place: .move(dx: 50, dy: 1))
        
        let l1 = Shape(form: Line(x1: 0, y1: 0, x2: 0, y2: 10), stroke: Stroke(fill: color, width: 2))
        let l2 = Shape(form: Line(x1: 70, y1: 0, x2: 70, y2: 10), stroke: Stroke(fill: color, width: 2))
        let l3 = Shape(form: Line(x1: 0, y1: 5, x2: 70, y2: 5), stroke: Stroke(fill: color, width: 2))
        
        let littleGroup = Group(contents: [r1, r2, r3, l1, l2, l3], place: .move(dx: 200, dy: 120))
        
        
        let thingy = Shape(form: Line(x1: 0, y1: 0, x2: 0, y2: 10), stroke: Stroke(fill: secondaryColor, width: 2))
        
        let thingyMoves1 = thingy.placeVar.animation(from: .move(dx: 200, dy: 120), to: thingy.place.move(dx: 214, dy: 120), during: duration, delay: delay)
        let thingyMoves2 = thingy.placeVar.animation(from: .move(dx: 214, dy: 120), to: .move(dx: 234, dy: 120), during: duration, delay: delay)
        let thingyMoves3 = thingy.placeVar.animation(from: .move(dx: 234, dy: 120), to: .move(dx: 254, dy: 120), during: duration, delay: delay)
        let thingyMoves4 = thingy.placeVar.animation(from: .move(dx: 254, dy: 120), to: .move(dx: 270, dy: 120), during: duration, delay: delay)
        
        let thingyAnimations = [thingyMoves1, thingyMoves2, thingyMoves3, thingyMoves4].sequence()
        
        // numbers
        
//        let text = Text(text: "1", font: Font(name: "Helvetica-Bold", size: 20, weight: "bold"), fill: color, align: .mid, place: .move(dx: 235, dy: 140))
//        
//        text.placeVar.animation(to: .scale(sx: 0, sy: 0))
        
        [rectAnimations, thingyAnimations].combine().cycle().play()
        
        svgView.node = [rect, littleGroup, thingy].group()
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

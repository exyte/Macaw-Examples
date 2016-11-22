//
//  ViewController.swift
//  TestExample
//
//  Created by Julia Bulantseva on 11/10/16.
//  Copyright © 2016 Julia Bulantseva. All rights reserved.
//

import UIKit
import Macaw

class RunningLevelController: UIViewController {
    
    @IBOutlet weak var macawView: MacawView?
    var shapes: [Shape] = []
    var a = [70.0, 90.0, 50.0, 150.0, 70.0, 50.0, 20.0]
    let colors = [Color(val: 0x99FFFF), Color(val: 0xCCFFFF), Color(val: 0xCCFFFF), Color(val: 0xFFCCFF), Color(val: 0xFF99FF), Color(val: 0xFF66FF), Color(val: 0xFF66FF), Color(val: 0xFF66FF), Color(val: 0xFF33FF), Color(val: 0xFF00FF)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var shape = Shape( form: RoundRect( rect: Rect(x: 30, y: 50, w: 20, h: 90), rx: 5, ry: 5), fill: Color(val: 0xfcc07c))
        
        var x = 30.0
        let y = 100.0
        
        for _ in 0...6 {
            let color4 = Color.rgba(r: 138, g: 147, b: 219, a: 0.5)
            shape = Shape( form: RoundRect( rect: Rect(x: x, y: y, w: 5, h: 150), rx: 5, ry: 5), fill: color4)
            self.shapes.append(shape)
            x = x + 40
        }
        
        x = 30.0
        
        for i in 0...6 {
            //let color4 = Color.rgb(r: 138, g: 147, b: 219)
            shape = Shape( form: RoundRect( rect: Rect(x: x, y: 2.5*y-a[i], w: 5, h: a[i]), rx: 5, ry: 5), fill: LinearGradient(degree: 90, from: Color(val: 0xFF00FF), to: Color(val: 0xFFFF66)),
                           stroke: Stroke(fill: Color(val: 0xff9e4f), width: 1), place: Transform.scale(sx: 1, sy: 0.00001))
            shape.placeVar.animate(to: .scale(sx: 1, sy: 1), delay: 0.2)
            self.shapes.append(shape)
            macawView?.node = shapes.group()
            x = x + 40
        }
        
       // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
         //   self.macawView?.node = self.shapes.group(place: .scale(sx: 1, sy: 1))
        //}

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


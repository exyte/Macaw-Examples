//
//  ViewController.swift
//  TestExample
//
//  Created by Julia Bulantseva on 11/10/16.
//  Copyright © 2016 Julia Bulantseva. All rights reserved.
//

import UIKit
import Macaw

class TotalStepsController: UIViewController {
    
    @IBOutlet weak var macawView: MacawView?
    var shapes: [Shape] = []
    var a = [1, 2, 2, 3, 10, 6, 4]
    let colors = [Color(val: 0x99FFFF), Color(val: 0xCCFFFF), Color(val: 0xCCFFFF), Color(val: 0xFFCCFF), Color(val: 0xFF99FF), Color(val: 0xFF66FF), Color(val: 0xFF66FF), Color(val: 0xFF66FF), Color(val: 0xFF33FF), Color(val: 0xFF00FF)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let text = Text(text: "Total of steps", font: Font(name: "Serif", size: 24), fill: Color(val: 0xFFFFFF))
        text.place = .move(dx: 100, dy: 10)
        
        var shape = Shape( form: RoundRect( rect: Rect(x: 30, y: 50, w: 50, h: 10), rx: 5, ry: 5), fill: Color(val: 0xfcc07c))
        var x = 30.0
        var y = 170.0
        
        for _ in 0...6 {
            x = x + 30
            y = 170.0
            for _ in 0...9 {
                let color4 = Color.rgba(r: 138, g: 147, b: 219, a: 0.5)
                shape = Shape( form: RoundRect( rect: Rect(x: x, y: y, w: 20, h: 5), rx: 5, ry: 5), fill: color4)
                self.shapes.append(shape)
                y = y - 10
            }
        }
        
        let g = [shapes.group(), text].group()
        g.place = .move(dx: 20, dy: 60)
        macawView?.node = g
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            for i in 0...6 {
                let count = self.a[i]
                let column = i*10
                
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)*0.1) {
                    for j in column...column+count-1 {
                        self.shapes[j].fill = self.colors[j%10]
                    }
                    
                    let g = [self.shapes.group(), text].group()
                    g.place = .move(dx: 20, dy: 60)
                    self.macawView?.node = g
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


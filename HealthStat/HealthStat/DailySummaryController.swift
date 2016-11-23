//
//  DailySummaryController.swift
//  HealthStat
//
//  Created by Julia Bulantseva on 22/11/16.
//  Copyright © 2016 Julia Bulantseva. All rights reserved.
//

import UIKit
import Macaw

class DailySummaryController: UIViewController {
    
    let screen = UIScreen.main.bounds
    
    @IBOutlet weak var macawView: MacawView?
    let color = [Color(val: 0xDB7093), Color(val: 0x00FFFF), Color(val: 0xFFFF00)]
    let extent = [4.0, 2.0, 3.0]
    let r = [100.0, 80.0, 60.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootNode = Group(place: .move(dx: Double(screen.width)/2, dy: 200))
        
        let emptyColor = Color.rgba(r: 138, g: 147, b: 219, a: 0.5)
        
        for i in 0...2 {
            let circle = Shape(form: Circle(cx: 0, cy: 0, r: r[i]), stroke: Stroke(fill: emptyColor, width: 19))
            rootNode.contents.append(circle)
            
        }
        
        let group = Group()
        rootNode.contents.append(group)
        
        macawView?.node  = rootNode
        let contentsAnim = group.contentsVar.animation({ t in
            var shapes1: [Shape] = []
            for i in 0...2 {
                shapes1.append(self.createArc(t, i))
                
            }
            
            return  shapes1
        }, during: 3.0)
        
        contentsAnim.play()
        
    }

    private func createArc(_ t: Double, _ i: Int) -> Shape {
        return Shape(form: Arc(ellipse: Ellipse(cx: 0, cy: 0, rx: self.r[i], ry: self.r[i]), shift: 5.0, extent: self.extent[i]*t), stroke: Stroke(fill: self.color[i], width: 19, cap: .round))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


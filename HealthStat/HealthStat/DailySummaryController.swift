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
    
    @IBOutlet weak var macawView: MacawView?
    var shapes: [Shape] = []
    let color = [Color(val: 0xDB7093), Color(val: 0x00FFFF), Color(val: 0xFFFF00)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var r = 100.0
        var extent = 4.0
        let emptyColor = Color.rgba(r: 138, g: 147, b: 219, a: 0.5)
        
        for i in 0...2 {
            let circle = Shape(form: Circle(cx: 200, cy: 200, r: r), stroke: Stroke(fill: emptyColor, width: 19))
            
            let arc = Shape(form: Arc(ellipse: Ellipse(cx: 200, cy: 200, rx: r, ry: r), shift: 5.0, extent: extent), stroke: Stroke(fill: color[i], width: 19))
            self.shapes.append(circle)
            self.shapes.append(arc)
            r = r - 20.0
            extent = extent - 1.0
            
        }

        self.macawView?.node = self.shapes.group()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


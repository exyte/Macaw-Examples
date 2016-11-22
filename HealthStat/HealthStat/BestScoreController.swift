
import UIKit
import Macaw

class BestScoreController: UIViewController {
    
    @IBOutlet weak var macawView: MacawView?
    var shapes: [Shape] = []
    var a = [70.0, 90.0, 50.0, 150.0, 70.0, 50.0, 20.0]
    let colors = [Color(val: 0x99FFFF), Color(val: 0xCCFFFF), Color(val: 0xCCFFFF), Color(val: 0xFFCCFF), Color(val: 0xFF99FF), Color(val: 0xFF66FF), Color(val: 0xFF66FF), Color(val: 0xFF66FF), Color(val: 0xFF33FF), Color(val: 0xFF00FF)]
    
    var dots1 = [CGPoint(x: 10.0, y: 120.0), CGPoint(x: 30.0, y: 100.0), CGPoint(x: 50.0, y: 120.0), CGPoint(x: 70.0, y: 110.0), CGPoint(x: 110.0, y: 120.0), CGPoint(x: 120.0, y: 70.0), CGPoint(x: 130.0, y: 150.0), CGPoint(x: 140.0, y: 170.0), CGPoint(x: 150.0, y: 110.0), CGPoint(x: 160.0, y: 120.0), CGPoint(x: 170.0, y: 90.0), CGPoint(x: 180.0, y: 70.0), ]
    
    let cubicCurve = CubicCurveAlgorithm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let x = 10.0
        let y = 160.0
        //var tes = 0.0
        self.shapes.append(Line(x1: 10, y1: 300, x2: 285, y2: 300).stroke())
        self.shapes.append(Line(x1: 10, y1: 100, x2: 10, y2: 300).stroke())

        let controlPoints = self.cubicCurve.controlPointsFromPoints(dataPoints: dots1)
        //for _ in 0...2 {
          //  x = 10
        var path : PathBuilder = MoveTo(x: x, y: y)
        
        //let a = MoveTo(x: x, y: y).cubicTo(x1: Double(controlPoints[i].controlPoint1.x), y1: Double(controlPoints[i].controlPoint1.y), x2: Double(controlPoints[i].controlPoint2.x), y2: Double(controlPoints[i].controlPoint2.y), x: Double(dots1[i+1].x), y: Double(dots1[i+1].y)).build()
            for i in 0...dots1.count-2 {
                //let a = MoveTo(x: x, y: y).cubicTo(x1: Double(controlPoints[i].controlPoint1.x), y1: Double(controlPoints[i].controlPoint1.y), x2: Double(controlPoints[i].controlPoint2.x), y2: Double(controlPoints[i].controlPoint2.y), x: Double(dots1[i+1].x), y: Double(dots1[i+1].y)).build()
                path = path.cubicTo(x1: Double(controlPoints[i].controlPoint1.x), y1: Double(controlPoints[i].controlPoint1.y), x2: Double(controlPoints[i].controlPoint2.x), y2: Double(controlPoints[i].controlPoint2.y), x: Double(dots1[i+1].x), y: Double(dots1[i+1].y))
                //self.shapes.append(shape)
                //x = Double(dots1[i+1].x)
                //y = Double(dots1[i+1].y)
            }
            let shape = Shape( form: path.build(), stroke: Stroke(fill: Color(val: 0xff9e4f), width: 2))
            self.shapes.append(shape)
          //  tes = tes + 40
       // }
        
        //Color(val: 0xf442f1)
        let rect = Shape( form: Rect(x: 2, y: 0, w: 300, h: 290), fill: Color.white)
        let anim = rect.placeVar.animation ({ t -> Transform in
            return Transform.move(dx: 200.0 * t, dy: 0.0) //move(dx: 100.0 * t, dy: 100.0 * t)//
            //return Transform().scale(sx:(1.0 - t), sy: 1) //move(dx: 100.0 * t, dy: 100.0 * t)//
        }, during: 1.0, delay: 1.0)
        anim.play()
        self.shapes.append(rect)
        
        self.macawView?.node = self.shapes.group(place: .move(dx: 30, dy: 0))
        
        
        /*
        shapes.group().placeVar.animate({ t -> Transform in
            
            return Transform().scale(sx: t, sy: t)
        }, during: 3.0)
 */
        
        
        //macawView?.node = shapes.group()
        
        //let rootNode =  [shapes[0].group(place: .scale(sx: 0.000001, sy: 0.000001))].group()
        //macawView?.node  = rootNode
        
        //let contentsAnim = rootNode.contentsVar.animation({ t in
            
            //for i in 0...self.dots1.count-2 {
           //     let a = MoveTo(x: x, y: y).cubicTo(x1: Double(controlPoints[i].controlPoint1.x), y1: Double(controlPoints[i].controlPoint1.y), x2: Double(controlPoints[i].controlPoint2.x), y2: Double(controlPoints[i].controlPoint2.y), x: Double(self.dots1[i+1].x), y: Double(self.dots1[i+1].y)).build()
                
             //   let shape = Shape( form: a, stroke: Stroke(fill: Color(val: 0xff9e4f), width: 2))
              //  self.shapes.append(shape)
               // x = Double(self.dots1[i+1].x)
               // y = Double(self.dots1[i+1].y)
           // }
                //let rect = Shape( form: Rect(x: 30, y: 50, w: 300, h: 150), fill: Color.white)
                //return  [[self.shapes[0].group(place: .scale(sx: t, sy: t))].group()]
            //}, during: 5.0)
        
        //contentsAnim.play()
        
        // DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          // self.macawView?.node = self.shapes.group(place: .scale(sx: 1, sy: 1))
        //}
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


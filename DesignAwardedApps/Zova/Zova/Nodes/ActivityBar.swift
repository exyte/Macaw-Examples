import Foundation
import Macaw

class ActivityBar: Group {
    
    let legend: Legend
    var jumpAnimation: Animation?
    
    init() {
        legend = Legend()
        
        let dataSet = [
            (("0", 50.0, 0.9), Transform.identity),
            (("10", 50.0, 0.6), Transform.move(dx: 52, dy: 0)),
            (("21", 130.0, 0.6), Transform.move(dx: 104, dy: 0)),
            (("42", 50.0, 0.6), Transform.move(dx: 236, dy: 0))
        ]
        let segments = dataSet.enumerated().map { (index, data) in
            let segment = BarSegment(
                text: data.0.0,
                width: data.0.1,
                opacity: data.0.2,
                last: index == dataSet.count - 1
            )
            segment.place = data.1
            return segment
        }.group()
        
        let scoreValue = Shape(
            form: Circle(r: 2),
            fill: mainColor,
            place: Transform.move(dx: 16, dy: 4)
        )
        
        let barGroup = Group(
            contents: [segments, scoreValue],
            place: Transform.move(dx: 5.0, dy: 70.0)
        )
        
        super.init(contents: [barGroup, legend])
        
        jump()
    }
    
    func jump() {
        jumpAnimation = legend.placeVar.animation(
            to: Transform.move(dx: 0.0, dy: -8.0),
            during: 2.0
        ).autoreversed().cycle()
        jumpAnimation?.play()
    }
    
    func stopJumping() {
        jumpAnimation?.pause()
    }
}

class BarSegment: Group {
    init(text: String, width: Double, opacity: Double, last: Bool) {
        let legend = Text(
            text: text,
            font: Font(name: regularFont, size: 12),
            fill: Color.white,
            align: .min,
            baseline: .alphabetic,
            place: Transform.move(dx: 0, dy: -5)
        )
        
        let segment = Shape(
            form: Rect(w: width, h: 8),
            fill: !last ? Color.white.with(a: opacity) : LinearGradient(
                degree: 0,
                from: Color.white.with(a: opacity),
                to: mainColor
            )
        )
        super.init(contents: [legend, segment])
    }
}

class Legend: Group {
    init() {
        let border = Shape(
            form: Rect(w: 80, h: 30).round(r: 16.0),
            fill: Color.white
        )
        
        let low = Text(
            text: "Low",
            font: Font(name: regularFont, size: 20),
            fill: mainColor,
            align: .mid,
            baseline: .mid,
            place: Transform.move(dx: 40, dy: 15)
        )
        
        let line = Shape(
            form: Rect(x: 20, y: 30, w: 2, h: 40),
            fill: LinearGradient(
                degree: 90,
                from: Color.white.with(a: 0.8),
                to: mainColor
            )
        )
        
        super.init(contents: [border, low, line])
    }
}

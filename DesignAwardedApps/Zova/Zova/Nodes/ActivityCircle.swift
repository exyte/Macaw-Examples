import Foundation
import Macaw

class ActivityCircle: Group {
    
    let mainCircle: Shape
    let score: Text
    let icon: Text
    let shadows: Group
    let emojis: EmojisCircle
    
    init() {
        mainCircle = Shape(
            form: Circle(r: 60),
            fill: mainColor,
            stroke: Stroke(fill: Color.white, width: 1.0)
        )
        
        score = Text(
            text: "3",
            font: Font(name: lightFont, size: 40),
            fill: Color.white,
            align: .mid,
            baseline: .mid
        )
            
        icon = Text(
            text: "⚡",
            font: Font(name: regularFont, size: 24),
            fill: Color.white,
            align: .mid,
            place: Transform.move(dx: 0.0, dy: 30.0)
        )
        
        shadows = [
            Point(x: 0, y: 35),
            Point(x: -25, y: 25),
            Point(x: 25, y: 25),
            Point(x: 25, y: -25),
            Point(x: -25, y: -25),
            Point(x: -40, y: 0),
            Point(x: 40, y: 0),
            Point(x: 0, y: -35)
        ].map { place in
            return Shape(
                form: Circle(r: 40),
                fill: Color.white.with(a: 0.8),
                place: Transform.move(dx: place.x, dy: place.y)
            )
        }.group()
        
        emojis = EmojisCircle()
        
        super.init(contents: [shadows, mainCircle, score, icon, emojis])
    }
    
    func customize(during: Double) -> Animation {
        let lightAnimation = [
            emojis.open(during: during),
            shadows.placeVar.animation(to: Transform.scale(sx: 0.5, sy: 0.5), during: during),
            mainCircle.opacityVar.animation(to: 1.0, during: during),
            score.placeVar.animation(to: Transform.move(dx: 0, dy: -20), during: during),
            score.opacityVar.animation(to: 0.0, during: during),
            icon.placeVar.animation(to: Transform.move(dx: 0, dy: -30).scale(sx: 2.0, sy: 2.0), during: during),
        ].combine()
        return lightAnimation
    }
}

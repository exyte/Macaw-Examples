import Foundation
import Macaw

class PlayButton: Group {
    let сolor = Color.rgb(r: 219, g: 222, b: 227)
    let pressedColor = Color.rgb(r: 111, g: 112, b: 114)
  
    var onPlay: (() -> Void)?
    var onStop: (() -> Void)?
    
    init(time: Double) {
        let radius = 28.0
        
        let border = Shape(
            form: Arc(
                ellipse: Ellipse(rx: radius, ry: radius),
                shift: -M_PI / 2 + 0.05,
                extent: 2 * M_PI - 0.1
            ),
            stroke: Stroke(
                fill: Color.rgba(r: 219, g: 222, b: 227, a: 0.3),
                width: 2.0
            )
        )
        
        let circle = Shape(
            form: Circle(r: 25.0),
            fill: сolor
        )
        
        let animationGroup = Group(contents: [])
        
        let playButton = Shape(
            form: MoveTo(x: -1, y: 2).lineTo(x: 2, y: 0)
                .lineTo(x: -1, y: -2).close().build(),
            fill: Color.rgb(r: 46, g: 48, b: 58),
            place: Transform.scale(sx: 5.0, sy: 5.0)
        )
        
        let stopButton = Shape(
            form: MoveTo(x: -2, y: 2).lineTo(x: 2, y: 2)
                .lineTo(x: 2, y: -2).lineTo(x: -2, y: -2).close().build(),
            fill: Color.rgb(r: 46, g: 48, b: 58),
            place: Transform.scale(sx: 4.0, sy: 4.0)
        )
        
        let buttons = [[playButton], [stopButton]]
        let buttonGroup = Group(
            contents: buttons[0]
        )
        super.init(contents: [border, circle, animationGroup, buttonGroup])
        
        var contentAnimation: Animation!
        self.onTouchPressed { touchEvent in
            circle.fill = self.pressedColor
        }
        
        self.onTouchReleased { touchEvent in
            circle.fill = self.сolor
            let index = buttons.index { $0 == buttonGroup.contents }!
            buttonGroup.contents = buttons[(index + 1) % buttons.count]
            
            animationGroup.contents = []
            animationGroup.opacity = 1.0
            
            if index == 0 {
                contentAnimation = animationGroup.contentsVar.animation({ t in
                    let shape = Shape(
                        form: Arc(
                            ellipse: Ellipse(rx: radius, ry: radius),
                            shift: -M_PI / 2 + 0.05,
                            extent: max(2 * M_PI * t - 0.1, 0)
                        ),
                        stroke: Stroke(fill: Color.white, width: 2)
                    )
                    return [shape]
                }, during: time).cycle()
                contentAnimation.play()
                self.onPlay?()
            } else {
                contentAnimation.stop()
                animationGroup.opacityVar.animation(to: 0.0, during: 0.1).play()
                self.onStop?()
            }
        }
    }
}

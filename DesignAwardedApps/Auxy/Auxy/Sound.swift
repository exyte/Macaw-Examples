import Foundation
import Macaw

class Sound: Group {
    
    let background: Shape
    let foreground: Shape
    
    init(position: Point, size: Size) {
        let rect = Rect(
            w: size.w,
            h: size.h
        )
        
        background = Shape(
            form: rect,
            fill: Color.rgb(r: 4, g: 112, b: 215)
        )
        
        foreground = Shape(
            form: rect,
            fill: Color.white,
            opacity: 0.0
        )
        
        super.init(
            contents: [background, foreground],
            place: Transform.move(
                dx: position.x * size.w,
                dy: position.y * size.h
            )
        )
    }
    
    func hightlight() -> Animation {
        return [
            foreground.opacityVar.animation(to: 1.0, during: 0.1),
            foreground.opacityVar.animation(to: 0.0)
        ].sequence()
    }
}

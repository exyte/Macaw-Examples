import Foundation
import Macaw

class LineRunner: Shape {
    
    var size: Size
    
    init(size: Size) {
        self.size = size
        super.init(
            form: Line(
                x1: 0, y1: -1,
                x2: size.w, y2: -1
            ),
            stroke: Stroke(fill: Color.rgba(r: 219, g: 222, b: 227, a: 0.5), width: 1.0)
        )
    }
    
    var runAnimation: Animation?
    
    func run(sounds: [Point:Sound], time: Double) {
        self.place = Transform.move(dx: 0, dy: 0)
        self.opacity = 1.0
        
        let lineAnimation = self.placeVar.animation(
            to: Transform.move(dx: 0, dy: size.h),
            during: time
        ).easing(Easing.linear)
        
        let soundsAnimation = sounds.keys.map { position -> Animation in
            let sound = sounds[position]!
            return sound.hightlight().delay(sound.place.dy / self.size.h * time)
        }.combine()
        
        runAnimation = [soundsAnimation, lineAnimation].combine().cycle()
        runAnimation?.play()
    }
    
    func stop() {
        runAnimation?.stop()
        self.opacityVar.animation(to: 0.0, during: 0.1).play()
    }
}

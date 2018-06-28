import Foundation
import Macaw

class EmojisCircle: Group {
    
    let data = ["🏂", "⚽", "⚡", "🔨", "🏈", "🏋️‍♂️", "🥊", "🏓", "🏐", "🏆"]
    var emojis: Group!
    
    init() {
        emojis = data.enumerated().map { (index, item)  -> Group in
            let shape = Shape(
                form: Circle(r: 20),
                fill: Color.white
            )
            
            let icon = Text(
                text: item,
                font: Font(name: regularFont, size: 14),
                fill: Color.white,
                align: .mid,
                baseline: .mid
            )
            
            return Group(
                contents: [shape, icon],
                place: EmojisCircle.emojiPlace(index: index, d: 20.0),
                opacity: 0.0
            )
        }.group()

        super.init(contents: [emojis])
    }
    
    class func emojiPlace(index: Int, d: Double) -> Transform {
        let alpha = 2 * .pi / 10.0 * Double(index)
        return Transform.move(
            dx: cos(alpha) * d,
            dy: sin(alpha) * d
        )
    }
    
    func open(during: Double) -> Animation {
        return emojis.contents.enumerated().map { (index, node) in
            return [
                node.opacityVar.animation(to: 1.0, during: during),
                node.placeVar.animation(
                    to: EmojisCircle.emojiPlace(index: index, d: 120.0),
                    during: during
                )
            ].combine()
        }.combine()
    }
}

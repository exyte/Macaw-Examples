import Foundation
import Macaw

class Streak: Group {
        
    init(text: String, imageName: String, viewSize: Size, addTask: Bool) {
        let title = Text(
            text: text.uppercased(),
            font: Font(name: fontName, size: 14),
            fill: Color.white,
            align: .mid,
            place: Transform.move(
                dx: viewSize.w / 4,
                dy: 0.7 * viewSize.w / 2
            )
        )
        
        let sizes = [0.6, 0.6, 0.8].map { persentage in
            persentage * viewSize.w / 2
        }
        
        let contents: [[Group]] = [
            [ Logo(imageName: imageName, addTask: addTask, width: sizes[0]) ],
            [ Calendar(month: "January", width: sizes[1]) ],
            [ Statistics(width: sizes[2]) ]
        ]
        
        let streakContent = Group(contents: [])
        
        func updateStreak(index: Int) {
            let margin = viewSize.w / 2 - sizes[index]
            streakContent.contents = contents[index]
            streakContent.place = Transform.move(dx: margin / 2, dy: 0)
        }
        
        func animateStreak(index: Int) {
            let animation = streakContent.opacityVar.animation(to: 0.0, during: 0.1)
            animation.onComplete {
                updateStreak(index: index)
                streakContent.opacityVar.animation(to: 1.0, during: 0.1).play()
            }
            animation.play()
        }
        
        
        updateStreak(index: 0)
        super.init(contents: [streakContent, title])
        
        self.onTap { tapEvent in
            if !addTask {
                let index = contents.index { $0 == streakContent.contents }!
                animateStreak(index: (index + 1) % contents.count)
            }
        }

    }
}

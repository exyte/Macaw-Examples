import Macaw

open class RunningLevelView: MacawView {
    
    private var barAnimations = [Animation]()
    private var animations = [Animation]()
    private let barsValues = [70, 90, 50, 100, 70, 50, 20]
    private let barsCaptions = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private let barsCount = 7
    private let barsSpacing = 30
    private let barWidth = 10
    private let barHeight = 200
    
    private let emptyBarColor = Color.rgba(r: 138, g: 147, b: 219, a: 0.5)

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        let viewCenterX = Double(self.frame.width / 2)
        
        let barsWidth = Double((barWidth * barsCount) + (barsSpacing * (barsCount - 1)))
        let barsCenterX = viewCenterX - barsWidth / 2
        
        let text = Text(
            text: "Running Level",
            font: Font(name: "Serif", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        text.align = .mid
        text.place = .move(dx: viewCenterX, dy: 30)
        
        let backgroundGroup = Group()
        for barIndex in 0...barsCount - 1 {
            let barShape = Shape(
                form: RoundRect(
                    rect: Rect(
                        x: Double(barIndex * (barWidth + barsSpacing)),
                        y: 0,
                        w: Double(barWidth),
                        h: Double(barHeight)
                    ),
                    rx: 5,
                    ry: 5
                ),
                fill: emptyBarColor
            )
            backgroundGroup.contents.append(barShape)
        }
        
        let gradientColor = LinearGradient(degree: 90, from: Color(val: 0xfc0c7e), to: Color(val: 0xffd85e))
        
        let mainGroup = Group()
        for barIndex in 0...barsCount - 1 {
            let barShape = Shape(
                form: RoundRect(
                    rect: Rect(
                        x: Double(barIndex * (barWidth + barsSpacing)),
                        y: Double(barHeight),
                        w: Double(barWidth),
                        h: Double(0)
                    ),
                    rx: 5,
                    ry: 5
                ),
                fill: gradientColor
            )
            mainGroup.contents.append([barShape].group())
        }
        
        backgroundGroup.place = Transform.move(dx: barsCenterX, dy: 90)
        mainGroup.place = Transform.move(dx: barsCenterX, dy: 90)
        
        let captionsGroup = Group()
        captionsGroup.place = Transform.move(
            dx: barsCenterX,
            dy: 100 + Double(barHeight)
        )
        for barIndex in 0...barsCount - 1 {
            let text = Text(
                text: barsCaptions[barIndex],
                font: Font(name: "Serif", size: 14),
                fill: Color(val: 0xFFFFFF)
            )
            text.align = .mid
            text.place = .move(
                dx: Double((barIndex * (barWidth + barsSpacing)) + barWidth / 2),
                dy: 0
            )
            text.opacity = 0
            captionsGroup.contents.append(text)
        }
        
        self.node = [text, backgroundGroup, mainGroup, captionsGroup].group()
        
        
        for (index, node) in mainGroup.contents.enumerated() {
            if let group = node as? Group {
                if let captionText = captionsGroup.contents[index] as? Text {
                    animations.append(
                        captionText.opacityVar.animation(from: 0, to: 1, during: 0.1, delay: Double(index) * 0.2)
                    )
                }
                let heightValue = self.barHeight / 100 * barsValues[index]
                let animation = group.contentsVar.animation({ t in
                    let value = Double(heightValue) / 100 * (t * 100)
                    let barShape = Shape(
                        form: RoundRect(
                            rect: Rect(
                                x: Double(index * (self.barWidth + self.barsSpacing)),
                                y: Double(self.barHeight) - Double(value),
                                w: Double(self.barWidth),
                                h: Double(value)
                            ),
                            rx: 5,
                            ry: 5
                        ),
                        fill: gradientColor
                    )
                    return [barShape]
                }, during: 0.2, delay: 0).easing(Easing.easeInOut)
                barAnimations.append(animation)
            }
        }
        
    }
    
    open func play() {
        barAnimations.sequence().play()
        animations.forEach { $0.play() }
    }
    
}

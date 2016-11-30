import Macaw

open class TotalOfStepsView: MacawView {
    
    private var barsGroup = Group()
    private var captionsGroup = Group()
    
    private var animations = [Animation]()
    private let barsValues = [3, 4, 6, 10, 5]
    private let barsCaptions = ["2,265", "6,412", "8,972", "12,355", "7,773"]
    private let barsCount = 5
    private let barSegmentsCount = 10
    private let barsSpacing = 20
    private let segmentWidth = 40
    private let segmentHeight = 10
    private let segmentsSpacing = 10
    
    private let emptyBarSegmentColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.1)
    private let barSegmentColors = [
        0x359DDC,
        0x5984C7,
        0x5F81C5,
        0x796EB6,
        0xA3519E,
        0xB54493,
        0xC13C8D,
        0xBF3D8E,
        0xCC3385,
        0xE42479
    ].map {
        Color(val: $0)
    }
    
    private func createBars(centerX: Double, isEmpty: Bool) -> Group {
        let barsGroup = Group()
        barsGroup.place = Transform.move(dx: centerX, dy: 90)
        for barIndex in 0...barsCount - 1 {
            let barGroup = Group()
            barGroup.place = Transform.move(dx: Double((barsSpacing + segmentWidth) * barIndex), dy: 0)
            for segmentIndex in 0...barSegmentsCount - 1 {
                barGroup.contents.append(createSegment(segmentIndex: segmentIndex, isEmpty: isEmpty))
            }
            barGroup.contents.reverse()
            barsGroup.contents.append(barGroup)
        }
        return barsGroup
    }

    private func createSegment(segmentIndex: Int, isEmpty: Bool) -> Shape {
        return Shape(
            form: RoundRect(
                rect: Rect(
                    x: 0,
                    y: Double((segmentHeight + segmentsSpacing) * segmentIndex),
                    w: Double(segmentWidth),
                    h: Double(segmentHeight)
                ),
                rx: Double(segmentHeight),
                ry: Double(segmentHeight)
            ),
            fill: isEmpty ? emptyBarSegmentColor : barSegmentColors[segmentIndex],
            opacity: isEmpty ? 1 : 0
        )
    }
    
    private func createScene() {
        let viewCenterX = Double(self.frame.width / 2)
        
        let text = Text(
            text: "Total of Steps",
            font: Font(name: "Serif", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        text.align = .mid
        text.place = .move(dx: viewCenterX, dy: 30)
        
        let barsWidth = Double((segmentWidth * barsCount) + (barsSpacing * (barsCount - 1)))
        let barsCenterX = viewCenterX - barsWidth / 2
        
        let barsBackgroundGroup = createBars(centerX: barsCenterX, isEmpty: true)
        barsGroup = createBars(centerX: barsCenterX, isEmpty: false)
        
        captionsGroup = Group()
        captionsGroup.place = Transform.move(
            dx: barsCenterX,
            dy: 100 + Double((segmentHeight + segmentsSpacing) * barSegmentsCount)
        )
        for barIndex in 0...barsCount - 1 {
            let text = Text(
                text: barsCaptions[barIndex],
                font: Font(name: "Serif", size: 14),
                fill: Color(val: 0xFFFFFF)
            )
            text.align = .mid
            text.place = .move(dx: Double((barsSpacing + segmentWidth) * barIndex + (segmentWidth / 2)), dy: 0)
            text.opacity = 0
            captionsGroup.contents.append(text)
        }
        
        self.node = [text, barsGroup, barsBackgroundGroup, captionsGroup].group()
    }
    
    private func createAnimations() {
        animations.removeAll()
        barsGroup.contents.enumerated().forEach { nodeIndex, node in
            if let barGroup = node as? Group {
                if let captionText = captionsGroup.contents[nodeIndex] as? Text {
                    self.animations.append(
                        captionText.opacityVar.animation(from: 0, to: 1, during: 0.2, delay: Double(nodeIndex) * 0.1)
                    )
                }
                let barSize = self.barsValues[nodeIndex]
                barGroup.contents.enumerated().forEach { barNodeIndex, barNode in
                    if let segmentShape = barNode as? Shape, barNodeIndex <= barSize - 1 {
                        let delay = Double(barNodeIndex) * 0.05 + Double(nodeIndex) * 0.1
                        self.animations.append(
                            segmentShape.opacityVar.animation(from: 0, to: 1, during: 0.2, delay: delay)
                        )
                    }
                }
            }
        }
    }
    
    open func play() {
        createScene()
        createAnimations()
        animations.forEach {
            $0.play()
        }
    }
    
}

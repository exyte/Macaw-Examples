import UIKit
import Macaw

open class TotalStepsController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var macawView: MacawView?
    
    // MARK: Private Properties
    
    private let barsValues = [3, 4, 6, 10, 5]
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
    
    // MARK: Load
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let viewWidth = macawView?.bounds.width ?? 0
        let viewCenterX = Double(viewWidth / 2)
        
        let text = Text(
            text: "Total of steps",
            font: Font(name: "Serif", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        text.align = .mid
        text.place = .move(dx: viewCenterX, dy: 30)
        
        let barsWidth = Double((segmentWidth * barsCount) + (barsSpacing * (barsCount - 1)))
        let barsCenterX = viewCenterX - barsWidth / 2
        
        let barsBackgroundGroup = createBars(centerX: barsCenterX, isEmpty: true)
        let barsGroup = createBars(centerX: barsCenterX, isEmpty: false)
        
        macawView?.node = [text, barsGroup, barsBackgroundGroup].group()
        
        barsGroup.contents.enumerated().forEach { nodeIndex, node in
            if let barGroup = node as? Group {
                let barSize = self.barsValues[nodeIndex]
                barGroup.contents.enumerated().forEach { barNodeIndex, barNode in
                    if let segmentShape = barNode as? Shape, barNodeIndex <= barSize - 1 {
                        let delay = Double(barNodeIndex) * 0.05 + Double(nodeIndex) * 0.2
                        segmentShape.opacityVar.animation(from: 0, to: 1, during: 0.2, delay: delay).play()
                    }
                }
            }
        }
    }
    
    private func createBars(centerX: Double, isEmpty: Bool) -> Group {
        let barsGroup = Group()
        barsGroup.place = Transform.move(dx: centerX, dy: 90)
        for barIndex in 0...barsCount - 1 {
            let barGroup = Group()
            barGroup.place = Transform.move(dx: Double((barsSpacing + segmentWidth) * barIndex), dy: 0)
            for segmentIndex in 0...barSegmentsCount - 1 {
                let segmentShape = Shape(
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
                barGroup.contents.append(segmentShape)
            }
            barGroup.contents.reverse()
            barsGroup.contents.append(barGroup)
        }
        return barsGroup
    }
    
}

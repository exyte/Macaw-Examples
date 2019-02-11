import Macaw

open class BestScoreView: MacawView {
    
    private struct ScoreLine {
        
        let points: [(x: Double, y: Double)]
        let leftGradientColor: Int
        let rightGradientColor: Int
        
    }
    
    private var animationRect = Shape(form: Rect())
    
    private var animations = [Animation]()
    private var scoreLines = [ScoreLine]()
    private let cubicCurve = CubicCurveAlgorithm()
    private let chartWidth = 240
    private let chartHeight = 160
    private let milesCaptionWidth = 40
    private let backgroundLineSpacing = 20
    private let captionsX = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    private let captionsY = ["5 mi", "4 mi", "3 mi", "2 mi", "1 mi"]

    private func createScene() {
        scoreLines.append(
            ScoreLine(
                points: [
                    (x: 1.0, y: 50.0),
                    (x: 20.0, y: 60.0),
                    (x: 40.0, y: 80.0),
                    (x: 70.0, y: 50.0),
                    (x: 90.0, y: 70.0),
                    (x: 110.0, y: 10.0),
                    (x: 120.0, y: 60.0),
                    (x: 130.0, y: 60.0),
                    (x: 150.0, y: 90.0),
                    (x: 160.0, y: 100.0),
                    (x: 180.0, y: 70.0),
                    (x: 200.0, y: 80.0),
                    (x: 210.0, y: 50.0),
                    (x: 240.0, y: 30.0)
                ],
                leftGradientColor: 0xff7200,
                rightGradientColor: 0xffff86
            )
        )
        scoreLines.append(
            ScoreLine(
                points: [
                    (x: 1.0, y: 100.0),
                    (x: 10.0, y: 90.0),
                    (x: 20.0, y: 120.0),
                    (x: 40.0, y: 90.0),
                    (x: 60.0, y: 85.0),
                    (x: 80.0, y: 90.0),
                    (x: 100.0, y: 90.0),
                    (x: 130.0, y: 70.0),
                    (x: 160.0, y: 60.0),
                    (x: 180.0, y: 100.0),
                    (x: 200.0, y: 30.0),
                    (x: 220.0, y: 90.0),
                    (x: 230.0, y: 100.0),
                    (x: 240.0, y: 80.0)
                ],
                leftGradientColor: 0x10ffff,
                rightGradientColor: 0xbbccff
            )
        )
        scoreLines.append(
            ScoreLine(
                points: [
                    (x: 1.0, y: 140.0),
                    (x: 10.0, y: 135.0),
                    (x: 30.0, y: 125.0),
                    (x: 50.0, y: 140.0),
                    (x: 70.0, y: 115.0),
                    (x: 80.0, y: 130.0),
                    (x: 90.0, y: 125.0),
                    (x: 120.0, y: 130.0),
                    (x: 140.0, y: 140.0),
                    (x: 160.0, y: 120.0),
                    (x: 180.0, y: 140.0),
                    (x: 200.0, y: 110.0),
                    (x: 220.0, y: 120.0),
                    (x: 240.0, y: 110.0)
                ],
                leftGradientColor: 0xff9e21,
                rightGradientColor: 0xeb0f67
            )
        )
        
        let chartLinesGroup = Group()
        chartLinesGroup.place = Transform.move(dx: Double(milesCaptionWidth), dy: 0)
        scoreLines.forEach { scoreLine in
            let dataPoints = scoreLine.points.map { CGPoint(x: $0.x, y: $0.y) }
            let controlPoints = self.cubicCurve.controlPointsFromPoints(dataPoints: dataPoints)
            var path: PathBuilder = MoveTo(x: scoreLine.points[0].x, y: scoreLine.points[0].y)
            for index in 0...dataPoints.count - 2 {
                path = path.cubicTo(
                    x1: Double(controlPoints[index].controlPoint1.x),
                    y1: Double(controlPoints[index].controlPoint1.y),
                    x2: Double(controlPoints[index].controlPoint2.x),
                    y2: Double(controlPoints[index].controlPoint2.y),
                    x: Double(dataPoints[index + 1].x),
                    y: Double(dataPoints[index + 1].y)
                )
            }
            let shape = Shape(
                form: path.build(),
                stroke: Stroke(
                    fill: LinearGradient(degree: 0, from: Color(val: scoreLine.leftGradientColor), to: Color(val: scoreLine.rightGradientColor)),
                    width: 2
                )
            )
            chartLinesGroup.contents.append(shape)
        }
        
        animationRect = Shape(
            form: Rect(x: 0, y: 0, w: Double(chartWidth + 1), h: Double(chartHeight + backgroundLineSpacing)),
            fill: Color(val: 0x4a2e7d)
        )
        chartLinesGroup.contents.append(animationRect)
        let lineColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.1)
        let captionColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.5)
        var captionIndex = 0
        for index in 0...chartWidth / backgroundLineSpacing {
            let x = Double(backgroundLineSpacing * index)
            let y2 = index % 2 == 0 ? Double(chartHeight + backgroundLineSpacing) : Double(chartHeight)
            chartLinesGroup.contents.append(
                Line(
                    x1: x,
                    y1: 0,
                    x2: x,
                    y2: y2
                ).stroke(fill: lineColor)
            )
            if index % 2 == 0 {
                let text = Text(
                    text: captionsX[captionIndex],
                    font: Font(name: "Serif", size: 14),
                    fill: captionColor
                )
                text.align = .mid
                text.place = .move(
                    dx: x,
                    dy: y2 + 10
                )
                text.opacity = 1
                chartLinesGroup.contents.append(text)
                captionIndex += 1
            }
        }
        
        let milesCaptionGroup = Group()
        for index in 0...chartHeight / (backgroundLineSpacing * 2) {
            let text = Text(
                text: captionsY[index],
                font: Font(name: "Serif", size: 14),
                fill: captionColor
            )
            text.place = .move(
                dx: 0,
                dy: Double((backgroundLineSpacing * 2) * index)
            )
            text.opacity = 1
            milesCaptionGroup.contents.append(text)
        }
        
        let viewCenterX = Double(self.frame.width / 2)
        let chartCenterX = viewCenterX - (Double(chartWidth / 2) + Double(milesCaptionWidth / 2))
        
        let text = Text(
            text: "Best Score",
            font: Font(name: "Serif", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        text.align = .mid
        text.place = .move(dx: viewCenterX, dy: 30)
        
        let chartGroup = [chartLinesGroup, milesCaptionGroup].group(place: Transform.move(dx: chartCenterX, dy: 90))
        self.node = [text, chartGroup].group()
        self.backgroundColor = UIColor(cgColor: Color(val: 0x4a2e7d).toCG())
    }
    
    private func createAnimations() {
        animations.removeAll()
        animations.append(
            animationRect.placeVar.animation(to: Transform.move(dx: Double(self.frame.width), dy: 0), during: 2)
        )
    }
    
    open func play() {
        createScene()
        createAnimations()
        animations.forEach {
            $0.play()
        }
    }
    
}

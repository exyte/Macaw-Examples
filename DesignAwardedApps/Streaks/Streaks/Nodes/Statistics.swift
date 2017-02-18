import Foundation
import Macaw

class Statistics: Group {
    
    init(width: Double) {
        let shape = Shape(form: Rect(x: 0, y: 0, w: width, h: 110), fill: background)
        super.init(contents: [shape, [
            ("Streak 1", "Best 12", 1.0),
            ("Last 7 days", "26%", 0.26),
            ("Last 30 days", "64%", 0.64)
            ].enumerated().map { (index, element) in
                let barNode = Bar(width: width,
                                  leftText: element.0,
                                  rightText: element.1,
                                  percentage: element.2
                )
                barNode.place = Transform.move(dx: 0, dy: Double(index) * 38.0)
                return barNode
            }.group()]
        )
    }
}

class Bar: Group {
    init(width: Double, leftText: String, rightText: String, percentage: Double) {
        super.init(contents: [
                Text(
                    text: leftText.uppercased(),
                    font: Font(name: fontName, size: 12),
                    fill: Color.white,
                    align: .min
                ), Text(
                    text: rightText.uppercased(),
                    font: Font(name: fontName, size: 12),
                    fill: lightColor,
                    align: .max,
                    place: Transform.move(dx: width, dy: 0)
                ), Shape(
                    form: Rect(x: 0, y: 18, w: width, h: 10).round(r: 2),
                    fill: lightColor
                ), Shape(
                    form: Rect(x: 0, y: 18, w: width * percentage, h: 10).round(r: 2.0),
                    fill: Color.white
                )
            ]
        )
    }
}

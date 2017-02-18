import Foundation
import Macaw

class Calendar: Group {
    init(month: String, width: Double) {
        let tooLightColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.2)
        let doneColor = Color.rgb(r: 255, g: 255, b: 255)
        
        let monthText = Text(
            text: month.uppercased(),
            font: Font(name: fontName, size: 10),
            fill: lightColor,
            align: .mid,
            place: Transform.move(dx: width / 2, dy: 0)
        )
        let calendarGroup = Group(contents: [], place: Transform.move(dx: 0, dy: 20))
        let dates = ["S", "M", "T", "W", "T", "F", "S"]
        
        for row in 0...4 {
            for column in 0...6 {
                let x = width / 6 * Double(column)
                let y = Double(row) * 15
                
                let random = Int(arc4random_uniform(10))
                
                if row == 0 {
                    let headerText = Text(
                        text: dates[column],
                        font: Font(name: fontName, size: 10),
                        fill: lightColor,
                        align: .mid,
                        place: Transform.move(dx: x, dy: y)
                    )
                    calendarGroup.contents.append(headerText)
                } else if random > 3 && random < 5 {
                    let line1 = Line(x1: x - 4, y1: y, x2: x + 4, y2: y + 8)
                    let line2 = Line(x1: x - 4, y1: y + 8, x2: x + 4, y2: y)
                    let stroke = Stroke(fill: Color(val: 0x744641), width: 4)
                    calendarGroup.contents.append(Shape(form: line1, stroke: stroke))
                    calendarGroup.contents.append(Shape(form: line2, stroke: stroke))
                } else {
                    var circleColor = lightColor
                    if row == 4 && column > 3 {
                        circleColor = tooLightColor
                    } else if random < 3 {
                        circleColor = doneColor
                    }
                    let shape = Shape(
                        form: Circle(cx: x, cy: y + 4, r: 4),
                        fill: circleColor
                    )
                    calendarGroup.contents.append(shape)
                }
            }
        }
        let shape = Shape(form: Rect(x: 0, y: 0, w: width, h: 90), fill: background)
        super.init(contents: [shape, monthText, calendarGroup])
    }
}

import Foundation
import Macaw

class StreaksView: MacawView {
    
    let background = Color.rgb(r: 255, g: 112, b: 76)
    let lightColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.5)
    
    let screen = UIScreen.main.bounds
    let fontName = "Helvetica-Bold"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: Group(contents: []), coder: aDecoder)
        self.backgroundColor = UIColor(red: 1.0, green: 0.43, blue: 0.29, alpha: 1)
        self.node = streaks()
    }
    
    func streaks() -> Node {
        return [
                ("Medium post", "streaks-M"),
                ("Take a photo", "streaks-camera"),
                ("Cycle 5 km", "streaks-bike"),
                ("Brush your teeth", "streaks-tooth"),
                ("Practice guitar", "streaks-guitar"),
                ("Add a task", "streaks-plus")
            ].enumerated().map { (index, element) in
                let radius = 0.6 * Double(screen.width / 4)
                
                let streakObj = Group(contents: [streak(text: element.0, imageName: element.1, radius: radius)])
//                let streakObj = Group(contents: [statistics()])
//                let streakObj = Group(contents: [calendar(month: "January")])
                streakObj.place = Transform.move(
                    dx: Double(screen.width / 2) * Double(index % 2) ,
                    dy: 30 + Double(Int(index / 2) * Int(screen.width / 2))
                )
                return streakObj
            }.group()
    }
    
    func streak(text: String, imageName: String, radius: Double) -> Group {
        let streakEllipse = Ellipse(cx: radius, cy: radius, rx: radius, ry: radius)
        
        let streakBorder = Shape(
            form: Arc(ellipse: streakEllipse, extent: 2 * M_PI),
            fill: background,
            stroke: Stroke(fill: Color(val: 0x744641), width: 8)
        )
        
        let streakTitle = Text(
            text: text.uppercased(),
            font: Font(name: fontName, size: 14),
            fill: Color.white,
            align: .mid,
            place: Transform.move(
                dx: radius,
                dy: 2 * radius + 20
            )
        )
        
        let image = UIImage(named: imageName)!
        let streakImage = Image(
            src: imageName,
            place: Transform.move(
                dx: radius - Double(image.size.width) / 2,
                dy: radius - Double(image.size.height) / 2
            )
        )
        
        let animationGroup = Group(contents: [])
        let streakGroup = Group(contents: [streakBorder, streakImage, animationGroup])
        
        streakGroup.onTap { tapEvent in
            animationGroup.contents = []
            animationGroup.opacity = 1.0
            self.animate(group: animationGroup, ellipse: streakEllipse)
        }
        
        let streak = Group(contents: [streakGroup, streakTitle])
        streak.place = Transform.move(dx: Double(screen.width / 4) - radius, dy: 0)
        return streak
    }
    
    func animate(group: Group, ellipse: Ellipse) {
        let mainAnimation = group.contentsVar.animation({ t in
            let animatedShape = Shape(
                form: Arc(
                    ellipse: ellipse,
                    shift: 1.5 * M_PI,
                    extent: 2 * M_PI * t
                ),
                stroke: Stroke(
                    fill: Color.white,
                    width: 8
                )
            )
            return [animatedShape]
        }, during: 0.5).easing(Easing.easeInOut)
        
        let opacityAnimation = group.opacityVar.animation(to: 0.0, during: 0.5)
        
        let animation = [mainAnimation, opacityAnimation].sequence()
        animation.play()
    }
    
    func statistics() -> Group {
        let width = Double(screen.width) / 2 * 0.8
        
        let barsGroup = [
            ("Streak 1", "Best 12", 1.0),
            ("Last 7 days", "26%", 0.26),
            ("Last 30 days", "64%", 0.64)
        ].enumerated().map { (index, element) in
            let barNode = bar(width: width,
                leftText: element.0,
                rightText: element.1,
                percentage: element.2
            )
            barNode.place = Transform.move(dx: 0, dy: Double(index) * 38.0)
            return barNode
        }.group()
        barsGroup.place = Transform.move(dx: Double(screen.width) / 2 * 0.1, dy: 0)
        return barsGroup
    }
    
    func bar(width: Double, leftText: String, rightText: String, percentage: Double) -> Node {
        return Group(
            contents: [
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
    
    func calendar(month: String) -> Group {
        let tooLightColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.2)
        let doneColor = Color.rgb(r: 255, g: 255, b: 255)

        let width = Double(screen.width) / 2 * 0.6
        let margin = (Double(screen.width) / 2  - width) / 2
        
        let monthText = Text(
            text: month.uppercased(),
            font: Font(name: fontName, size: 10),
            fill: lightColor,
            align: .mid,
            place: Transform.move(dx: Double(screen.width) / 4, dy: 0)
        )
        let calendarGroup = Group(contents: [], place: Transform.move(dx: margin, dy: 20))
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
        return Group(contents: [monthText, calendarGroup])
    }
}

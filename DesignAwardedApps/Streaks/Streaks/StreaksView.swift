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
            let streak = self.streak(text: element.0, imageName: element.1, addTask: index == 5)
            return Group(
                contents: [streak],
                place: Transform.move(
                    dx: Double(screen.width / 2) * Double(index % 2),
                    dy: 30 + Double(Int(index / 2) * Int(screen.width / 2))
                )
            )
        }.group()
    }
    
    func streak(text: String, imageName: String, addTask: Bool = false) -> Group {
        let title = Text(
            text: text.uppercased(),
            font: Font(name: fontName, size: 14),
            fill: Color.white,
            align: .mid,
            place: Transform.move(
                dx: Double(screen.width) / 4,
                dy: 0.7 * Double(screen.width) / 2
            )
        )
        
        let sizes = [0.6, 0.6, 0.8].map { persentage in
            persentage * Double(screen.width) / 2
        }
        
        let contents = [
            [ logo(imageName: imageName, addTask: addTask, width: sizes[0]) ],
            [ calendar(month: "January", width: sizes[1]) ],
            [ statistics(width: sizes[2]) ]
        ]
        
        let streakContent = Group(contents: [])
        let streak = Group(contents: [streakContent, title])
        
        func updateStreak(index: Int) {
            let margin = Double(screen.width) / 2 - sizes[index]
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
        
        streak.onTap { tapEvent in
            if !addTask {
                let index = contents.index { $0 == streakContent.contents }!
                animateStreak(index: (index + 1) % contents.count)
            }
        }
        
        updateStreak(index: 0)
        return streak
    }
    
    func logo(imageName: String, addTask: Bool, width: Double) -> Group {
        let radius = width / 2
        let ellipse = Ellipse(cx: radius, cy: radius, rx: radius, ry: radius)
        
        let border = Shape(
            form: Arc(ellipse: ellipse, extent: 2 * M_PI),
            fill: background,
            stroke: Stroke(fill: Color(val: 0x744641), width: 8)
        )
        
        let image = UIImage(named: imageName)!
        let logoImage = Image(
            src: imageName,
            place: Transform.move(
                dx: radius - Double(image.size.width) / 2,
                dy: radius - Double(image.size.height) / 2
            )
        )
        
        let animationGroup = Group(contents: [])
        let logoGroup = [border, logoImage].group()
        
        logoGroup.onTap { tapEvent in
            if addTask {
                self.addTaskAnimation(group: animationGroup, ellipse: ellipse)
            }
        }
        
        return [logoGroup, animationGroup].group()
    }
    
    func addTaskAnimation(group: Group, ellipse: Ellipse) {
        group.contents = []
        group.opacity = 1.0

        let animation = group.contentsVar.animation({ t in
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

        animation.onComplete {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AddTaskController")
            let topViewController = UIApplication.shared.delegate?.window??.rootViewController
            topViewController?.present(vc, animated: true, completion: nil)
            group.opacity = 0.0
        }
        animation.play()
    }
    
    func statistics(width: Double) -> Group {
        let shape = Shape(form: Rect(x: 0, y: 0, w: width, h: 110), fill: background)
        return Group(contents: [shape, [
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
            }.group()]
        )
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
    
    func calendar(month: String, width: Double) -> Group {
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
        return [shape, monthText, calendarGroup].group()
    }
}

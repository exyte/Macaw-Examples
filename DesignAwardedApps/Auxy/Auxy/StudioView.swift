import Foundation
import Macaw

class StudioView: MacawView {
    
    let screen = UIScreen.main.bounds
    let columns = 8
    let rows = 16
    
    var viewSize: Size!
    var cellSize: Size!
    
    var soundsMap = [Point:Node]()
        
    required init?(coder aDecoder: NSCoder) {
        super.init(node: Group(contents: []), coder: aDecoder)
        
        viewSize = Size(
            w: Double(self.bounds.width),
            h: Double(self.bounds.height)
        )
        
        cellSize = Size(
            w: viewSize.w / Double(columns),
            h: viewSize.h / Double(rows)
        )
        
        let background = Shape(
            form: Rect(w: viewSize.w, h: viewSize.h),
            fill: Color.rgb(r: 46, g: 48, b: 58)
        )
        
        let play = playButton()
        
        let sounds = Group(contents: [], opaque: false)
        self.node = [background, sounds, grid(), play].group()
        
        background.onTap { tapEvent in
            let position = self.getPosition(location: tapEvent.location)
            
            if let sound = self.soundsMap[position] {
                sounds.contents.remove(at: sounds.contents.index{$0 === sound}!)
                self.soundsMap.removeValue(forKey: position)
            } else {
                self.addSound(position: position, sounds: sounds)
            }
        }
        
        background.onPan { panEvent in
//            let position = self.getPosition(location: panEvent.location)
//            if let sound = self.soundsMap[position] {
//                let newPos = sound.pos.move(
//                    Double(panEvent.dx),
//                    my: Double(panEvent.dy)
//                )
//                sound.pos = newPos
//            }
        }
    }
    
    func addSound(position: Point, sounds: Group) {
        let sound = Shape(
            form: Rect(
                x: position.x * cellSize.w,
                y: position.y * cellSize.h,
                w: cellSize.w,
                h: cellSize.h
            ),
            fill: Color.rgb(r: 4, g: 112, b: 215)
        )
        self.soundsMap[position] = sound
        sounds.contents.append(sound)
    }
    
    func getPosition(location: Point) -> Point {
        return Point(
            x: floor(location.x / cellSize.w),
            y: floor(location.y / cellSize.h)
        )
    }
    
    func grid() -> Node {
        let stroke = Stroke(fill: Color.black, width: 1.0)

        return Group(contents: [
            Array(0..<rows).map { row in
                let y = cellSize.h * Double(row)
                return Shape(
                    form: Line(x1: 0, y1: y, x2: viewSize.w, y2: y),
                    stroke: stroke,
                    opacity: row % 4 == 0 ? 1 : 0.2
                )
            }.group(),
            Array(0..<columns).map { column in
                let x = cellSize.w * Double(column)
                return Shape(
                    form: Line(x1: x, y1: 0, x2: x, y2: viewSize.h),
                    stroke: stroke,
                    opacity: 0.2
                )
            }.group()
        ], opaque: false)
    }
    
    func playButton() -> Node {
        let сolor = Color.rgb(r: 219, g: 222, b: 227)
        let pressedColor = Color.rgb(r: 111, g: 112, b: 114)
        
        let border = Shape(
            form: Arc(
                ellipse: Ellipse(rx: 28.0, ry: 28.0),
                shift: -M_PI / 2 + 0.05,
                extent: 2 * M_PI - 0.1
            ),
            stroke: Stroke(
                fill: Color.rgba(r: 219, g: 222, b: 227, a: 0.3),
                width: 2.0
            )
        )
        
        let shape = Shape(
            form: Circle(r: 25.0),
            fill: сolor
        )
        
        let animationGroup = Group(contents: [])
        
        let playButton = Shape(
            form: MoveTo(x: -1, y: 2).lineTo(x: 2, y: 0)
                .lineTo(x: -1, y: -2).close().build(),
            fill: Color.rgb(r: 46, g: 48, b: 58),
            place: Transform.scale(sx: 5.0, sy: 5.0)
        )
        
        let stopButton = Shape(
            form: MoveTo(x: -2, y: 2).lineTo(x: 2, y: 2)
                .lineTo(x: 2, y: -2).lineTo(x: -2, y: -2).close().build(),
            fill: Color.rgb(r: 46, g: 48, b: 58),
            place: Transform.scale(sx: 4.0, sy: 4.0)
        )
        
        let buttons = [[playButton], [stopButton]]
        let buttonGroup = Group(
            contents: buttons[0]
        )

        let group = Group(
            contents: [border, shape, animationGroup, buttonGroup],
            place: Transform.move(dx: viewSize.w / 2, dy: viewSize.h - 50)
        )
        
        let line = Shape(
            form: Line(
                x1: 0, y1: -2,
                x2: self.viewSize.w, y2: -2
            ),
            stroke: Stroke(fill: Color.rgb(r: 219, g: 222, b: 227), width: 3.0)
        )
        
        let lineAnimation = line.placeVar.animation(to: Transform.move(dx: 0, dy: viewSize.h), during: 3.0).easing(Easing.linear).cycle()
        
        let playAnimation = self.playMusic(group: animationGroup, timeRadius: 28.0)
        
        group.onTouch { touchEvent in
            switch touchEvent.state {
            case .began:
                shape.fill = pressedColor
                break
            case .moved:
                break
            case .ended:
                shape.fill = сolor
                let index = buttons.index { $0 == buttonGroup.contents }!
                buttonGroup.contents = buttons[(index + 1) % buttons.count]
                
                animationGroup.contents = []
                animationGroup.opacity = 1.0
                
                if index == 0 {
                    playAnimation.play()
                    lineAnimation.play()
                } else {
                    playAnimation.stop()
                    lineAnimation.stop()
                    animationGroup.opacityVar.animation(to: 0.0, during: 0.1).play()
                    line.place = Transform.move(dx: 0, dy: 0)
                }
                break
            }
        }

        return [line, group].group()
    }
    
    func playMusic(group: Group, timeRadius: Double) -> Animation {
        return group.contentsVar.animation({ t in
            let shape = Shape(
                form: Arc(
                    ellipse: Ellipse(rx: timeRadius, ry: timeRadius),
                    shift: -M_PI / 2,
                    extent: 2 * M_PI * t
                ),
                stroke: Stroke(fill: Color.white, width: 2)
            )
            return [shape]
        }, during: 3.0).cycle()
    }
}

extension Point: Hashable, Equatable {
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public var hashValue: Int {
        return x.hashValue << 32 ^ y.hashValue
    }
}

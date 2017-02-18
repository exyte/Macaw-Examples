import Foundation
import Macaw

class StudioView: MacawView {
    
    let screen = UIScreen.main.bounds
    let columns = 8
    let rows = 16
    
    var viewSize: Size!
    var cellSize: Size!
    
    var soundsMap = [Point:Sound]()
        
    required init?(coder aDecoder: NSCoder) {
        super.init(node: Group(contents: []), coder: aDecoder)
        
        viewSize = Size(
            w: Double(UIScreen.main.bounds.width),
            h: Double(UIScreen.main.bounds.height)
        )
        
        cellSize = Size(
            w: viewSize.w / Double(columns),
            h: viewSize.h / Double(rows)
        )
        
        let background = Shape(
            form: Rect(w: viewSize.w, h: viewSize.h),
            fill: Color.rgb(r: 46, g: 48, b: 58)
        )
        
        let sounds = Group(contents: [], opaque: false)
        
        let grid = Grid(
            dimension: (columns, rows),
            cell: cellSize,
            size: viewSize
        )
        
        self.node = [background, sounds, grid, playButton()].group()
        
        background.onTap { tapEvent in
            let position = self.getPosition(location: tapEvent.location)
            
            if let sound = self.soundsMap[position] {
                sounds.contents.remove(at: sounds.contents.index{$0 === sound}!)
                self.soundsMap.removeValue(forKey: position)
            } else {
                let sound = Sound(position: position, size: self.cellSize)
                self.soundsMap[position] = sound
                sounds.contents.append(sound)
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
    
    func playButton() -> Node {                
        let time = 3.0
        let button = PlayButton(time: time)
        button.place = Transform.move(dx: viewSize.w / 2, dy: viewSize.h * 0.85)
        
        let runner = LineRunner(size: viewSize)
        
        button.onPlay = {
            runner.run(sounds: self.soundsMap, time: time)
        }
        
        button.onStop = {
            runner.stop()
        }
        
        return [runner, button].group()
    }
    
    func getPosition(location: Point) -> Point {
        return Point(
            x: floor(location.x / cellSize.w),
            y: floor(location.y / cellSize.h)
        )
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

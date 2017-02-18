import Foundation
import Macaw

class StreaksView: MacawView {

    var viewSize: Size!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: Group(contents: []), coder: aDecoder)
        self.backgroundColor = UIColor(red: 1.0, green: 0.43, blue: 0.29, alpha: 1)
        self.viewSize = Size(
            w: Double(UIScreen.main.bounds.width),
            h: Double(UIScreen.main.bounds.height)
        )
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
            let streak = Streak(
                text: element.0,
                imageName: element.1,
                viewSize: viewSize,
                addTask: index == 5
            )
            return Group(
                contents: [streak],
                place: Transform.move(
                    dx: viewSize.w / 2 * Double(index % 2),
                    dy: 30 + Double(Int(index / 2) * Int(viewSize.w / 2))
                )
            )
        }.group()
    }
}

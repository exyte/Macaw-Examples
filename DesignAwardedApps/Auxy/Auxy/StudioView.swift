import Foundation
import Macaw

class StudioView: MacawView {
    
    let screen = UIScreen.main.bounds
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: Group(contents: []), coder: aDecoder)
    }
}

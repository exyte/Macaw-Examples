import Foundation
import Macaw

class Logo: Group {
    
    init(imageName: String, addTask: Bool, width: Double) {
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
        super.init(contents: [logoGroup, animationGroup])
        
        logoGroup.onTap { tapEvent in
            if addTask {
                self.addTaskAnimation(group: animationGroup, ellipse: ellipse)
            }
        }
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

}

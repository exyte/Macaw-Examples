import Foundation
import Macaw

class ActivityView: MacawView {
    var viewSize: Size!
    
    var texts: Group!
    var circle: ActivityCircle!
    var bar: ActivityBar!
    
    required init?(coder aDecoder: NSCoder) {
        viewSize = Size(
            w: Double(UIScreen.main.bounds.width),
            h: Double(UIScreen.main.bounds.height)
        )
        
        texts = [
            Text(
                text: "Current Score",
                font: Font(name: boldFont, size: 24),
                fill: Color.white,
                align: .min,
                place: Transform.move(dx: 20.0, dy: 105.0)
            ),
            Text(
                text: "Your activity is up since last week",
                font: Font(name: regularFont, size: 16),
                fill: Color.white,
                align: .min,
                place: Transform.move(dx: 20.0, dy: 145.0)
            )
            ].group()
        
        circle = ActivityCircle()
        circle.place = Transform.move(dx: viewSize.w / 2, dy: viewSize.h / 2)
        
        bar = ActivityBar()
        bar.place = Transform.move(dx: 20.0, dy: viewSize.h - 160.0)

        
        super.init(node: Group(contents: [texts, circle, bar]), coder: aDecoder)
    }
    
    var customizeAnimation: Animation?
    
    func customize() {
        bar.stopJumping()
        
        let during = 0.5
        
        let hideNodes = [
            bar.opacityVar.animation(to: 0.0, during: during),
            texts.opacityVar.animation(to: 0.0, during: during)
        ].combine()
        
        let circleAnimation = circle.customize(during: during)
        
        customizeAnimation = [
            hideNodes,
            circleAnimation
        ].combine()
        
        customizeAnimation?.play()
    }
    
    func done() {
        customizeAnimation?.reverse().play()
        bar.jump()
    }
}

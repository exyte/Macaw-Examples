//
//  MyView.swift
//  GettingStarted
//
//  Created by Yuri Strot on 11/9/16.
//  Copyright © 2016 Exyte. All rights reserved.
//

import Macaw

class MyView: MacawView {
    
    static let data: [Double] = [101, 142, 66, 178, 92]
    static let palette = [0xf08c00, 0xbf1a04, 0xffd505, 0x8fcc16, 0xd1aae3].map { val in Color(val: val)}
    
    required init?(coder aDecoder: NSCoder) {
        let button = MyView.createButton()
        let chart = MyView.createChart(button.contents[0])
        super.init(node: Group(contents: [button, chart]), coder: aDecoder)
    }
    
    private static func createButton() -> Group {
        let shape = Shape(
            form: Rect(x: -100, y: -15, w: 200, h: 30).round(r: 5),
            fill: LinearGradient(degree: 90, from: Color(val: 0xfcc07c), to: Color(val: 0xfc7600)),
            stroke: Stroke(fill: Color(val: 0xff9e4f), width: 1))
        
        let text = Text(
            text: "Show", font: Font(name: "Serif", size: 21),
            fill: Color.white, align: .mid, baseline: .mid,
            place: .move(dx: 15, dy: 0), opaque: false)
        
        let image = Image(src: "charts.png", w: 30, place: .move(dx: -40, dy: -15), opaque: false)
        let dx = UIScreen.main.bounds.width / 2

        return Group(contents: [shape, text, image], place: .move(dx: Double(dx), dy: 75))
    }
    
    private static func createChart(_ button: Node) -> Group {
        var items: [Node] = []
        for i in 1...6 {
            let y = 200 - Double(i) * 30.0
            items.append(Line(x1: -5, y1: y, x2: 275, y2: y).stroke(fill: Color(val: 0xF0F0F0)))
            items.append(Text(text: "\(i*30)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y)))
        }
        items.append(createBars(button))
        items.append(Line(x1: 0, y1: 200, x2: 275, y2: 200).stroke())
        items.append(Line(x1: 0, y1: 0, x2: 0, y2: 200).stroke())
        return Group(contents: items, place: .move(dx: 50, dy: 200))
    }
    
    private static func createBars(_ button: Node) -> Group {
        var items: [Node] = []
        var animations: [Animation] = []
        for (i, item) in data.enumerated() {
            let bar = Shape(
                form: Rect(x: Double(i) * 50 + 25, y: 0, w: 30, h: item),
                fill: LinearGradient(degree: 90, from: palette[i], to: palette[i].with(a: 0.3)),
                place: .scale(sx: 1, sy: 0))
            items.append(bar)
            animations.append(bar.placeVar.animation(to: .move(dx: 0, dy: -data[i]), delay: Double(i) * 0.1))
        }
        _ = button.onTap { _ in animations.combine().play() }
        return Group(contents: items, place: .move(dx: 0, dy: 200))
    }
}

//
//  BaseViewController.swift
//  Animations
//
//  Created by Alisa Mylnikova on 08/08/2018.
//  Copyright © 2018 Exyte. All rights reserved.
//

import Macaw

class BaseViewController: UIViewController {
    
    var svgView: SVGView!
    var animation: Animation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navbarHeight = navigationController!.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        svgView = SVGView(frame: CGRect(x: 0, y: navbarHeight, width: view.frame.width, height: view.frame.height - navbarHeight))
        svgView.backgroundColor = .white
        svgView.contentLayout = .none
        view.addSubview(svgView)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let animation = animation {
            animation.stop()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let animation = animation {
            animation.play()
        }
    }

}

func createMovingRect(easing: Easing, rect: Rect, place: Transform, distance: Double = 200.0, distortion: Double = 10.0, radius: Double = 5.0, delay: Double = 0.5, during: Double = 1.0) -> (Node, Animation) {
    let g = Group(contents: [Shape(form: RoundRect(rect: rect, rx: radius, ry: radius), fill: color)], place: place)
    let there = g.contentsVar.animation( { (t) -> [Node] in
        return [Shape(form: createRightDistortedRoundedRectBothways(parameter: t, distortion: distortion, width: rect.w, height: rect.h), fill: color, place: .move(dx: t * distance, dy: 0))]
    }, during: during, delay: delay).easing(easing)
    let back = g.contentsVar.animation( { (t) -> [Node] in
        return [Shape(form: createLeftDistortedRoundedRectBothways(parameter: t, distortion: distortion, width: rect.w, height: rect.h), fill: color, place: .move(dx: distance + t * -distance, dy: 0))]
    }, during: during, delay: delay).easing(easing)
    return (g, [there, back].sequence())
}

func createRightDistortedRoundedRectBothways(parameter: Double = 1.0, distortion: Double = 10.0, radius: Double = 5.0, width: Double = 60.0, height: Double = 0.0) -> Path {
    let t = parameter < 0.5 ? 2 * parameter : 2 - 2 * parameter
    let height = height == 0 ? width : height
    return createRightDistortedRoundedRect(parameter: t, distortion: distortion, radius: radius, width: width, height: height)
}

func createLeftDistortedRoundedRectBothways(parameter: Double = 1.0, distortion: Double = 10.0, radius: Double = 5.0, width: Double = 60.0, height: Double = 0.0) -> Path {
    let t = parameter < 0.5 ? 2 * parameter : 2 - 2 * parameter
    let height = height == 0 ? width : height
    return createLeftDistortedRoundedRect(parameter: t, distortion: distortion, radius: radius, width: width, height: height)
}

func createRightDistortedRoundedRect(parameter: Double = 1.0, distortion: Double = 20.0, radius: Double = 5.0, width: Double = 60.0, height: Double = 0.0) -> Path {
    let width = width - 2 * radius
    let height = height - 2 * radius
    return MoveTo(x: radius, y: 0)
        .l(width, 0)
        .q(radius - parameter, 0, radius + parameter, radius)
        .q(distortion * parameter, height/2, 0, height)
        .q(-parameter, radius, -radius + parameter, radius)
        .l(-width, 0)
        .q(-radius - parameter, 0, -radius + parameter, -radius)
        .q(distortion/2 * parameter, -height/2, 0, -height)
        .q(-parameter, -radius, radius + parameter, -radius)
        .build()
}

func createLeftDistortedRoundedRect(parameter: Double = 1.0, distortion: Double = 20.0, radius: Double = 5.0, width: Double = 60.0, height: Double = 0.0) -> Path {
    let width = width - 2 * radius
    let height = height - 2 * radius
    return MoveTo(x: radius, y: 0)
        .l(width, 0)
        .q(radius + parameter, 0, radius - parameter, radius)
        .q(-distortion/2 * parameter, height/2, 0, height)
        .q(parameter, radius, -radius - parameter, radius)
        .l(-width, 0)
        .q(-radius + parameter, 0, -radius - parameter, -radius)
        .q(-distortion * parameter, -height/2, 0, -height)
        .q(parameter, -radius, radius - parameter, -radius)
        .build()
}

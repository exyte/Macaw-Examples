//
//  Wave.swift
//  LiquidSwipe
//
//  Created by Yuri Strot on 3/20/19.
//  Copyright © 2019 Exyte. All rights reserved.
//

import Foundation
import Macaw

class Wave {

    let color: Color
    let size: Size
    let left: Bool
    let node = Group()

    init(color: Color, size: Size, left: Bool, ry: Double) {
        self.color = color
        self.size = size
        self.left = left
        node.contentsVar.animate(during: 0.2) { t in
            let side = self.adjust(from: 0, to: 15, p: t)
            let hr = self.adjust(from: 0, to: 48, p: t)
            let vr = self.adjust(from: 0, to: 82, p: t)
            return [self.build(cy: size.h * ry, hr: hr, vr: vr, side: side, opacity: 1)]
        }
    }

    func drag(y: Double, dx: Double) {
        let progress = getProgress(size: size, dx: dx)
        node.contents = [build(cy: y, p: progress)]
    }

    func drop(y: Double, dx: Double, onSuccess: @escaping (() -> Void)) {
        let progress = getProgress(size: size, dx: dx)
        let success = progress > 0.15
        let animation = node.contentsVar.animation(during: success ? 0.6 : 0.15) { t in
            let p = self.adjust(from: progress, to: success ? 1 : 0, p: t)
            return [self.build(cy: y, p: p)]
        }
        if success {
            animation.onComplete(onSuccess)
        }
        animation.play()
    }

    private func build(cy: Double, p: Double) -> Node {
        let side = adjust(from: 15, to: size.w, p: p, min: 0.2, max: 0.8)
        let hr = getHr(from: 48, to: size.w * 0.8, p: p)
        let vr = adjust(from: 82, to: size.h * 0.9, p: p, max: 0.4)
        let opacity = max(1 - p * 5, 0)
        return build(cy: cy, hr: hr, vr: vr, side: side, opacity: opacity)
    }

    private func build(cy: Double, hr: Double, vr: Double, side: Double, opacity: Double) -> Node {
        let xSide = left ? side : size.w - side
        let curveStartY = vr + cy
        let sign = left ? 1.0 : -1.0

        var path = MoveTo(x: xSide, y: 0)
            .lineTo(x: left ? 0 : size.w, y: 0)
            .lineTo(x: left ? 0 : size.w, y: size.h)
            .lineTo(x: xSide, y: size.h)
            .lineTo(x: xSide, y: curveStartY)

        let waveData = Wave.data
        var index = 0
        while index < waveData.count {
            path = path.cubicTo(
                x1: xSide + sign * hr * waveData[index],
                y1: curveStartY - vr * waveData[index + 1],
                x2: xSide + sign * hr * waveData[index + 2],
                y2: curveStartY - vr * waveData[index + 3],
                x: xSide + sign * hr * waveData[index + 4],
                y: curveStartY - vr * waveData[index + 5])
            index += 6
        }

        let circle = Circle(cx: 0, cy: 0, r: 24).stroke(fill: Color.black.with(a: 0.2))
        let polyline = Polyline(points: left ? [-2, -5, 2, 0, -2, 5] : [2, -5, -2, 0, 2, 5]).stroke(fill: Color.white, width: 2)

        let group = Group(contents: [circle, polyline], place: .move(dx: xSide + sign * hr + (left ? -30 : 30), dy: cy), opacity: opacity)
        let wave = Shape(form: path.close().build(), fill: color)
        return [wave, group].group()
    }

    private func getProgress(size: Size, dx: Double) -> Double {
        return min(1.0, max(0, dx * 0.45 / size.w))
    }

    private func getHr(from: Double, to: Double, p: Double) -> Double {
        let p1 = 0.4
        if p <= p1 {
            return adjust(from: from, to: to, p: p, max: p1)
        } else if p >= 1 {
            return to
        }
        let t = (p - p1) / (1 - p1)
        let m = 9.8
        let beta = 40.0 / (2 * m)
        let omega = pow(-pow(beta, 2) + pow(50.0 / m, 2), 0.5)
        return to * exp(-beta * t) * cos(omega * t)
    }

    private func adjust(from: Double, to: Double, p: Double, min: Double = 0, max: Double = 1) -> Double {
        if p <= min {
            return from
        } else if p >= max {
            return to
        }
        return from + (to - from) * (p - min) / (max - min)
    }

    private static let data = [
              0, 0.13461, 0.05341, 0.24127, 0.15615, 0.33223,
        0.23616, 0.40308, 0.33052, 0.45611, 0.50124, 0.53505,
        0.51587, 0.54182, 0.56641, 0.56503, 0.57493, 0.56896,
        0.72837, 0.63973, 0.80866, 0.68334, 0.87740, 0.73990,
        0.96534, 0.81226,       1, 0.89361,       1,       1,
              1, 1.10014, 0.95957, 1.18879, 0.86084, 1.27048,
        0.78521, 1.33305, 0.70338, 1.37958, 0.52911, 1.46651,
        0.52418, 1.46896, 0.50573, 1.47816, 0.50153, 1.48026,
        0.31874, 1.57142, 0.23320, 1.62041, 0.15411, 1.68740,
        0.05099, 1.77475,       0, 1.87092,       0,       2]

}

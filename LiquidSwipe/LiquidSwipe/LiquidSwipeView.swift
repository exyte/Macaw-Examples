//
//  LiquidSwipeView.swift
//  LiquidSwipe
//
//  Created by Yuri Strot on 3/20/19.
//  Copyright © 2019 Exyte. All rights reserved.
//

import Foundation
import Macaw

class LiquidSwipeView: MacawView {

    let colors = [0x0074D9, 0x7FDBFF, 0x39CCCC, 0x3D9970, 0x2ECC40, 0x01FF70, 0xFFDC00, 0xFF851B, 0xFF4136, 0xF012BE, 0xB10DC9, 0xAAAAAA, 0xDDDDDD].shuffled().map{ val in Color(val: val) }

    var waves = [Wave]()
    var leftAtop = false
    var size = Size.zero
    var index: Int

    required init?(coder aDecoder: NSCoder) {
        index = colors.count / 2
        super.init(node: Group(), coder: aDecoder)

        let rightEdgeGesture = UIScreenEdgePanGestureRecognizer()
        rightEdgeGesture.addTarget(self, action: #selector(rightEdgePan))
        rightEdgeGesture.edges = .right
        addGestureRecognizer(rightEdgeGesture)

        let leftEdgeGesture = UIScreenEdgePanGestureRecognizer()
        leftEdgeGesture.addTarget(self, action: #selector(leftEdgePan))
        leftEdgeGesture.edges = .left
        addGestureRecognizer(leftEdgeGesture)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let newBounds = self.bounds.toMacaw()
        let newSize = newBounds.size()
        if (!(newSize == size)) {
            size = newSize
            updatePage()
        }
    }

    @objc private func rightEdgePan(_ sender: UIPanGestureRecognizer) {
        handlePan(left: false, pan: sender, newIndex: nextIndex)
    }

    @objc private func leftEdgePan(_ sender: UIPanGestureRecognizer) {
        handlePan(left: true, pan: sender, newIndex: prevIndex)
    }

    private func handlePan(left: Bool, pan: UIPanGestureRecognizer, newIndex: @escaping (() -> Int)) {
        if leftAtop != left {
            leftAtop = left
            waves.swapAt(0, 1)
            node = waves.map { $0.node }.group()
        }
        let wave = waves[leftAtop == left ? 1 : 0]
        let y = Double(pan.location(in: self).y)
        let dx = Double(pan.translation(in: self).x) * (left ? 1 : -1)
        if pan.state == .began || pan.state == .changed {
            wave.drag(y: y, dx: dx)
        } else if pan.state == .ended || pan.state == .cancelled {
            wave.drop(y: y, dx: dx) {
                self.index = newIndex()
                self.updatePage()
            }
        }
    }

    private func updatePage() {
        self.backgroundColor = UIColor(cgColor: colors[index].toCG())
        let left = Wave(color: colors[prevIndex()], size: size, left: true, ry: 0.3)
        let right = Wave(color: colors[nextIndex()], size: size, left: false, ry: 0.7)
        waves = leftAtop ? [right, left] : [left, right]
        node = waves.map { $0.node }.group()
    }

    private func nextIndex() -> Int {
        return index < colors.count - 1 ? index + 1 : 0
    }

    private func prevIndex() -> Int {
        return index > 0 ? index - 1 : colors.count - 1
    }

}

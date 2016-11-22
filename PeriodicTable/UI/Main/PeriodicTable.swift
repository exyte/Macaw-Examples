//
//  PeriodicTable.swift
//  Example
//
//  Created by Yuri Strot on 9/14/16.
//  Copyright © 2016 Exyte. All rights reserved.
//

import UIKit
import Macaw

class PeriodicTable: MacawView {

	private static let elementSize = Size(w: 120, h: 160)
	private static let elementSpace = Size(w: 20, h: 20)
	private static let gaps = Size(w: 275, h: 240)

	private static let screen = UIScreen.main.bounds
	private static let content = Size(w: 18 * elementSize.w + 17 * elementSpace.w, h: 10 * elementSize.h + 9 * elementSpace.h)
	private static let scale = 1.0 / 3.0

	private let elements: [Node]

	private var showTable = true

	private var animations: [Animation] = []

	private static let table: [Element] = PeriodicTable.fillTable()

	required init?(coder aDecoder: NSCoder) {
		self.elements = PeriodicTable.fillElements()
		super.init(node: Group(contents: elements), coder: aDecoder)
		self.backgroundColor = UIColor.black
	}

	private static func fillElements() -> [Node] {
		var elements: [Node] = []
		for (i, element) in PeriodicTable.table.enumerated() {
			drand48()
			let group = Group(contents: [
				Shape(form: Rect(w: elementSize.w, h: elementSize.h),
					fill: Color.rgba(r: 0, g: 127, b: 127, a: getOpacity(element))
				),
				Text(text: "\(i+1)",
					font: Font(name: "Helvetica", size: 12),
					fill: Color(val: 0xc1f7f7),
					align: .max,
					place: .move(dx: elementSize.w * 5 / 6, dy: elementSize.h / 8)),
				Text(text: element.symbol,
					font: Font(name: "Helvetica Bold", size: 60),
					fill: Color(val: 0xc1f7f7),
					align: .mid,
					place: .move(dx: elementSize.w / 2, dy: elementSize.h / 4)),
				Text(text: element.name,
					font: Font(name: "Helvetica", size: 12),
					fill: Color(val: 0xc1f7f7),
					align: .mid,
					place: .move(dx: elementSize.w / 2, dy: 121)),
				Text(text: element.mass,
					font: Font(name: "Helvetica", size: 12),
					fill: Color(val: 0xc1f7f7),
					align: .mid,
					place: .move(dx: elementSize.w / 2, dy: 133))
			])
			elements.append(group)
		}
		let data = PeriodicTable.gridData()
		for (i, node) in elements.enumerated() {
			node.place = data[i]
		}
		return elements
	}

	private static func gridData() -> [Transform] {
		var result: [Transform] = []
		result.append(contentsOf: gridLayer(5))
		result.append(contentsOf: gridLayer(4))
		result.append(contentsOf: gridLayer(3))
		result.append(contentsOf: gridLayer(2))
		result.append(contentsOf: gridLayer(1))
		return result
	}

	func start() {
		for (i, node) in elements.enumerated() {
			let layer = (i % 25)
			let sign = ((layer % 5) % 2) == 0 ? 1.0 : -1.0
			let sign2 = (i / 25) % 2 == 0 ? 1.0 : -1.0
			let newPlace = GeomUtils.concat(t1: node.place, t2: Transform.move(dx: 0, dy: sign * sign2 * 300))
			let anim = node.placeVar.animation(from: node.place, to: newPlace, during: 10.0)
			anim.easing(.linear)
			anim.play()
			animations.append(anim)
		}
	}

	static func gridLayer(_ scale: Double) -> [Transform] {
		var result: [Transform] = []
		let xFull = 5 * elementSize.w + 4 * gaps.w
		let yFull = 5 * elementSize.h + 4 * gaps.h
		let xShift = (xFull / scale - Double(screen.width)) / 2
		let yShift = (yFull / scale - Double(screen.height)) / 2
		for i in 0...4 {
			for j in 0...4 {
				let dx = Double(j) * (gaps.w + elementSize.w)
				let dy = Double(i) * (gaps.h + elementSize.h)
				let pos = Transform.move(dx: -xShift, dy: -yShift).scale(sx: 1 / scale, sy: 1 / scale).move(dx: dx, dy: dy)
				result.append(pos)
			}
		}
		return result
	}

	static func getPos(row: Int, column: Int) -> Transform {
		let dx = Double(column) * (elementSize.w + elementSpace.w)
		let dy = Double(row) * (elementSize.h + elementSpace.h)
		let shift = (Double(screen.width) - content.w * scale) / 2
		return Transform.move(dx: shift, dy: elementSize.h * scale).scale(sx: scale, sy: scale).move(dx: dx, dy: dy)
	}

	static func fillTable() -> [Element] {
		let tableUrl = Bundle.main.url(forResource: "table", withExtension: "json")
		let tableData = NSData(contentsOf: tableUrl!)

		do {
			let elementsJson = try JSONSerialization.jsonObject(with: tableData! as Data, options: .allowFragments) as! NSArray
			var elements: [Element] = []
			elementsJson.forEach { json in
				guard let dictionary = json as? [String: AnyObject] else {
					return
				}
				let newElement = Element(
					symbol: dictionary["symbol"] as! String,
					name: dictionary["name"] as! String,
					mass: dictionary["mass"] as! String,
					type: ElementType(rawValue: dictionary["type"] as! String)!,
					row: dictionary["row"] as! Int,
					column: dictionary["column"] as! Int
				)
				elements.append(newElement)
			}
			return elements
		} catch {
			return []
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for animation in animations {
			animation.stop()
		}
		animations.removeAll()
		if (showTable) {
			for (i, node) in elements.enumerated() {
				let element = PeriodicTable.table[i]
				let pos = PeriodicTable.getPos(row: element.row, column: element.column)
				node.placeVar.animate(to: pos, during: 1.0)
			}
		} else {
			let data = PeriodicTable.gridData()
			for (i, node) in elements.enumerated() {
				node.placeVar.animate(to: data[i], during: 1.0)
			}
		}
		showTable = !showTable
	}

	static func getOpacity(_ element: Element) -> Double {
		switch element.type {
		case .Alkali:
			return 0.8
		case .Alkaline:
			return 0.5
		case .Transition:
			return 0.3
		case .Basic:
			return 0.4
		case .Semi:
			return 0.5
		case .Nonmetal:
			return 0.6
		case .Halogen:
			return 0.75
		case .NobleGas:
			return 0.9
		case .Lanthanide:
			return 0.45
		case .Actinide:
			return 0.65
		}
	}

}

internal enum ElementType: String  {
	case Alkali
	case Alkaline
	case Transition
	case Basic
	case Semi
	case Nonmetal
	case Halogen
	case NobleGas
	case Lanthanide
	case Actinide
}

internal class Element {

	let symbol: String
	let name: String
	let mass: String
	let type: ElementType
	let row: Int
	let column: Int

	init(symbol: String, name: String, mass: String, type: ElementType, row: Int, column: Int) {
		self.symbol = symbol
		self.name = name
		self.mass = mass
		self.type = type
		self.row = row
		self.column = column
	}

}

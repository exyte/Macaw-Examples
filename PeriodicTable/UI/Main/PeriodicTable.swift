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

	private static let screen = Size(w: 1024, h: 930)
	private static let content = Size(w: 18 * elementSize.w + 17 * elementSpace.w, h: 10 * elementSize.h + 9 * elementSpace.h)
	private static let scale = 1.0 / 3.0

	private let elements: [Node]

	private var state: Int = 0

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
					// stroke: Stroke(fill: Color(val: 0x1f7a7a)),
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

	func sync() {
		for animation in animations {
			animation.stop()
		}
		animations.removeAll()
		if (state % 3 == 0) {
			for (i, node) in elements.enumerated() {
				let element = PeriodicTable.table[i]
				let pos = PeriodicTable.getPos(row: element.row, column: element.column)
				node.placeVar.animate(to: pos, during: 1.0)
			}
		} else {
			let scale = 12.0
			let xShift1 = (PeriodicTable.elementSize.w - PeriodicTable.screen.w) / 2
			let yShift1 = (PeriodicTable.elementSize.h - PeriodicTable.screen.h) / 2
			let xShift2 = (PeriodicTable.elementSize.w * scale - PeriodicTable.screen.w) / 2
			let yShift2 = (PeriodicTable.elementSize.h * scale - PeriodicTable.screen.h) / 2
			let pos1 = Transform.move(dx: -xShift1, dy: -yShift1)
			let pos2 = Transform.move(dx: -xShift2, dy: -yShift2).scale(sx: scale, sy: scale)
			var delay = 0.0
			for (i, element) in elements.enumerated() {
				let during = 1.0 / Double(i + 1)
				let anim = element.placeVar.animation(from: element.place, to: pos1, during: during, delay: delay)
				delay += during / 2
				anim.onComplete { () in
					let anim2 = element.placeVar.animation(from: pos1, to: pos2, during: 0.5 / Double(i + 1))
					anim2.easing(.easeIn)
					anim2.onComplete { () in element.opacity = 0 }
					anim2.play()
				}
				anim.play()
			}
		}
		state += 1
	}

	private func grid() {
		let data = PeriodicTable.gridData()
		for (i, node) in elements.enumerated() {
			node.placeVar.animate(to: data[i], during: 1.0)
		}
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
		let xShift = (xFull / scale - screen.w) / 2
		let yShift = (yFull / scale - screen.h) / 2
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
		let shift = (screen.w - content.w * scale) / 2
		return Transform.move(dx: shift, dy: elementSize.h * scale).scale(sx: scale, sy: scale).move(dx: dx, dy: dy)
	}

	static func fillTable() -> [Element] {
		var elements: [Element] = []
		elements.append(Element(symbol: "H", name: "Hydrogen", mass: "1.008", type: .Nonmetal, row: 0, column: 0))
		elements.append(Element(symbol: "He", name: "Helium", mass: "4.003", type: .NobleGas, row: 0, column: 17))
		elements.append(Element(symbol: "Li", name: "Lithium", mass: "6.941", type: .Alkali, row: 1, column: 0))
		elements.append(Element(symbol: "Be", name: "Beryllium", mass: "9.012", type: .Alkaline, row: 1, column: 1))
		elements.append(contentsOf: newElements(1, column: 12,
			symbols: ["B", "C", "N", "O", "F", "Ne"],
			names: ["Boron", "Carbon", "Nitrogen", "Oxygen", "Fluorine", "Neon"],
			masses: ["10.811", "12.011", "14.007", "15.999", "18.998", "20.180"],
			types: [ElementType.Semi, ElementType.Nonmetal, ElementType.Nonmetal, ElementType.Nonmetal, ElementType.Halogen, ElementType.NobleGas]))
		elements.append(Element(symbol: "Na", name: "Sodium", mass: "22.990", type: .Alkali, row: 2, column: 0))
		elements.append(Element(symbol: "Mg", name: "Magnesium", mass: "24.305", type: .Alkaline, row: 2, column: 1))
		elements.append(contentsOf: newElements(2, column: 12,
			symbols: ["Al", "Si", "P", "S", "Cl", "Ar"],
			names: ["Aluminum", "Silicon", "Phosphorus", "Sulfur", "Chlorine", "Argon"],
			masses: ["26.982", "28.086", "30.974", "32.066", "35.453", "39.948"],
			types: [ElementType.Basic, ElementType.Semi, ElementType.Nonmetal, ElementType.Nonmetal, ElementType.Halogen, ElementType.NobleGas]))
		elements.append(contentsOf: newElements(3, column: 0,
			symbols: ["K", "Ca", "Sc", "Ti", "V", "Cr", "Mn", "Fe", "Co", "Ni", "Cu", "Zn", "Ga", "Ge", "As", "Se", "Br", "Kr"],
			names: ["Potassium", "Calcium", "Scandium", "Titanius", "Vanadium", "Chromius", "Manganese", "Iron", "Cobalt", "Nickel", "Copper", "Zinc", "Gallium", "Germanium", "Arsenic", "Selenium", "Bromine", "Krypton"],
			masses: ["39.098", "40.078", "44.956", "47.867", "50.942", "51.996", "54.938", "55.845", "58.933", "58.693", "63.546", "65.38", "69.723", "72.631", "74.922", "78.971", "79.904", "84.798"],
			types: [ElementType.Alkali, ElementType.Alkaline, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Basic, ElementType.Semi, ElementType.Semi, ElementType.Nonmetal, ElementType.Halogen, ElementType.NobleGas]))
		elements.append(contentsOf: newElements(4, column: 0,
			symbols: ["Rb", "Sr", "Y", "Zr", "Nb", "Mo", "Tc", "Ru", "Rh", "Pd", "Ag", "Cd", "In", "Sn", "Sb", "Te", "I", "Xe"],
			names: ["Rubidium", "Strontium", "Yttrium", "Zirconium", "Niobium", "Molybdenum", "Technetium", "Ruthenium", "Rhodium", "Palladium", "Silver", "Cadmium", "Indium", "Tin", "Antimony", "Tellurium", "Iodine", "Xenon"],
			masses: ["84.468", "87.62", "88.906", "91.224", "92.906", "95.95", "98.907", "101.07", "102.906", "106.42", "107.868", "112.411", "114.818", "118.711", "121.760", "127.6", "126.904", "131.294"],
			types: [ElementType.Alkali, ElementType.Alkaline, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Basic, ElementType.Basic, ElementType.Semi, ElementType.Semi, ElementType.Halogen, ElementType.NobleGas]))

		elements.append(Element(symbol: "Cs", name: "Cesium", mass: "132.905", type: .Alkali, row: 5, column: 0))
		elements.append(Element(symbol: "Ba", name: "Barium", mass: "137.328", type: .Alkaline, row: 5, column: 1))
		elements.append(contentsOf: newElements(8, column: 3,
			symbols: ["La", "Ce", "Pr", "Nd", "Pm", "Sm", "Eu", "Gd", "Tb", "Dy", "Ho", "Er", "Tm", "Yb", "Lu"],
			names: ["Lanthanum", "Cerium", "Praseodymium", "Neodymium", "Promethium", "Samarium", "Europium", "Gadolinium", "Terbium", "Dysprosium", "Holmium", "Erbium", "Thulium", "Ytterbium", "Lutetium"],
			masses: ["138.905", "140.116", "140.908", "144.243", "144.913", "150.36", "151.964", "157.25", "158.925", "162.500", "164.930", "167.259", "168.934", "173.055", "174.967"],
			types: [ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide, ElementType.Lanthanide]))
		elements.append(contentsOf: newElements(5, column: 3,
			symbols: ["Hf", "Ta", "W", "Re", "Os", "Ir", "Pt", "Au", "Hg", "Tl", "Pb", "Bi", "Po", "At", "Rn"],
			names: ["Hafnium", "Tantalum", "Tungsten", "Rhenium", "Osmium", "Iririum", "Platinum", "Gold", "Mercury", "Thallium", "Lead", "Bismuth", "Polonium", "Astatine", "Radon"],
			masses: ["178.49", "180.948", "183.84", "186.207", "190.23", "192.217", "195.085", "196.967", "200.592", "204.383", "207.2", "208.980", "[208.982]", "209.987", "222.018"],
			types: [ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Basic, ElementType.Basic, ElementType.Basic, ElementType.Semi, ElementType.Halogen, ElementType.NobleGas]))

		elements.append(Element(symbol: "Fr", name: "Francium", mass: "223.020", type: .Alkali, row: 6, column: 0))
		elements.append(Element(symbol: "Ra", name: "Radium", mass: "226.025", type: .Alkaline, row: 6, column: 1))
		elements.append(contentsOf: newElements(9, column: 3,
			symbols: ["Ac", "Th", "Pa", "U", "Np", "Pu", "Am", "Cm", "Bk", "Cf", "Es", "Fm", "Md", "No", "Lr"],
			names: ["Actinium", "Thorium", "Protactinium", "Uranium", "Neptinium", "Plutonium", "Americium", "Curium", "Berkelium", "Californium", "Einsteinium", "Fermium", "Mendelevium", "Nobelium", "Lawrencium"],
			masses: ["227.028", "232.038", "231.036", "238.029", "237.048", "244.064", "243.061", "247.070", "247.070", "251.080", "[254]", "257.095", "258.1", "259.101", "[262]"],
			types: [ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide, ElementType.Actinide]))
		elements.append(contentsOf: newElements(6, column: 3,
			symbols: ["Rf", "Db", "Sg", "Bh", "Hs", "Mr", "Ds", "Rg", "Cn", "Uut", "Fl", "Uup", "Lv", "Uus", "Uuo"],
			names: ["Rutherfordium", "Dubnium", "Seaborgium", "Bohrium", "Hassium", "Meitnerium", "Darmstadtium", "Roentgenium", "Copernicium", "Ununtrium", "Flerovium", "Ununpentium", "Livermorium", "Ununseptium", "Ununoctium"],
			masses: ["[261]", "[262]", "[266]", "[264]", "[269]", "[268]", "[269]", "[272]", "[277]", "unknown", "[289]", "unknown", "[298]", "unknown", "unknown"],
			types: [ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Transition, ElementType.Basic, ElementType.Basic, ElementType.Basic, ElementType.Basic, ElementType.Halogen, ElementType.NobleGas]))
		return elements
	}

	static func newElements(_ row: Int, column: Int, symbols: [String], names: [String], masses: [String], types: [ElementType]) -> [Element] {
		var elements: [Element] = []
		for i in 0..<symbols.count {
			elements.append(Element(symbol: symbols[i], name: names[i], mass: masses[i], type: types[i], row: row, column: column + i))
		}
		return elements
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		sync()
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

internal enum ElementType {
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

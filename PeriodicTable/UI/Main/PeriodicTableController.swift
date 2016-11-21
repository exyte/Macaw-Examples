//
//  PeriodicTableController.swift
//  Example
//
//  Created by Yuri Strot on 9/15/16.
//  Copyright © 2016 Exyte. All rights reserved.
//
import UIKit

class PeriodicTableController: UIViewController {

	@IBOutlet var periodicView: PeriodicTable!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		periodicView.start()
	}
}

//
//  ViewController.swift
//  BoxyBoxxy
//
//  Created by Derrick Ho on 6/17/16.
//  Copyright © 2016 Derrick Ho. All rights reserved.
//

import UIKit
import DHConstraintBuilder

class ViewController: UIViewController {
	// View that holds views for Visually formatted views
	@IBOutlet weak var visualFormatView: UIView!
	// View that holds views for DHConstraintBuilder formatted views
	@IBOutlet weak var dhConstraintView: UIView!
	var isTesting = NSBundle(identifier: "WebMD.BoxyBoxxyTests") != nil

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		if isTesting == false {
			let alert = UIAlertController(title: "See BoxyBoxxyTests for DHConstraintBuilder Usage examples", message: nil, preferredStyle: .Alert)
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
}


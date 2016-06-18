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

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let green = UIView()
		green.backgroundColor = .greenColor()
		
		let red = UIView()
		red.backgroundColor = .redColor()
		
		let blue = UIView()
		blue.backgroundColor = .blueColor()
		
		view.addConstraints_H(() |-^ green ^-^ red ^-| ())
		view.addConstraints_H(() |-^ blue ^-| ())
		
		view.addConstraints_V(() |-^ green ^-^ blue ^-| ())
		view.addConstraints_V(() |-^ red ^-^ blue)

//		view.addConstraints_V(() |-^ green ^-| ())
//		view.addConstraints_V(() |-^ red ^-| ())
		
//		view.addConstraint(NSLayoutConstraint(item: green, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: red, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
		view.addConstraints_H("\(green)==\(red)")
		
		view.addConstraint(NSLayoutConstraint(item: green, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: blue, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0))
		
		print(view.constraints)

	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}


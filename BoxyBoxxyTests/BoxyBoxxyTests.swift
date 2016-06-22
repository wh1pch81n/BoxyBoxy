//
//  BoxyBoxxyTests.swift
//  BoxyBoxxyTests
//
//  Created by Ho, Derrick on 6/18/16.
//  Copyright © 2016 Derrick Ho. All rights reserved.
//

import XCTest
import DHConstraintBuilder

@testable import BoxyBoxxy

func assertEqualRect(_ view: UIView, _ view2:UIView) {
	XCTAssertNotEqual(view, view2)
	let accuracy = CGFloat(0.00001)
	XCTAssertEqualWithAccuracy(view.frame.origin.x, view2.frame.origin.x, accuracy: accuracy)
	XCTAssertEqualWithAccuracy(view.frame.origin.y, view2.frame.origin.y, accuracy: accuracy)
	XCTAssertEqualWithAccuracy(view.frame.size.width, view2.frame.size.width, accuracy: accuracy)
	XCTAssertEqualWithAccuracy(view.frame.size.height, view2.frame.size.height, accuracy: accuracy)
}

extension XCTestCase {
	func wait(forSeconds seconds: NSTimeInterval = 1.0) {
		let exp = expectationWithDescription("")
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Int64(NSEC_PER_SEC) * Int64(seconds))), dispatch_get_main_queue(), {
			exp.fulfill()
		})
		waitForExpectationsWithTimeout(seconds * 2.0, handler: nil)
	}
}

class BoxyBoxxyTests: XCTestCase {
	
	lazy var button_vf: UIButton = {
		let v = UIButton()
		v.setTitle("Button", forState: UIControlState.Normal)
		v.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		v.layer.borderColor = UIColor.blackColor().CGColor
		v.layer.borderWidth = 2
		v.layer.cornerRadius = 5
		return v
	}()

	lazy var button_cb: UIButton = {
		let v = UIButton()
		v.setTitle("Button", forState: UIControlState.Normal)
		v.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		v.layer.borderColor = UIColor.blackColor().CGColor
		v.layer.borderWidth = 2
		v.layer.cornerRadius = 5
		return v
	}()
	
	lazy var greenView_vf: UIView = {
		let v = UIView()
		v.backgroundColor = .greenColor()
		return v
	}()
	
	lazy var greenView_cb: UIView = {
		let v = UIView()
		v.backgroundColor = .greenColor()
		return v
	}()
	
	lazy var redView_vf: UIView = {
		let v = UIView()
		v.backgroundColor = .redColor()
		return v
	}()
	
	lazy var redView_cb: UIView = {
		let v = UIView()
		v.backgroundColor = .redColor()
		return v
	}()
	
	lazy var blueView_vf: UIView = {
		let v = UIView()
		v.backgroundColor = .blueColor()
		return v
	}()
	
	lazy var blueView_cb: UIView = {
		let v = UIView()
		v.backgroundColor = .blueColor()
		return v
	}()
	
	var mainViewController: ViewController = UIApplication.sharedApplication().keyWindow!.rootViewController! as! ViewController
	var view_vf: UIView { return mainViewController.visualFormatView }
	var view_cb: UIView { return mainViewController.dhConstraintView }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		wait(forSeconds: 0.5)
    }
    
    override func tearDown() {
		wait(forSeconds: 3)

		resetViews()
		
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func resetViews() {
		view_vf.subviews.forEach {
			$0.removeFromSuperview()
			$0.translatesAutoresizingMaskIntoConstraints = true
		}
		redView_vf.removeConstraints(redView_vf.constraints)
		greenView_vf.removeConstraints(greenView_vf.constraints)
		blueView_vf.removeConstraints(blueView_vf.constraints)
		
		view_cb.subviews.forEach {
			$0.removeFromSuperview()
			$0.translatesAutoresizingMaskIntoConstraints = true
		}
		redView_cb.removeConstraints(redView_cb.constraints)
		greenView_cb.removeConstraints(greenView_cb.constraints)
		blueView_cb.removeConstraints(blueView_cb.constraints)
		
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
	}
	
	/**
	see image "testRedGreenBlueViews" in asset Catalog
	*/
    func testRedGreenBlueViews() {
		// VisualFormat
		let viewArray = [
			greenView_vf,
			redView_vf,
			blueView_vf
		]
		viewArray.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
		viewArray.forEach(view_vf.addSubview)
		let viewDict = [
			"greenView" : greenView_vf,
			"redView" : redView_vf,
			"blueView" : blueView_vf
		]
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[greenView]-15.5-[redView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[greenView]-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[redView]-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		greenView_vf.widthAnchor.constraintEqualToAnchor(redView_vf.widthAnchor).active = true
		greenView_vf.heightAnchor.constraintEqualToAnchor(blueView_vf.heightAnchor).active = true
		
		// DHConstraintBuilder
		view_cb.addConstraints(.H, () |-^ greenView_cb ^-^ 50 ^-^ redView_cb ^-| ())
		view_cb.addConstraints(.H, () |-^ blueView_cb ^-| ())
		
		view_cb.addConstraints(.V, () |-^ greenView_cb ^-^ blueView_cb ^-| ())
		view_cb.addConstraints(.V, () |-^ redView_cb ^-^ blueView_cb)
		
		view_cb.addConstraints(.H, DHConstraintBuilder(greenView_cb, lengthRelativeToView: redView_cb))
		view_cb.addConstraints(.V, DHConstraintBuilder(greenView_cb, lengthRelativeToView: blueView_cb))
		
		// Test
		assertEqualRect(redView_vf, redView_cb)
		assertEqualRect(greenView_vf, greenView_cb)
		assertEqualRect(blueView_vf, blueView_cb)
    }
	/**
	[button]-[textField]
	*/
    func testStandardSpace() {
		// Visual Format
		let viewArray = [button_vf, redView_vf]
		viewArray.forEach(view_vf.addSubview)
		viewArray.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
		let viewDict = ["button" : button_vf, "redView" : redView_vf]
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button]-[redView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button(30)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[redView(30)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
	// dhconstraints
		view_cb.addConstraints(.H, () |-^ button_cb ^-^ 8 ^-^ redView_cb ^-| ())
		view_cb.addConstraints(.V, DHConstraintBuilder(button_cb, length: 30) ^-| ())
		view_cb.addConstraints(.V, DHConstraintBuilder(redView_cb, length: 30) ^-| ())
		
		
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
		assertEqualRect(button_vf, button_cb)
		assertEqualRect(redView_vf, redView_cb)
    }

	/**
	[button(>=50)]
	*/
	func testTextWidthConstraint() {
		// Visual format
		button_vf.translatesAutoresizingMaskIntoConstraints = false
		view_vf.addSubview(button_vf)
		let viewDict = ["button" : button_vf]
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button(>=50)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[button]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		// DHConstraintBuilder
		view_cb.addConstraints(.H, DHConstraintBuilder(button_cb, .GreaterThanOrEqual, length: 50) ^-| ())
		view_cb.addConstraints(.V, button_cb ^-| ())
		
		//Test
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
		assertEqualRect(button_vf, button_cb)
	}
	
	/**
	|-50-[blueBox]-50-|

	*/
	func testConnectionToSuperview() {
		// Visual format
		blueView_vf.translatesAutoresizingMaskIntoConstraints = false
		view_vf.addSubview(blueView_vf)
		let viewDict = ["blueView" : blueView_vf]
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[blueView]-50-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		// DHConstraintBuilder
		view_cb.addConstraints(.H, () |-^ 50 ^-^ blueView_cb ^-^ 50 ^-| ())
		view_cb.addConstraints(.V, () |-^ blueView_cb ^-| ())
		
		//Test
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
		assertEqualRect(blueView_vf, blueView_cb)
	}
	
	/**
	V:[topField]-10-[bottomField]

	*/
	func testVerticalLayout() {
		// Visual Format
		let viewDict = ["greenView" : greenView_vf, "redView" : redView_vf]
		Array(viewDict.values).forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view_vf.addSubview($0)
		}
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[greenView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[redView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[greenView(30)]-10-[redView(30)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		// DHConstraintBuilder
		view_cb.addConstraints(.H, () |-^ 0 ^-^ greenView_cb ^-^ 0 ^-| ())
		view_cb.addConstraints(.H, () |-^ 0 ^-^ redView_cb ^-^ 0 ^-| ())
		view_cb.addConstraints(.V, () |-^
			DHConstraintBuilder(greenView_cb, length: 30) ^-^
			10 ^-^
			DHConstraintBuilder(redView_cb, length: 30))
		
		// Test
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
		assertEqualRect(greenView_vf, greenView_cb)
		assertEqualRect(redView_vf, redView_cb)
	}
	
	/**
	[maroonView][blueView]

	*/
	func testFlushViews() {
		// Visual Format
		let viewDict = ["redView" : redView_vf, "blueView" : blueView_vf]
		Array(viewDict.values).forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
			self.view_vf.addSubview($0)
		}
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[redView]-0-[blueView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[redView(30)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[blueView(30)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		redView_vf.widthAnchor.constraintEqualToAnchor(blueView_vf.widthAnchor).active = true
		
		// DHConstraintBuilder
		view_cb.addConstraints(.H, () |-^ 0 ^-^ redView_cb ^-^ 0 ^-^ blueView_cb ^-^ 0 ^-| ())
		view_cb.addConstraints(.V, () |-^
			DHConstraintBuilder(redView_cb, length: 30))
		view_cb.addConstraints(.V, () |-^
				DHConstraintBuilder(blueView_cb, length: 30))
		view_cb.addConstraints(.H, DHConstraintBuilder(redView_cb, .Equal, lengthRelativeToView: blueView_cb))
		// Test
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
		assertEqualRect(greenView_vf, greenView_cb)
		assertEqualRect(redView_vf, redView_cb)
	}
	
	/*
	/**
	Priority
	[button(100@20)]
	*/
	func testPriority() {
		view.addConstraints(.H, () |-^ button)
		view.addConstraints(.H, DHConstraintBuilder(redView, length: 100, priority: 20))
		view.addConstraints(.V, () |-^ 40 ^-^ button)
	}

	*/
	/**
	Equal Widths
	[button1(==button2)]
	*/
	func testEqualWidths() {
		// VisualFormat
		let viewArray = [
			button_vf,
			blueView_vf
		]
		viewArray.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
		viewArray.forEach(view_vf.addSubview)
		let viewDict = [
			"button" : button_vf,
			"blueView" : blueView_vf
		]
	
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[button]-0-[blueView]-0-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict))
	
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[button(==blueView)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
	
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-100-[button]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
	
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[blueView(10)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
	
	
	// DHConstraints
		var constr = () |-^ 0 ^-^ button_cb ^-^ 0 ^-^ blueView_cb ^-^ 0 ^-| ()
		constr.options = NSLayoutFormatOptions.AlignAllCenterY
		view_cb.addConstraints(.H, constr)

		view_cb.addConstraints(.H, DHConstraintBuilder(button_cb, .Equal, lengthRelativeToView: blueView_cb))
	
		view_cb.addConstraints(.V, () |-^ 100 ^-^ button_cb)
	
		view_cb.addConstraints(.V, DHConstraintBuilder(blueView_cb, length: 10))
	
		// Test
		view_vf.layoutSubviews()
		view_cb.layoutSubviews()
		assertEqualRect(button_vf, button_cb)
		assertEqualRect(blueView_vf, blueView_cb)
	
	}
//	Multiple Predicates
//	[flexibleButton(>=70,<=100)]
//
//	A Complete Line of Layout
//	|-[find]-[findNext]-[findField(>=20)]-|
}
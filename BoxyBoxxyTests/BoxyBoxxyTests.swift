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
	
	func assertEqualRect(_ view: UIView, _ view2:UIView) {
		let accuracy = CGFloat(0.00001)
		XCTAssertEqualWithAccuracy(view.frame.origin.x, view2.frame.origin.x, accuracy: accuracy)
		XCTAssertEqualWithAccuracy(view.frame.origin.y, view2.frame.origin.y, accuracy: accuracy)
		XCTAssertEqualWithAccuracy(view.frame.size.width, view2.frame.size.width, accuracy: accuracy)
		XCTAssertEqualWithAccuracy(view.frame.size.height, view2.frame.size.height, accuracy: accuracy)
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
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[greenView]-[redView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[greenView]-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		view_vf.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[redView]-[blueView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
		
		greenView_vf.widthAnchor.constraintEqualToAnchor(redView_vf.widthAnchor).active = true
		greenView_vf.heightAnchor.constraintEqualToAnchor(blueView_vf.heightAnchor).active = true
		view_vf.layoutSubviews()
		
		// DHConstraintBuilder
		view_cb.addConstraints(.H, () |-^ greenView_cb ^-^ redView_cb ^-| ())
		view_cb.addConstraints(.H, () |-^ blueView_cb ^-| ())
		
		view_cb.addConstraints(.V, () |-^ greenView_cb ^-^ blueView_cb ^-| ())
		view_cb.addConstraints(.V, () |-^ redView_cb ^-^ blueView_cb)
		
		view_cb.addConstraints(.H, DHConstraintBuilder(greenView_cb, lengthRelativeToView: redView_cb))
		view_cb.addConstraints(.V, DHConstraintBuilder(greenView_cb, lengthRelativeToView: blueView_cb))
		view_cb.layoutSubviews()
		
		// Test
		assertEqualRect(redView_vf, redView_cb)
		assertEqualRect(greenView_vf, greenView_cb)
		assertEqualRect(blueView_vf, blueView_cb)
    }
	/*
	/**
	[button]-[textField]
	*/
    func testStandardSpace() {
		// Visual Format
		
	// dhconstraints
		view.addConstraints(.H, () |-^ button ^-^ 8 ^-^ redView ^-| ())
		view.addConstraints(.V, DHConstraintBuilder(button, length: 30))
		view.addConstraints(.V, DHConstraintBuilder(redView, length: 30))
		
    }

	/**
	[button(>=50)]
	*/
//	func textWidthConstraint() {
//		view.addConstraints(.H, DHConstraintBuilder(button, lengthRelation: .GreaterThanOrEqual, ))
//	}
	
	/**
	|-50-[blueBox]-50-|

	*/
	func testConnectionToSuperview() {
		view.addConstraints(.H, () |-^ 50 ^-^ blueView ^-^ 50 ^-| ())
		view.addConstraints(.V, () |-^ DHConstraintBuilder(blueView, length: 40))
	}
	
	/**
	V:[topField]-10-[bottomField]

	*/
	func testVerticalLayout() {
		view.addConstraints(.H, () |-^ 0 ^-^ greenView ^-^ 0 ^-| ())
		view.addConstraints(.H, () |-^ 0 ^-^ redView ^-^ 0 ^-| ())
		view.addConstraints(.V, () |-^
			DHConstraintBuilder(greenView, length: 30) ^-^
			10 ^-^
			DHConstraintBuilder(redView, length: 30))
		
	}
	
	/**
	[maroonView][blueView]

	*/
	func testFlushViews() {
		view.addConstraints(.H, () |-^ 0 ^-^ redView ^-^ 0 ^-^ blueView ^-^ 0 ^-| ())
		
		view.addConstraints(.H, DHConstraintBuilder(redView, lengthRelation: .Equal, lengthRelativeToView: blueView))
		view.addConstraints(.V, () |-^ DHConstraintBuilder(redView, length: 30))
		view.addConstraints(.V, () |-^ DHConstraintBuilder(blueView, length: 30))
		
	}
	
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
	
		view_vf.layoutSubviews()
	
	// DHConstraints
		var constr = () |-^ 0 ^-^ button_cb ^-^ 0 ^-^ blueView_cb ^-^ 0 ^-| ()
		constr.options = NSLayoutFormatOptions.AlignAllCenterY
		view_cb.addConstraints(.H, constr)

		view_cb.addConstraints(.H, DHConstraintBuilder(button_cb, lengthRelation: .Equal, lengthRelativeToView: blueView_cb))
	
		view_cb.addConstraints(.V, () |-^ 100 ^-^ button_cb)
	
		view_cb.addConstraints(.V, DHConstraintBuilder(blueView_cb, length: 10))
		view_cb.layoutSubviews()
	
		// Test
		assertEqualRect(button_vf, button_cb)
		assertEqualRect(blueView_vf, blueView_cb)
	
	}
//	Multiple Predicates
//	[flexibleButton(>=70,<=100)]
//
//	A Complete Line of Layout
//	|-[find]-[findNext]-[findField(>=20)]-|
}

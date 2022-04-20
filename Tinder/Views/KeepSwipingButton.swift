//
//  KeepSwipingButton.swift
//  Tinder
//
//  Created by mogggiii on 20.04.2022.
//

import UIKit

class KeepSwipingButton: UIButton {
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let gradientLayer = CAGradientLayer()
		let leftColor = UIColor.rgb(red: 255, green: 3, blue: 114)
		let rightColor = UIColor.rgb(red: 255, green: 100, blue: 81)
		gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		
		let maskLayer = CAShapeLayer()
		let cornerRadius = rect.height / 2
		
		let maskPath = CGMutablePath()
		maskPath.addPath(UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath)
		maskPath.addPath(UIBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerRadius: cornerRadius).cgPath)
		
		maskLayer.path = maskPath
		maskLayer.fillRule = .evenOdd
		
		gradientLayer.mask = maskLayer
		
		self.layer.insertSublayer(gradientLayer, at: 0)
		
		layer.cornerRadius = cornerRadius
		clipsToBounds = true
		gradientLayer.frame = rect
	}

}

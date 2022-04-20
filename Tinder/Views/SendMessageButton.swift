//
//  SendMessageButton.swift
//  Tinder
//
//  Created by mogggiii on 20.04.2022.
//

import UIKit

class SendMessageButton: UIButton {
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
		let gradientLayer = CAGradientLayer()
		let leftColor = UIColor.rgb(red: 255, green: 3, blue: 114)
		let rightColor = UIColor.rgb(red: 255, green: 100, blue: 81)
		gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
		gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
		gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
		
		self.layer.insertSublayer(gradientLayer, at: 0)
		
		layer.cornerRadius = rect.height / 2
		clipsToBounds = true
		gradientLayer.frame = rect
	}

}

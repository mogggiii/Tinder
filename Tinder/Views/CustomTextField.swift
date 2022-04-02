//
//  CustomTextField.swift
//  Tinder
//
//  Created by mogggiii on 03.04.2022.
//

import UIKit

class CustomTextField: UITextField {
	
	let padding: CGFloat
	
	init(padding: CGFloat) {
		self.padding = padding
		super.init(frame: .zero)
		layer.cornerRadius = 20
		textColor = .black
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: 0)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: padding, dy: 0)
	}
	
	override var intrinsicContentSize: CGSize {
		return .init(width: 0, height: 40)
	}
}

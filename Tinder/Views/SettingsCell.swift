//
//  SettingsCell.swift
//  Tinder
//
//  Created by mogggiii on 08.04.2022.
//

import UIKit

class SettingsCell: UITableViewCell {
	
	class SettingsTextField: UITextField {
		
		override var intrinsicContentSize: CGSize {
			return .init(width: 0, height: 44)
		}
		
		override func textRect(forBounds bounds: CGRect) -> CGRect {
			return bounds.insetBy(dx: 24, dy: 0)
		}
		
		override func editingRect(forBounds bounds: CGRect) -> CGRect {
			return bounds.insetBy(dx: 24, dy: 0)
		}
		
	}
	
	let textField: UITextField = {
		let tf = SettingsTextField()
		tf.placeholder = "Enter Your Name"
		return tf
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		contentView.addSubview(textField)
		textField.fillSuperview()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

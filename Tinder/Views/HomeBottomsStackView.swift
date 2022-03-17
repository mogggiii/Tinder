//
//  HomeBottomsStackView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class HomeBottomsStackView: UIStackView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		distribution = .fillEqually
		heightAnchor.constraint(equalToConstant: 100).isActive = true
		
		configureUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func configureUI() {
		let subviews = [UIImage(named: "refresh"), UIImage(named: "dismiss"), UIImage(named: "favorite"), UIImage(named: "like"),  UIImage(named: "lightning")].map { image -> UIView in
			let button = UIButton(type: .system)
			button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
			return button
		}
		
		subviews.forEach { view in
			addArrangedSubview(view)
		}
	}
}

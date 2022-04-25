//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class TopNavigationStackView: UIStackView {
	
	lazy var settingsButton = UIButton(type: .system)
	lazy var messagesButton = UIButton(type: .system)
	lazy var fireImageView = UIImageView(image: UIImage(named: "fire"))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		distribution = .equalCentering
		heightAnchor.constraint(equalToConstant: 80).isActive = true
		isLayoutMarginsRelativeArrangement = true
		layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
		
		configureUI()
	}
	
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func configureUI() {
		settingsButton.setImage(UIImage(named: "person")?.withRenderingMode(.alwaysOriginal), for: .normal)
		messagesButton.setImage(UIImage(named: "message")?.withRenderingMode(.alwaysOriginal), for: .normal)
		fireImageView.contentMode = .scaleAspectFit
		
		[settingsButton, UIView(), fireImageView, UIView(), messagesButton].forEach { view in
			addArrangedSubview(view)
		}
	}
	
}

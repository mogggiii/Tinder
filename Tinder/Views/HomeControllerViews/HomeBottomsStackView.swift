//
//  HomeBottomsStackView.swift
//  Tinder
//
//  Created by mogggiii on 17.03.2022.
//

import UIKit

class HomeBottomsStackView: UIStackView {
	
// MARK: - Static
	static func createButton(image: UIImage) -> UIButton {
		let button = UIButton(type: .system)
		button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
		button.imageView?.contentMode = .scaleAspectFill
		return button
	}
	
// MARK: - UI Components
	let refreshButton = createButton(image: UIImage(named: "refresh") ?? UIImage())
	let dislikeButton = createButton(image: UIImage(named: "dismiss") ?? UIImage())
	let superLikeButton = createButton(image: UIImage(named: "favorite") ?? UIImage())
	let likeButton = createButton(image: UIImage(named: "like") ?? UIImage())
	let specialButton = createButton(image: UIImage(named: "lightning") ?? UIImage())
	
// MARK: - Init
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
		[refreshButton, dislikeButton, superLikeButton, likeButton, specialButton].forEach { button in
			self.addArrangedSubview(button)
		}
	}
}

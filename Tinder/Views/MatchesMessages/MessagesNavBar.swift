//
//  MessagesNavBar.swift
//  Tinder
//
//  Created by mogggiii on 25.04.2022.
//

import UIKit
//import LBTATools

class MessagesNavBar: UIView {
	
	fileprivate let match: Match
	
	let userProfileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.image = UIImage(named: "jane1")
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()
	
	let nameLabel: UILabel = {
		let label = UILabel()
		label.text = "USERNAME"
		label.font = .systemFont(ofSize: 16)
		return label
	}()
	
	let backButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysTemplate) ?? UIImage(), for: .normal)
		button.tintColor = UIColor(red: 255 / 255, green: 94 / 255, blue: 94 / 255, alpha: 1)
		return button
	}()
	
	let flagButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "flag")?.withRenderingMode(.alwaysTemplate) ?? UIImage(), for: .normal)
		button.tintColor = UIColor(red: 255 / 255, green: 94 / 255, blue: 94 / 255, alpha: 1)
		return button
	}()
	
	// MARK: - Init
	init(match: Match) {
		self.match = match
		super.init(frame: .zero)
		
		matchConfigure()
		backgroundColor = .white
		configureNavBar()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate methods
	fileprivate func configureNavBar() {

		self.setupShadow(opacity: 0.3, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
		
		userProfileImageView.constrainWidth(44)
		userProfileImageView.constrainHeight(44)
		userProfileImageView.layer.cornerRadius = 44 / 2
		
		let middleStack = hstack(
			stack(
				userProfileImageView,
				nameLabel,
				spacing: 8,
				alignment: .center),
			alignment: .center
		)

		hstack(backButton, middleStack, flagButton).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
	}
	
	fileprivate func matchConfigure() {
		guard let url = URL(string: match.profileImageUrl) else { return }
		nameLabel.text = match.name
		userProfileImageView.sd_setImage(with: url)
		
	}
}

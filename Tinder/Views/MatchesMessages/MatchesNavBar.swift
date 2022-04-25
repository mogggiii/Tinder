//
//  MatchesNavBar.swift
//  Tinder
//
//  Created by mogggiii on 22.04.2022.
//

import LBTATools
import UIKit

class MatchesNavBar: UIView {
	
	let backButton = UIButton(image: UIImage(named: "fire") ?? UIImage(), tintColor: .gray)
	
	// MARK: - Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		configureNavBar()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Fileprivate methods
	fileprivate func configureNavBar() {
		let iconImageView = UIImageView(image: UIImage(named: "top_messages_icon")?.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
		iconImageView.tintColor = UIColor(red: 255 / 255, green: 108 / 255, blue: 112 / 255, alpha: 1)
		
		let messageLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: .init(red: 255 / 255, green: 108 / 255, blue: 112 / 255, alpha: 1), textAlignment: .center)
		let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center)
		
		stack(iconImageView.withHeight(35), hstack(messageLabel, feedLabel, distribution: .fillEqually)).padTop(10)
		self.setupShadow(opacity: 0.3, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
		
		addSubview(backButton)
		backButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 12, left: 12, bottom: 0, right: 0), size: .init(width: 30, height: 30))
	}
	
}

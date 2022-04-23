//
//  MatchCell.swift
//  Tinder
//
//  Created by mogggiii on 22.04.2022.
//

import UIKit
import LBTATools

class MatchCell: LBTAListCell<Match> {
	
	let profileImageView: UIImageView = {
		let iv = UIImageView(image: UIImage(named: "jane1"))
		let width: CGFloat = 80
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.layer.cornerRadius = width / 2
		iv.widthAnchor.constraint(equalToConstant: width).isActive = true
		iv.heightAnchor.constraint(equalToConstant: width).isActive = true
		return iv
	}()
	
	let userNameLabel: UILabel = {
		let label = UILabel()
		label.text = "Username"
		label.font = .systemFont(ofSize: 14, weight: .semibold)
		label.textAlignment = .center
		label.textColor = .black
		label.numberOfLines = 2
		return label
	}()
	
	override var item: Match! {
		didSet {
			userNameLabel.text = item.name
			profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
		}
	}
	
	override func setupViews() {
		super.setupViews()
		
		stack(stack(profileImageView, alignment: .center), userNameLabel)
	}
}

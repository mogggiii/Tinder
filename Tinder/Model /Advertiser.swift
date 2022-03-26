//
//  Advertiser.swift
//  Tinder
//
//  Created by mogggiii on 26.03.2022.
//

import UIKit

struct Advertiser: ProducesCardViewModel {
	let title: String
	let brandName: String
	let posterPhotoName: String
	
	func toCardViewModel() -> CardViewModel {
		
		let attributedString = NSMutableAttributedString(string: title, attributes: [.font: UIFont.systemFont(ofSize: 34, weight: .heavy)])
		attributedString.append(NSAttributedString(string: "\n" + brandName, attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .bold)]))
		
		return CardViewModel(imageName: posterPhotoName, attributedString: attributedString, textAlignment: .center)
	}
}

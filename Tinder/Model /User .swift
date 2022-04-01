//
//  User .swift
//  Tinder
//
//  Created by mogggiii on 18.03.2022.
//

import UIKit

struct User: ProducesCardViewModel {
	let name: String
	let age: Int
	let profession: String
	let imageNames: [String]
	
	func toCardViewModel() -> CardViewModel {
		
		let attributedText = NSMutableAttributedString(string: name, attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .bold)])
		attributedText.append(NSAttributedString(string: "  \(age)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
		attributedText.append(NSAttributedString(string: "\n\(profession)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]))
		
		return CardViewModel(imageNames: imageNames, attributedString: attributedText, textAlignment: .left)
	}
}

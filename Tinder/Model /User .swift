//
//  User .swift
//  Tinder
//
//  Created by mogggiii on 18.03.2022.
//

import UIKit

struct User: ProducesCardViewModel {
	var name: String?
	var age: Int?
	var profession: String?
	var imageUrl1: String?
	var uid: String?

	init(dictionary: [String: Any]) {
		self.name = dictionary["fullName"] as? String ?? ""
		self.age = dictionary["age"] as? Int
		self.profession = dictionary["profession"] as? String
		self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
	}
	
	func toCardViewModel() -> CardViewModel {
		
		let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .bold)])
		
		let ageString = age != nil ? "\(age!)" : "N/A"
		attributedText.append(NSAttributedString(string: "  \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
		
		let professionString = profession != nil ? profession! : "Not Available"
		attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]))
		
		return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
	}
}

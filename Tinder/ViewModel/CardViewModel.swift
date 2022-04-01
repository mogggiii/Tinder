//
//  CardViewModel.swift
//  Tinder
//
//  Created by mogggiii on 21.03.2022.
//

import UIKit

protocol ProducesCardViewModel {
	func toCardViewModel() -> CardViewModel
}

struct CardViewModel {
	let imageNames: [String]
	let attributedString: NSAttributedString
	let textAlignment: NSTextAlignment
}

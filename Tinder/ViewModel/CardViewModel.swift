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

class CardViewModel {
	
	fileprivate var imageIndex = 0 {
		didSet {
			let imageUrl = imageUrls[imageIndex]
			imageIndexObserver?(imageIndex, imageUrl)
		}
	}
	
	var imageIndexObserver: ((Int, String?) -> ())?
	
	let uid: String
	let imageUrls: [String]
	let attributedString: NSAttributedString
	let textAlignment: NSTextAlignment
	
	init(uid: String, imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
		self.uid = uid
		self.imageUrls = imageNames
		self.attributedString = attributedString
		self.textAlignment = textAlignment
	}
	
	func advanceToNextPhoto() {
		imageIndex = min(imageIndex + 1, imageUrls.count - 1)
	}
	
	func goToPreviousPhoto() {
		imageIndex = max(0, imageIndex - 1)
	}
}

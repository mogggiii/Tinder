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
			let imageUrl = imageNames[imageIndex]
			imageIndexObserver?(imageIndex, imageUrl)
		}
	}
	
	var imageIndexObserver: ((Int, String?) -> ())?
	
	let imageNames: [String]
	let attributedString: NSAttributedString
	let textAlignment: NSTextAlignment
	
	init(imageNames: [String], attributedString: NSAttributedString, textAlignment: NSTextAlignment) {
		self.imageNames = imageNames
		self.attributedString = attributedString
		self.textAlignment = textAlignment
	}
	
	func advanceToNextPhoto() {
		imageIndex = min(imageIndex + 1, imageNames.count - 1)
	}
	
	func goToPreviousPhoto() {
		imageIndex = max(0, imageIndex - 1)
	}
}

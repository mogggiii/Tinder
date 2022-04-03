//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by mogggiii on 03.04.2022.
//

import UIKit

class RegistrationViewModel {
	
	var fullName: String? {
		didSet {
			checkFormValidity()
		}
	}
	
	var email: String? {
		didSet {
			checkFormValidity()
		}
	}
	
	var password: String? {
		didSet {
			checkFormValidity()
		}
	}
	
	var isFormValidObserber: ((Bool) -> ())?
	
	fileprivate func checkFormValidity() {
		let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
		isFormValidObserber?(isFormValid)
	}
}

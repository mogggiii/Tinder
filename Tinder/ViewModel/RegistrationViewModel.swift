//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by mogggiii on 03.04.2022.
//

import UIKit

class RegistrationViewModel {
	
//	var isFormValidObserber: ((Bool) -> ())?
	
	var bindableImage = Bindable<UIImage>()
	var bindableIsFormValid = Bindable<Bool>()
	
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
	
	fileprivate func checkFormValidity() {
		let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
		bindableIsFormValid.value = isFormValid
	}
}

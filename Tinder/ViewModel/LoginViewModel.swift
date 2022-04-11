//
//  LoginViewModel.swift
//  Tinder
//
//  Created by mogggiii on 11.04.2022.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
	var isLoggingIn = Bindable<Bool>()
	var isFormValid = Bindable<Bool>()
	
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
	
	func performLogin(completion: @escaping (Error?) ->()) {
		guard let email = email, let password = password else { return }
		isLoggingIn.value = true
		
		Auth.auth().signIn(withEmail: email, password: password) { result, error in
			completion(error)
		}
	}
	
	fileprivate func checkFormValidity() {
		let isValid = email?.isEmpty == false && password?.isEmpty == false
		isFormValid.value = isValid
	}
	
}

//
//  RegistrationViewModel.swift
//  Tinder
//
//  Created by mogggiii on 03.04.2022.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RegistrationViewModel {
	
	var bindableIsRegistering = Bindable<Bool>()
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
	
	/// register user into firebase
	/// upload image to storage
	func performRegistration(completion: @escaping (Error?) -> ()) {
		guard let email = email, let password = password else { return }
		bindableIsRegistering.value = true
		
		Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
			if let error = error {
				completion(error)
				return
			}
			
			print("Succesfully register user", authDataResult?.user.uid ?? "")
			
			let filename = UUID().uuidString
			let reference = Storage.storage().reference(withPath: "/images/\(filename)")
			let imageData = self?.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
			
			reference.putData(imageData, metadata: nil) { _, error in
				if let error = error {
					completion(error)
					return
				}
				
				print("Finish uploading image to storage")
				reference.downloadURL { url, error in
					if let error = error {
						completion(error)
						return
					}
					
					self?.bindableIsRegistering.value = false
					print("DOWNLOAD URL", url?.absoluteString ?? "")
				}
			}
		}
	}
	
	fileprivate func checkFormValidity() {
		let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
		bindableIsFormValid.value = isFormValid
	}
}

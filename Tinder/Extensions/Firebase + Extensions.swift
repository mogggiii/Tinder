//
//  Firebase + Extensions.swift
//  Tinder
//
//  Created by mogggiii on 11.04.2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

extension Firestore {
	func fetchCurrentUser(completion: @escaping (User?, Error?) ->()) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
			if let error = error {
				print("Error fetch user info", error.localizedDescription)
				completion(nil, error)
				return
			}
			
			guard let dictionary = snapshot?.data() else { return }
			let user = User(dictionary: dictionary)
			completion(user, nil)
		}
	}
}


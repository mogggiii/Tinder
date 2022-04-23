//
//  Match.swift
//  Tinder
//
//  Created by mogggiii on 23.04.2022.
//

import Foundation

struct Match {
	let name: String
	let profileImageUrl: String
	
	init(dictionary: [String: Any]) {
		self.name = dictionary["name"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
	}
}

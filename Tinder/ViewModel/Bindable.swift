//
//  Bindable.swift
//  Tinder
//
//  Created by mogggiii on 05.04.2022.
//

import Foundation

class Bindable<T> {
	
	var value: T? {
		didSet {
			observer?(value)
		}
	}
	
	var observer: ((T?) -> ())?
	
	func bind(observer: @escaping (T?) -> ()) {
		self.observer = observer
	}
}

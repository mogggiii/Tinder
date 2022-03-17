//
//  ViewController.swift
//  Tinder
//
//  Created by mogggiii on 16.03.2022.
//

import UIKit

class ViewController: UIViewController {

	override func loadView() {
		self.view = MainView()
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .darkContent
	}

}


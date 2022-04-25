//
//  ChatLogController.swift
//  Tinder
//
//  Created by mogggiii on 25.04.2022.
//

import UIKit
import LBTATools

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
	
	fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
	fileprivate let navBarHeight: CGFloat = 120
	fileprivate let match: Match
	
	init(match: Match) {
		self.match = match
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		items = [
			.init(text: "HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO"),
			.init(text: "HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO"),
			.init(text: "HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO HELLO"),
		]
		
		customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
		
		collectionView.contentInset.top = navBarHeight
		collectionView.backgroundColor = .white
		
		setupNavBar()
	}
	
	// MARK: - CollectionView
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 16, left: 0, bottom: 16, right: 0)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 140)
	}
	
	// MARK: - Fileprivate methods
	fileprivate func setupNavBar() {
		view.addSubview(customNavBar)
		
		customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
	}
	
	// MARK: - Objc fileprivate methods
	@objc fileprivate func handleBack() {
		navigationController?.popViewController(animated: true)
	}
}

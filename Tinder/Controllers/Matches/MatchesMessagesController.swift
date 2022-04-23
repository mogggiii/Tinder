//
//  MatchesMessagesController.swift
//  Tinder
//
//  Created by mogggiii on 22.04.2022.
//

import LBTATools
import UIKit
import Firebase
import FirebaseFirestore

class MatchesMessagesController: LBTAListController<MatchCell, Match>, UICollectionViewDelegateFlowLayout {
	
	let customNavBar = MatchesNavBar()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//		items = [
		//			.init(name: "test1", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/tinder-9e364.appspot.com/o/images%2F78B4E03A-EB79-48FF-853F-4986FE1E0604?alt=media&token=48750fa0-6d51-4ea2-8acb-625f19cbebe5"),
		//			.init(name: "test2", profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/tinder-9e364.appspot.com/o/images%2F78B4E03A-EB79-48FF-853F-4986FE1E0604?alt=media&token=48750fa0-6d51-4ea2-8acb-625f19cbebe5"),
		//			.init(name: "test3", profileImageUrl: "profileImage url")
		//		]
		
		customNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
		
		configureCollectionView()
		setupNavBar()
		fetchMatches()
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: 120, height: 140)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 16, left: 0, bottom: 16, right: 0)
	}
	
	fileprivate func configureCollectionView() {
		let layout = UICollectionViewFlowLayout()
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		collectionView.collectionViewLayout = layout
		collectionView.contentInset.top = 150
		collectionView.backgroundColor = .white
	}
	
	fileprivate func setupNavBar() {
		view.addSubview(customNavBar)
		
		customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
	}
	
	fileprivate func fetchMatches() {
		guard let currentUserId = Auth.auth().currentUser?.uid else { return }
		print(currentUserId)
		Firestore.firestore().collection("matches_messages").document(currentUserId).collection("matches").getDocuments { snapshot, error in
			if let error = error {
				print("Failed to fetch matches", error.localizedDescription)
				return
			}
			
			print("Successfuly fetch matches")
			
			var matches = [Match]()
			
			snapshot?.documents.forEach({ documentSnapshot in
				let dictionary = documentSnapshot.data()
				matches.append(.init(dictionary: dictionary))
			})
			
			self.items = matches
			self.collectionView.reloadData()
		}
	}
	
	@objc fileprivate func handleBack() {
		navigationController?.popViewController(animated: true)
	}
	
}

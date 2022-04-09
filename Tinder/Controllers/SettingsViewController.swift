//
//  SettingsViewController.swift
//  Tinder
//
//  Created by mogggiii on 07.04.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import JGProgressHUD
import SDWebImage

// MARK: - Custom UI Components
	class CustomImagePickerController: UIImagePickerController {
		
		var imageButton: UIButton?
		
	}
	
	class HeaderLabel: UILabel {
		override func drawText(in rect: CGRect) {
			super.drawText(in: rect.insetBy(dx: 16, dy: 0))
		}
	}

class SettingsViewController: UITableViewController {
	
	var user: User?
	
	// MARK: - UI Components
	lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
	lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
	lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
	
	lazy var headerView: UIView = {
		let header = UIView()
		header.isUserInteractionEnabled = true
		header.addSubview(image1Button)
		
		let padding: CGFloat = 16
		image1Button.anchor(top: header.topAnchor, leading: header.leadingAnchor, bottom: header.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
		image1Button.widthAnchor.constraint(equalTo: header.widthAnchor, multiplier: 0.45).isActive = true
		
		let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = padding
		header.addSubview(stackView)
		
		stackView.anchor(top: header.topAnchor, leading: image1Button.trailingAnchor , bottom: header.bottomAnchor, trailing: header.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding ))
		return header
	}()
	
	// MARK: - ViewController Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
		setupNavigationItems()
		
		tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
		tableView.tableHeaderView = headerView
		tableView.tableFooterView = UIView()
		tableView.keyboardDismissMode = .interactive
		
		fetchCurrentUser()
	}
	
	// MARK: - Objc fileprivate methods
	@objc fileprivate func handleSave() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		let docData: [String: Any] = [
			"fullName": user?.name ?? "",
			"uid": uid,
			"profession": user?.profession ?? "",
			"age": user?.age ?? -100,
			"imageUrl1": user?.imageUrl1 ?? "",
			"imageUrl2": user?.imageUrl2 ?? "",
			"imageUrl3": user?.imageUrl3 ?? ""
		]
		
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Saving settings"
		hud.show(in: view)
		Firestore.firestore().collection("users").document(uid).setData(docData) { error in
			hud.dismiss()
			if let error = error {
				print("Error save data", error)
				return
			}
		}
	}
	
	@objc fileprivate func handleCancel() {
		dismiss(animated: true)
	}
	
	@objc fileprivate func handleSelectPhoto(button: UIButton) {
		let imagePicker = CustomImagePickerController ()
		imagePicker.delegate = self
		imagePicker.imageButton = button
		present(imagePicker, animated: true)
		print("Selected Photo", button)
	}
	
	@objc fileprivate func handleNameChange(textField: UITextField) {
		self.user?.name = textField.text
	}
	
	@objc fileprivate func handleProfessionChange(textField: UITextField) {
		self.user?.profession = textField.text
	}
	
	@objc fileprivate func handleAgeChange(textField: UITextField) {
		self.user?.age = Int(textField.text ?? "")
	}
	
	// MARK: - Fileprivate Methods
	fileprivate func createButton(selector: Selector) -> UIButton {
		let button = UIButton(type: .system)
		button.setTitle("Select Photo", for: .normal)
		button.backgroundColor = .white
		button.addTarget(self, action: selector, for: .touchUpInside)
		button.layer.cornerRadius = 9
		button.imageView?.contentMode = .scaleAspectFill
		button.clipsToBounds = true
		return button
	}
	
	fileprivate func setupNavigationItems() {
		navigationItem.title = "Settings"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
		navigationItem.rightBarButtonItems = [
			UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
			UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
		]
	}
	
	fileprivate func fetchCurrentUser() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		Firestore.firestore().collection("users").document(uid).getDocument { [weak self] snapshot, error in
			if let error = error {
				print("Error fetch user info", error.localizedDescription)
				return
			}
			
			guard let dictionary = snapshot?.data() else { return }
			self?.user = User(dictionary: dictionary)
			self?.loadUserPhoto()
			self?.tableView.reloadData()
		}
	}
	
	fileprivate func loadUserPhoto() {
		if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl) {
			SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] image, _, _, _, _, _ in
				self?.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
			}
		}
		
		if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl) {
			SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] image, _, _, _, _, _ in
				self?.image2Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
			}
		}
		
		if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl) {
			SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { [weak self] image, _, _, _, _, _ in
				self?.image3Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
			}
		}
	}
	
	// MARK: - Table View Data Source
	override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerLabel = HeaderLabel()
		switch section {
		case 0:
			headerLabel.text = "Name"
		case 1:
			headerLabel.text = "Profession"
		case 2:
			headerLabel.text = "Age"
		default:
			headerLabel.text = "Bio"
		}
		
		return headerLabel
	}
	
	override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 40
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 4
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = SettingsCell(style: .default, reuseIdentifier: nil)
		switch indexPath.section {
		case 0:
			cell.textField.placeholder = "Enter Name"
			cell.textField.text = user?.name
			cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
		case 1:
			cell.textField.placeholder = "Enter Profession"
			cell.textField.text = user?.profession
			cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
		case 2:
			cell.textField.placeholder = "Enter Age"
			cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
			if let age = user?.age {
				cell.textField.text = String(age)
			}
		default:
			cell.textField.placeholder = "Enter Bio"
		}
		return cell
	}
	
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let image = info[.originalImage] as? UIImage
		let imageButton = (picker as? CustomImagePickerController)?.imageButton
		imageButton?.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
		dismiss(animated: true)
		
		/// Upload Images to Firebase Storage
		let fileName = UUID().uuidString
		let reference = Storage.storage().reference(withPath: "/images/\(fileName)")
		guard let uploadData = image?.jpegData(compressionQuality: 0.75) else { return }
		
		let hud = JGProgressHUD(style: .dark)
		hud.textLabel.text = "Uploading Image"
		hud.show(in: view)
		
		reference.putData(uploadData, metadata: nil) { _, error in
			if let error = error {
				hud.dismiss()
				print("Failed to upload images to storage", error.localizedDescription)
				return
			}
			
			reference.downloadURL { url, error in
				hud.dismiss()
				if let error = error {
					print("Failed to retrieve url", error.localizedDescription)
					return
				}
				
				switch imageButton {
				case self.image1Button:
					self.user?.imageUrl1 = url?.absoluteString
				case self.image2Button:
					self.user?.imageUrl2 = url?.absoluteString
				default:
					self.user?.imageUrl3 = url?.absoluteString
				}
			}
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true)
	}
}

//
//  PhotoPickerViewController.swift
//  TeamyApp
//
//  Created by Lizzie Ferguson on 6/25/21.
//
//
import UIKit

//MARK: - Protocol
protocol  PhotoSelectorDelegate: AnyObject {
    func photoPickerSelected(image: UIImage)
}

//MARK: - Class
class PhotoPickerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
              
    }
    
    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    static var delegate: PhotoSelectorDelegate?
    
    //MARK: - Actions
    
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
                
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibrarAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openGallery()
        }
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibrarAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Functions
    func setupViews() {
        imagePicker.delegate = self
        
    }
    
    func presentNoAccessAlert() {
        
        let alert = UIAlertController(title: "No Access", message: "Please allow access to use this feature", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Back", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

//MARK: - Extension
extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true)
        } else {
            presentNoAccessAlert()
        }
    }

    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            presentNoAccessAlert()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            guard let delegate = PhotoPickerViewController.delegate else {return}
            delegate.photoPickerSelected(image: pickedImage)
            photoImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}//End of class



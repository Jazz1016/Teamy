//
//  CreateNewTeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class CreateNewTeamViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var leagueNameTextField: UITextField!
    @IBOutlet weak var leagueDetailsTextField: UITextView!
    @IBOutlet weak var coachNameTextField: UITextField!
    @IBOutlet weak var sportPickerTextField: UITextField!
    @IBOutlet weak var selectColorButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PhotoPickerViewController.delegate = self
        pickerView.dataSource = self
        pickerView.delegate = self
        sportPickerTextField.inputView = pickerView
        createToolBar()
    }
    
    // MARK: - Properties
    var randomNumString = "\(Int.random(in: 1...999999))"
    var image: UIImage?
    var teamColorPicked = ""
    var pickerView = UIPickerView()
    var imageURL = ""
    
    // MARK: - Actions
    
    @IBAction func selectColorButtonTapped(_ sender: Any) {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        
        present(colorPickerVC, animated: true, completion: nil)
    }
    
    
    ///Creates a new team and adds creating user as an admin
    @IBAction func createNewTeamTapped(_ sender: Any) {
        guard let teamName = teamNameTextField.text,
              let userId = Auth.auth().currentUser?.uid,
              let sport = sportPickerTextField.text,
              !sport.isEmpty
        else {return}
        addZeros()
        DispatchQueue.main.async {
            self.saveImage(teamName: teamName)
        }
        let defaultAdmin = [userId]
        // JAMLEA: Pass in Sport name from Picker
        // JAMLEA: pass in teamColor Anthony
        let newTeam = Team(name: teamName, teamColor: teamColorPicked, teamSport: sport, teamRecord: "0-0",leagueName: leagueNameTextField.text ?? "League", teamBio: leagueDetailsTextField.text ?? "Edit in manage team", admins: defaultAdmin, members: [], blocked: [], teamId: UUID().uuidString, teamCode: randomNumString, teamImage: imageURL)
        let newContact = Contact(contactName: coachNameTextField.text ?? "", contactType: "", contactInfo: "")
        TeamController.shared.addTeamToUser(userId: userId, teamId: newTeam.teamId)
        TeamController.shared.createTeam(team: newTeam, contact: newContact) { result in
            print("new team \(newTeam.name) has been created")
        }
        saveImage()
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Functions
    func addZeros(){
        if randomNumString.count < 6 {
            randomNumString = "0" + randomNumString
            print(randomNumString)
            addZeros()
        }
    }
    
    func createToolBar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateNewTeamViewController.dismissKeyBoard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        sportPickerTextField.inputAccessoryView = toolbar
    }//End of func
    
    func saveImage() {
        guard let image = self.image else {return}
        
        let storageRef = Storage.storage().reference().child("myImage.jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.75) {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error {
                    print("")
                }
                print(metaData)
                let size = metaData?.size
                storageRef.downloadURL { (url, error) in
                    guard let downloadurl = url else {return}
                    self.imageURL = downloadurl.absoluteString
                }
            }
        }
    }
    
    @objc func dismissKeyBoard() {
        view.endEditing(true)
    }//End of func
    
    func saveImage(teamName: String) {
        
        guard let image = self.image else {return}
        
        let storageRef = Storage.storage().reference().child("\(teamName).jpg")
        if let uploadData = image.jpegData(compressionQuality: 0.75) {
            storageRef.putData(uploadData, metadata: nil) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                let size = metaData?.size
                storageRef.downloadURL { (url, error) in
                    guard let downloadurl = url else {return}
                    print(downloadurl.absoluteURL)
                    self.imageURL = downloadurl.absoluteString
                }
            }
        }
    }
    
    
    //MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toPhotoPicker" {
//            let destinationVC = segue.destination as? PhotoPickerViewController
//            destinationVC?.delegate = self
//        }
//    }

}//End of class

//MARK: - Extensions
extension CreateNewTeamViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        //AnthonyByrd - Discuss with team which method to use
        let color = viewController.selectedColor
        teamColorPicked = color.toHexString()
        selectColorButton.backgroundColor = UIColor.init(hexString: teamColorPicked)
        selectColorButton.setTitle("", for: .normal)
    }
}

extension CreateNewTeamViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TeamController.shared.sports.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TeamController.shared.sports[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sportPickerTextField.text = TeamController.shared.sports[row]
    }
}

extension CreateNewTeamViewController: PhotoSelectorDelegate {
    func photoPickerSelected(image: UIImage) {
        self.image = image
    }
}

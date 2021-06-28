//
//  CreateNewTeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class CreateNewTeamViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var leagueNameTextField: UITextField!
    @IBOutlet weak var leagueDetailsTextField: UITextView!
    @IBOutlet weak var coachNameTextField: UITextField!
    @IBOutlet weak var sportPicker: UIPickerView!
    @IBOutlet weak var selectColorButton: UIButton!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sportPicker.delegate = self
        sportPicker.dataSource = self
        
    }
    
    // MARK: - Properties
    var randomNumString = "\(Int.random(in: 1...999999))"
    var image: UIImage?
    
    
    // MARK: - Actions
    
    @IBAction func selectColorButtonTapped(_ sender: Any) {
    }
    
    
    ///Creates a new team and adds creating user as an admin
    @IBAction func createNewTeamTapped(_ sender: Any) {
        guard let teamName = teamNameTextField.text,
              let userId = Auth.auth().currentUser?.uid
        else {return}
        addZeros()
        
        let defaultAdmin = [userId]
        // JAMLEA: Pass in Sport name from Picker
        // JAMLEA: pass in teamColor Anthony
        let teamDescript = TeamDescription(leagueName: leagueNameTextField.text ?? "", detail: leagueDetailsTextField.text ?? "")
        let newTeam = Team(name: teamName, teamColor: "Blue", teamSport: "", admins: defaultAdmin, members: [], blocked: [], teamDesc: teamDescript, teamId: UUID().uuidString, teamCode: randomNumString, teamImage: "")
        let newContact = Contact(contactName: coachNameTextField.text ?? "", contactType: "", contactInfo: "")
        TeamController.shared.addTeamToUser(userId: userId, teamId: newTeam.teamId)
        TeamController.shared.createTeam(team: newTeam, contact: newContact) { result in
            print("new team \(newTeam.name) has been created")
        }
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
    
    
    // MARK: - Picker configuration
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return TeamController.shared.sports.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return TeamController.shared.sports[row]
    }
    
}//End of class

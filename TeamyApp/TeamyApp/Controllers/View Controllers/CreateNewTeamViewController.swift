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
    @IBOutlet weak var teamColorPicker: UIPickerView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sportPicker.delegate = self
        sportPicker.dataSource = self
        teamColorPicker.delegate = self
        teamColorPicker.dataSource = self
        
    }
    
    // MARK: - Properties
    var randomNumString = "\(Int.random(in: 1...999999))"
    
    ///Creates a new team and adds creating user as an admin
    @IBAction func createNewTeamTapped(_ sender: Any) {
        guard let teamName = teamNameTextField.text,
              let userId = Auth.auth().currentUser?.uid
        else {return}
        addZeros()
        
        let defaultAdmin = [userId]
        
        let teamDescript = TeamDescription(leagueName: leagueNameTextField.text ?? "", detail: leagueDetailsTextField.text ?? "")
        
        let newTeam = Team(name: teamName, teamColor: "Blue", admins: defaultAdmin, members: [], blocked: [], teamDesc: teamDescript, teamId: UUID().uuidString, teamCode: randomNumString)
        let newContact = Contact(contactName: coachNameTextField.text ?? "", contactType: "", contactInfo: "")
        TeamController.shared.addTeamToUser(userId: userId, teamId: newTeam.teamId)
        
        TeamController.shared.createTeam(team: newTeam, contact: newContact) { result in
            print("new team \(newTeam.name) has been created")
        }
    }
    
    // MARK: - Helper Functions
    func addZeros(){
        if randomNumString.count < 6 {
            randomNumString = "0" + randomNumString
            print(randomNumString)
            addZeros()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch UIPickerView() {
        case self.sportPicker:
            return TeamController.shared.sports.count
        case self.teamColorPicker:
            return TeamController.shared.colors.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch UIPickerView() {
        
        
        
        case sportPicker:
            
            return TeamController.shared.sports[row]
        case teamColorPicker:
            
            return TeamController.shared.colors[row]
        default:
            
            return ""
        }
    }
    
}

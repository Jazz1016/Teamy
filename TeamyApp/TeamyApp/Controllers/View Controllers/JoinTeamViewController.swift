//
//  JoinTeamViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class JoinTeamViewController: UIViewController {
  
    //MARK: - Outlets
    @IBOutlet weak var codeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Actions
    @IBAction func confirmCodeButtonTapped(_ sender: Any) {
        guard let code = codeTextField.text,
              let userId = Auth.auth().currentUser?.uid
              else {return}
        
        if code.count == 6 {
            UserController.shared.userjoinsTeam(teamCode: code, userId: userId)
            
            
        } else {return}
    }
    
}

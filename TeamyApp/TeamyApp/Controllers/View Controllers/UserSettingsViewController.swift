//
//  UserSettingsViewController.swift
//  TeamyApp
//
//  Created by Lizzie Ferguson on 6/30/21.
//

import UIKit

//MARK: - Class

class UserSettingsViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
//MARK: - Actions

    @IBAction func logoutButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
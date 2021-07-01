//
//  UserSettingsViewController.swift
//  TeamyApp
//
//  Created by Lizzie Ferguson on 6/30/21.
//

import UIKit
import Firebase

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
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {return}
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
            presentAlertToDeleteAccount()
    }
    
    func presentAlertToDeleteAccount() {
        
        let alert = UIAlertController(title: "Are you sure you want to delete?", message: "If so, please type your current password to delete account", preferredStyle: .alert)
    
        alert.addTextField { passwordTextfield in
            passwordTextfield.placeholder = "Password"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
            guard let password = alert.textFields?.first?.text, !password.isEmpty else {return}
            self.reauthenticateUser(currentPassword: password)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func reauthenticateUser(currentPassword: String) {
        
        guard let email = Auth.auth().currentUser?.email else {return}
            
            let credentials = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
            
            Auth.auth().currentUser?.reauthenticate(with: credentials, completion: { result, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    print("Could not delete account")
                }
                if result != nil {
                    print("Successfully deleted account")
                    UserController.shared.deleteUser { result in
                        switch result {
                        case .success(_):
                            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else {return}
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                    }
                   
                }
            })
            
        }
        
    
    
    
    @IBAction func saveChangesButtonTapped(_ sender: Any) {
        guard let password = passwordTextField.text else {return}
        UserController.shared.updatePassword(password: password)
        guard let email = Auth.auth().currentUser?.email,
              let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let userId = Auth.auth().currentUser?.uid else {return}
              let user = User(email: email, firstName: firstName, lastName: lastName, userId: userId )
        
        UserController.shared.updateUser(user: user)
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

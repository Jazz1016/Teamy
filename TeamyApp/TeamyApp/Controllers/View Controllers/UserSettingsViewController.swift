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
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        
        changePasswordButton.layer.cornerRadius = 10
        logOutButton.layer.cornerRadius = 10
    }
    
    //MARK: - Properties
    var user: User?
    
    //MARK: - Actions
    @IBAction func editButtonTapped(_ sender: Any) {
        firstNameLabel.isHidden.toggle()
        lastNameLabel.isHidden.toggle()
        firstNameTextField.isHidden.toggle()
        lastNameTextField.isHidden.toggle()
    }
    
    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        presentAlertToChangePassword()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            TeamController.shared.teams = []
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
    
    func updateViews() {
        guard let user = user else {return}
        firstNameLabel.text = "Welcome \(user.firstName)  \(user.lastName)"
        emailLabel.text = user.email
//        firstNameTextField.text = user.firstName
//        lastNameLabel.text = user.lastName
//        lastNameTextField.text = user.lastName
//        firstNameTextField.isHidden = true
//        lastNameTextField.isHidden = true
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
    
    
    func presentAlertToChangePassword() {
        let alert = UIAlertController(title: "Are you sure you want to change your password?", message: "If so, please type in your current password to change", preferredStyle: .alert)
        
        alert.addTextField { newPasswordTextField in
            newPasswordTextField.placeholder = "New Password"
        }
        
        alert.addTextField { confirmNewPassword in
            confirmNewPassword.placeholder = "Confirm New Password"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            guard let newPassword = alert.textFields?.first?.text, !newPassword.isEmpty,
                  let confirmNewPassword = alert.textFields?.last?.text, !confirmNewPassword.isEmpty
            else {return}
            if newPassword == confirmNewPassword {
                UserController.shared.updatePassword(password: newPassword)
            } else {
                print("Passwords do not match")
            }
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
                UserController.shared.deleteUserInfo()
                UserController.shared.deleteUser { result in
                    switch result {
                    case .success(_):
                        print("Successfully deleted account")
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
        guard let currentUser = user else {return}
        let email = currentUser.email
        let userId = currentUser.userId
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text else {return}
        let user = User(email: email, firstName: firstName, lastName: lastName, userId: userId )
        
        UserController.shared.updateUser(user: user)
    }
}//End of class

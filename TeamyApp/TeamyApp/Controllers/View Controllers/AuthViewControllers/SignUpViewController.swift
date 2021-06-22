//
//  SignUpViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        SignUp()
    }
    
    func SignUp() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = passwordConfirmTextField.text, !password.isEmpty,
              let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty else {return}
        
        if confirmPassword == password {
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
                if result != nil {
                    print("Successfully created account")
                    let newUser = User(email: email, firstName: firstName, lastName: lastName, userId: result!.user.uid)
                    UserController.shared.createUser(user: newUser)
                    self.transitionToHome()
                }
            }
        } else {
            
            let alert = UIAlertController(title: "Sign Up Error", message: "Passwords are not identical", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func transitionToHome() {
//            let homeViewController = storyboard?.instantiateViewController(identifier: "HomeVC")
            
//            view.window?.rootViewController = homeViewController
//            view.window?.makeKeyAndVisible()
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    
    
}

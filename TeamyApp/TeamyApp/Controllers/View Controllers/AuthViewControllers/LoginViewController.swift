//
//  LoginViewController.swift
//  TeamyApp
//
//  Created by James Lea on 6/21/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: - Actions
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        forgotPassword()
    }
    
    //MARK: - Methods
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        login()
    }
    
    func login() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {return}
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
            }
            if result != nil {
                print("Sign In Successful")
                guard let result = result else {return}
                DispatchQueue.main.async {
                    
                    UserController.shared.fetchUser(userId: result.user.uid) { result in
                        
                        switch result {
                        case .success(let user):
                            UserController.shared.user = user
                            TeamController.shared.fetchTeamsForUser(teamIds: user.teams) { result in
                                print("teams fetched")
                            }
                        case .failure(let error):
                            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                        }
                        print(result)
                        // JAMLEA:
                        
                    }
                }
                self.transitionToHome()
            } else {
                let alert = UIAlertController(title: "Sign In Error", message: "Sign in credentials not found. Would you like to create a new account?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                        guard let signUpVC = self.storyboard?.instantiateViewController(identifier: "SignUpVC") else {return}
                        self.present(signUpVC, animated: true, completion: nil)
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
        }
    }
    
    func transitionToHome() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func forgotPassword() {
        
        let forgotPasswordAlert = UIAlertController(title: "Please Enter Email Address", message: "You will be sent an email to change your Password", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { textField in
            textField.placeholder = "Email"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Send Email", style: .default, handler: { _ in
            guard let resetEmail = forgotPasswordAlert.textFields?.first?.text else {return}
            Auth.auth().sendPasswordReset(withEmail: resetEmail) { error in
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    print("Could not send email for password reset")
                } else {
                    print("Email Sent")
                }
            }
        }))
        present(forgotPasswordAlert, animated: true, completion: nil)
    }
}

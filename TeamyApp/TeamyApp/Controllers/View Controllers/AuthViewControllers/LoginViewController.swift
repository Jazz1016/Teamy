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
                transitionToHome()
            } else {
                let alert = UIAlertController(title: "Sign In Error", message: "Sign in credentials not found. Would you like to create a new account?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
                        let signUpVC = self.storyboard?.instantiateViewController(identifier: "SignUpVC")
                        
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
        }
        
        func transitionToHome() {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            
        }
    }
}

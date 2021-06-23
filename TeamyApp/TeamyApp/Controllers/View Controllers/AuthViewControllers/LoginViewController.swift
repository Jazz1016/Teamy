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
                self.transitionToHome()
            } else {
                let alert = UIAlertController(title: "Sign In Error", message: "Sign in credentials not found. Would you like to create a new account?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
//                    let signUpVC = self.storyboard?.instantiateViewController(identifier: "SignUpVC")
                    //Change view to sign up view controller
//                    self.navigationController?.popToViewController(SignUpViewController(), animated: true)
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Strings.homeVC)
            
            view.window?.rootViewController = homeViewController
            view.window?.makeKeyAndVisible()
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

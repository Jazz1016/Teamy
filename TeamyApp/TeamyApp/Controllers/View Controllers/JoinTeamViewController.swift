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
    @IBOutlet weak var joinTeamButton: UIButton!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinTeamButton.layer.cornerRadius = 10
        codeTextField.delegate = self
    }
    
    //MARK: - Actions
    @IBAction func confirmCodeButtonTapped(_ sender: Any) {
        guard let code = codeTextField.text,
              let userId = Auth.auth().currentUser?.uid
              else {return}
        
        var finalCode: String = ""
        code.forEach {
            if $0 != " " {
                finalCode += "\($0)"
            }
        }
        
        if finalCode.count == 6 {
            UserController.shared.userjoinsTeam(teamCode: finalCode, userId: userId) { result in
                switch result {
                case true:
                    self.navigationController?.popViewController(animated: true)
                case false:
                    let errorController = UIAlertController(title: "Error", message: "Error joining team", preferredStyle: .alert)
                    let doneAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    errorController.addAction(doneAction)
                    self.present(errorController, animated: true, completion: nil)
                }
                
            }
        } else {return}
    }
}//End of class

extension JoinTeamViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "X X X X X X", phone: newString)
        return false
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

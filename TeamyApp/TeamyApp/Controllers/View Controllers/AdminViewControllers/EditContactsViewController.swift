//
//  EditContactsViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class EditContactsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var contactsTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func addContactButtonTapped(_ sender: Any) {
        
    }
    
}

//MARK: - extensions
extension EditContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //AnthonyByrd - Return to add cell
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //AnthonyByrd - Return to add cell
        
        return UITableViewCell()
    }
    
    
}

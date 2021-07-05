//
//  UserManagementViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class UserManagementViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var accessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accessTableView.dataSource = self
        accessTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}//End of class

extension UserManagementViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let team = EventController.shared.team else {return 0}
        if section == 0 {
            return team.admins.count
        } else if section == 1 {
            return team.members.count
        } else if section == 2 {
            return team.blocked.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEditCell", for: indexPath)
            
            
            
            return cell ?? UITableViewCell()
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEditCell", for: indexPath)
            
            return cell ?? UITableViewCell()
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userEditCell", for: indexPath)
            
            return cell ?? UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    
}//End of extension

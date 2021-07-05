//
//  AnnouncementsViewController.swift
//  TeamyApp
//
//  Created by James Lea on 7/5/21.
//

import UIKit

class AnnouncementsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var editAnnouncementsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editAnnouncementsTableView.delegate = self
        editAnnouncementsTableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func addAnnouncementButtonTapped(_ sender: Any) {
        let editCell = editAnnouncementsTableView.indexPath(for: EditAnnouncementTableViewCell())
        
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

extension AnnouncementsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        AnnouncementController.shared.announcements.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = editAnnouncementsTableView.dequeueReusableCell(withIdentifier: "addAnnouncementCell", for: indexPath)
                return cell
            } else if indexPath.row > 0 {
                let cell = editAnnouncementsTableView.dequeueReusableCell(withIdentifier: "announcementDetailCell", for: indexPath) as? EditAnnouncementTableViewCell
                let announcement = AnnouncementController.shared.announcements[indexPath.row]
                cell?.announcementDetailTextView.text = announcement.details
                cell?.announcementLabel.text = announcement.title
                cell?.announcementTextField.text = announcement.title
                return cell ?? UITableViewCell()
            }
        return UITableViewCell()
    }
}

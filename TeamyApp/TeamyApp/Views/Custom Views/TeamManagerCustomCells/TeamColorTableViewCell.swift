//
//  TeamColorTableViewCell.swift
//  TeamyApp
//
//  Created by anthony byrd on 6/29/21.
//

import UIKit

class TeamColorTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var teamColorButton: UIButton!
    @IBOutlet weak var teamAccentColorView: UIView!
    
    //MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateTeamColor()
    }
    
    //MARK: - Properties
    static let identifier = "TeamColorTableViewCell"
    var updatedTeamColorPicked = ""
    
    //MARK: - Methods
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func updateTeamColor() {
        guard let team = EventController.shared.team else { return }
        
        teamColorButton.backgroundColor = UIColor.init(hexString: team.teamColor)
        teamAccentColorView.backgroundColor = UIColor.init(hexString: team.teamColor)
    }
    
    @IBAction func teamColorButtonTapped(_ sender: Any) {
        let colorPickerVC = EditUIColorPickerViewController()
        colorPickerVC.delegate = self
        
        print("color")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Extension
extension TeamColorTableViewCell: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: EditUIColorPickerViewController) {

        let color = viewController.selectedColor

        updatedTeamColorPicked = color.toHexString()
        teamColorButton.backgroundColor = UIColor.init(hexString: updatedTeamColorPicked)
        teamColorButton.setTitle("", for: .normal)
    }
}//End of extension

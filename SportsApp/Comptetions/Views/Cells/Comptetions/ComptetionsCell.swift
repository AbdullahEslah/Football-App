//
//  ComptetionsCell.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 15/10/2022.
//

import UIKit

class ComptetionsCell: UITableViewCell {

    @IBOutlet weak var comptetionLeagueName: UILabel!
    
    @IBOutlet weak var comptetionLongTeamName: UILabel!
    @IBOutlet weak var comptetionShortTeamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        //  Configure the view for the selected state
    }
    
}

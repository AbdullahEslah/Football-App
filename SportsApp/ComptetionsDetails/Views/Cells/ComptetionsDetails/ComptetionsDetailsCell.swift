//
//  ComptetionsDetailsCell.swift
//  SportsApp
//
//  Created by Abdallah Eslah on 17/10/2022.
//

import UIKit

class ComptetionsDetailsCell: UICollectionViewCell {

    @IBOutlet weak var comptetionName: UILabel!
    @IBOutlet weak var comptetionDetailsLongName: UILabel!
    @IBOutlet weak var comptetionDetailsShortName: UILabel!
    @IBOutlet weak var comptetionsDetailsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //  For Color Layer
        comptetionsDetailsImageView.layer.borderColor = UIColor.label.cgColor
        comptetionsDetailsImageView.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //  For Rounded Corner Like A Ball
        comptetionsDetailsImageView.layer.cornerRadius = comptetionsDetailsImageView.frame.width / 2
        comptetionsDetailsImageView.clipsToBounds = true
    }
    
    

}

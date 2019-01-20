//
//  HomeCustomTableViewCell.swift
//  SpeechTest
//
//  Created by mac on 12/01/19.
//  Copyright © 2019 jugal balara. All rights reserved.
//

import UIKit

class HomeCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imgRest: UIImageView!
    @IBOutlet weak var lblRestName: UILabel!
    @IBOutlet weak var lblSpecifiedFor: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(dict: ModelClass) {
        
        if dict.restImage != "" {
            imgRest.downloaded(from: dict.restImage)
        }
        
        lblRestName.text = dict.restName
        lblSpecifiedFor.text = dict.categoryName
        lblRating.text = " " + dict.rating + " "
    }
}

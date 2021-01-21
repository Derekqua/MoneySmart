//
//  HomeTableViewCell.swift
//  MoneySmart
//
//  Created by Derek Qua on 21/1/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var notes: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var catImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

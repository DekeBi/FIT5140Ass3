//
//  FilmTableViewCell.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/5.
//

import UIKit

class FilmTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var despLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

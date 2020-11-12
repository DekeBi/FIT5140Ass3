//
//  MovieTableViewCell.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/12.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var despLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var movieImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

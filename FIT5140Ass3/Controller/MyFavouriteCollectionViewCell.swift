//
//  MyFavouriteCollectionViewCell.swift
//  FIT5140Ass3
//
//  Created by user174132 on 11/20/20.
//

import UIKit

class MyFavouriteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieLabel: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    
    @IBOutlet weak var highlightIndicator: UIView!
    
    
    @IBOutlet weak var selectIndicator: UIImageView!
    
    
    override var isHighlighted: Bool{
        didSet{
            highlightIndicator?.isHidden = !isHighlighted
            selectIndicator?.isHidden = !isSelected
        }
    }
    
    override var isSelected: Bool{
        didSet{
            highlightIndicator?.isHidden = !isSelected
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

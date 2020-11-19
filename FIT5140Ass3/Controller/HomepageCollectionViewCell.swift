//
//  HomepageCollectionViewCell.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/20.
//

import UIKit

class HomepageCollectionViewCell: UICollectionViewCell {
    
    var interest: Recommondation! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    private func updateUI() {
        interestTitleLabel?.text! = interest.title
        featuredImageView?.image! = interest.featuredImage
    }
}

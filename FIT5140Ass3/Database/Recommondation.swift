//
//  Recommondation.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/20.
//

import Foundation
import UIKit

class Recommondation {
    var title = ""
    var description = ""
    var numberOfMembers = 0
    var numberOfPosts = 0
    var featuredImage: UIImage!
    
    init(title: String, description: String, featuredImage: UIImage!) {
        self.title = title
        self.description = description
        self.featuredImage = featuredImage
        numberOfMembers = 1
        numberOfPosts = 1
    }
    
    static func createInterest() -> [Recommondation] {
        return [Recommondation(title: "Rogue City - 2020.10.30", description: "Rogue City", featuredImage: UIImage(named: "11")?.reSizeImage(reSize: CGSize(width: 300, height: 444))), Recommondation(title: "Hard Kill - 2020.10.23", description: "Hard Kill", featuredImage: UIImage(named: "12")?.reSizeImage(reSize: CGSize(width: 300, height: 444))), Recommondation(title: "Roald Dahl's The Witches - 2020.10.26", description: "Roald Dahl's The Witches", featuredImage: UIImage(named: "13")?.reSizeImage(reSize: CGSize(width: 300, height: 444))), Recommondation(title: "After We Collided - 2020.09.02", description: "After We Collided", featuredImage: UIImage(named: "14")?.reSizeImage(reSize: CGSize(width: 300, height: 444))),  Recommondation(title: "Once Upon a Snowman - 2020.10.23", description: "Once Upon a Snowman", featuredImage: UIImage(named: "15")?.reSizeImage(reSize: CGSize(width: 300, height: 444)))]
    }
}

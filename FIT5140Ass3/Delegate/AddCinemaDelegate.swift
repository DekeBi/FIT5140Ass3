//
//  AddCinemaDelegate.swift
//  FIT5140Ass3
//
//  Created by Tilain Lei on 2020/11/3.
//

import Foundation

protocol AddCinemaDelegate: AnyObject {
    func addCinema(newCinema: Cinema) -> Bool
}

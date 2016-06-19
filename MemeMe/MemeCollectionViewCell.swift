//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by Lars Halvorsen on 13/06/16.
//  Copyright © 2016 Amilar sprl. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!


    func setText(topString: String, bottomString: String) {
        topText.text = topString
        bottomText.text = bottomString
    }

}
//
//  Meme.swift
//  MemeMe
//
//  Created by Jennifer Louthan on 11/4/15.
//  Copyright © 2015 JennyLouthan. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
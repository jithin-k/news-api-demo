//
//  UIImage+Extension.swift
//  news-api-demo
//
//  Created by WIFI on 23/12/20.
//

import UIKit
import SDWebImage


extension UIImageView {
    
    func setImage(url: String) {
        guard let imageUrl = URL(string: url) else { return }
        self.sd_setImage(with: imageUrl)
    }
}

//
//  PhotoItemCell.swift
//  fotoskuy
//
//  Created by Michael Ricky on 11/04/22.
//

import UIKit

class PhotoItemCell: UICollectionViewCell {
    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        self.addSubview(img)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = self.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
}

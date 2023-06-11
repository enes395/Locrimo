//
//  IndicatorCollectionViewCell.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 17.03.2023.
//

import UIKit

class IndicatorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}

//
//  LocationCollectionViewCell.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import UIKit
class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var locationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(location: Location, isSelected: Bool) {
        locationLabel.text = location.name
        locationLabel.font = UIFont.avenir(.Heavy, size: 14)
        if isSelected {
            locationLabel.textColor = .rickGreen
        } else {
            locationLabel.textColor = .blackWhite
        }
    }

}

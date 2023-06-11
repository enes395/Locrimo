//
//  CharacterTableViewCell.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 16.03.2023.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.rounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(character: Character) {
        nameLabel.text = character.name
        nameLabel.font = UIFont.avenir(.Heavy, size: 16)
        genderImageView.image = UIImage(named: character.gender + ".png")
        let photoUrl = URL(string: character.image)
        DispatchQueue.main.async { [weak self] in
            self?.photoImageView.kf.setImage(with: photoUrl)
        }
    }
    
}

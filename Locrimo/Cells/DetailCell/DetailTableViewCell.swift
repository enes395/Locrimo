//
//  DetailTableViewCell.swift
//  Locrimo
//
//  Created by Muhammed Enes Kılıçlı on 20.03.2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(title: String, text: String) {
        titleLabel.text = title
        detailLabel.text = text
        titleLabel.font = UIFont.avenir(.Heavy, size: 22)
        detailLabel.font = UIFont.avenir(.Book, size: 22)
        self.selectionStyle = .none
    }
    
}

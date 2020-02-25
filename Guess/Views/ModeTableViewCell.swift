//
//  ModeTableViewCell.swift
//  Guess
//
//  Created by Rene Dubrovski on 2/24/20.
//  Copyright © 2020 articga. All rights reserved.
//

import UIKit

class ModeTableViewCell: UITableViewCell {
    
    
    let modeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 12.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let questionAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Regular", size: 10.0)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(modeTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(questionAmountLabel)
        
        backgroundColor = .clear // very important
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        // add corner radius on `contentView`
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        
        modeTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2.0).isActive = true
        modeTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: modeTitleLabel.bottomAnchor, constant: 1.0).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0).isActive = true
        
        questionAmountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 1.0).isActive = true
        questionAmountLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8.0).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

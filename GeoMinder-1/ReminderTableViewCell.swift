//
//  ReminderTableViewCell.swift
//  GeoMinder-1
//
//  Created by E5000855 on 28/06/24.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    
    var titleLabel: UILabel!
    var detailsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    private func setupViews() {
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16) 
        contentView.addSubview(titleLabel)
        
        detailsLabel = UILabel()
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with reminder: Reminder) {
        titleLabel.text = reminder.title
        
        // Format latitude and longitude to 2 decimal places
        let formattedLatitude = String(format: "%.2f", reminder.latitude)
        let formattedLongitude = String(format: "%.2f", reminder.longitude)
        
        detailsLabel.text = "Lat: \(formattedLatitude) | Long: \(formattedLongitude)"
    }
}

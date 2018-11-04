//
//  TickerTableViewCell.swift
//  ScenarioTester
//
//  Created by Vaibhav Gattani on 3/11/18.
//  Copyright © 2018 Vaibhav Gattani. All rights reserved.
//

import Foundation
import UIKit

class TickerTableViewCell: UITableViewCell {
    
    var tickerLabel: UILabel!
    var percentageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tickerLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 30))
        tickerLabel.textAlignment = .left
        tickerLabel.font = UIFont(name: "Avenir-Next", size: 18)
        tickerLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(tickerLabel)
        
        percentageLabel = UILabel(frame: CGRect(x: 170, y: 0, width: 30, height: 30))
        percentageLabel.font = UIFont(name: "Avenir-Next", size: 18)
        percentageLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(percentageLabel)
        
    }
    
}

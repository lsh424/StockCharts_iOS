//
//  AdjustedLabel.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2021/05/15.
//  Copyright © 2021 LSH. All rights reserved.
//

import UIKit

class AdjustedLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.adjustsFontSizeToFitWidth = true
    }
}

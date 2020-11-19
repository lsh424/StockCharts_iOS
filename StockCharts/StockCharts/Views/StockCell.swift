//
//  StockCell.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/11.
//  Copyright © 2020 LSH. All rights reserved.
//

import UIKit

class StockCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stockGraphView: StockGraphView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var dateStackView: UIStackView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    lazy var colors: [UIColor]? = []
    
    var graphViewModel: StockGraphViewModel? {
        didSet{
            setupGraph(graphModel: graphViewModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupGraph(graphModel: StockGraphViewModel?) {
        guard let viewModel = graphViewModel else {
            companyNameLabel.text = nil
            highPriceLabel.text = nil
            lowPriceLabel.text = nil
            
            stockGraphView.graphPoints = []
            stockGraphView.startColor = UIColor(hex: "#282830")
            stockGraphView.middleColor = UIColor(hex: "#282830")
            stockGraphView.endColor = UIColor(hex: "#282830")
            self.dateStackView.arrangedSubviews.forEach { (subView) in
                let label = subView as? UILabel
                label?.text = nil
            }
            self.stockGraphView.setNeedsDisplay()
            
            return
        }
        
        self.noticeLabel.isHidden = true
        companyNameLabel.text = viewModel.companyName
        highPriceLabel.text = viewModel.highPrice
        lowPriceLabel.text = viewModel.lowPrice
        
        stockGraphView.graphPoints = viewModel.graphData.1
        
        if let colors = colors {
            stockGraphView.startColor = colors[0]
            stockGraphView.middleColor = colors[1]
            stockGraphView.endColor = colors[2]
        }
        
        DispatchQueue.main.async {
            self.stockGraphView.setNeedsDisplay()
            
            for i in 0...4 {
                if let label = self.dateStackView.arrangedSubviews[i] as? UILabel {
                    label.text = viewModel.dates[i]
                }
            }
        }
    }
}

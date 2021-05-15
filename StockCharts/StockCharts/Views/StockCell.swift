//
//  StockCell.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/11.
//  Copyright © 2020 LSH. All rights reserved.
//

import UIKit

enum Company: String {
    case google = "GOOGL"
    case tesla = "TSLA"
    case disney = "DIS"
    case apple = "AAPL"
    case cocacola = "KO"
    
    var colors: [UIColor] {
        switch self {
        case .google:
            return [UIColor(hex: "#4D7CE2"),UIColor(hex: "#E5B33D"),UIColor(hex: "#FF3B30")]
        case .tesla:
            return [UIColor(hex: "#C63331"),UIColor(hex: "#A62E2A"),UIColor(hex: "#872624")]
        case .disney:
            return [UIColor(hex: "#050B2E"),UIColor(hex: "#122868"),UIColor(hex: "#234090")]
        case .apple:
            return [UIColor(hex: "#C1C9CA"),UIColor(hex: "#949494"),UIColor(hex: "#949494")]
        case .cocacola:
            return [UIColor(hex: "#BD393B"),UIColor(hex: "#B4373B"),UIColor(hex: "#963336")]
        }
    }
}

class StockCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stockGraphView: StockGraphView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    @IBOutlet weak var dateStackView: UIStackView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    lazy var company: Company? = nil

    var graphViewModel: StockGraphViewModel? {
        didSet {
            guard let graphViewModel = graphViewModel else {
                self.indicator.startAnimating()
                self.company = nil
                self.graphViewModel = nil
                return
            }
            self.indicator.stopAnimating()
            self.noticeLabel.isHidden = true
            self.company = Company(rawValue: graphViewModel.companyName)
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
        
        if let colors = company?.colors {
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

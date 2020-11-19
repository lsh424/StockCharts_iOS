//
//  StockGraphViewModel.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/19.
//  Copyright © 2020 LSH. All rights reserved.
//

import UIKit

// MARK: - StockGraphViewModel
class StockGraphViewModel {
    let strokcGraph: StockGraph
    
    init(strokcGraph: StockGraph){
        self.strokcGraph = strokcGraph
    }
    
    var companyName: String {
        return strokcGraph.metaData.symbol
    }
    
    var graphData: ([String], [Float]) {
        var dates: [String] = []
        var points: [Float] = []
        strokcGraph.timeSeriesDaily.sorted {$0.0 < $1.0}.forEach { (date, value) in
            points.append(Float(value.adjustedClose)!)
            dates.append(date)
        }
        return (dates,points)
    }
    
    var dates: [String] {
        var dates: [String] = []
        let dateIndexs = [0,24,49,74,99]
        
        for i in dateIndexs {
            let dateComponents = graphData.0[i].components(separatedBy: ["-"])
            dates.append("\(dateComponents[1]).\(dateComponents[2])")
        }
        
        return dates
    }
    
    var highPrice: String {
        guard let highPrice = graphData.1.max() else {
            return "??"
        }
        
        return String(format: "%.2f",  highPrice)
    }
    
    var lowPrice: String {
        guard let lowPrice = graphData.1.min() else {
            return "??"
        }
        
        return String(format: "%.2f",  lowPrice)
    }
}



//
//  ViewController.swift
//  StockCharts
//
//  Created by seunghwan Lee on 2020/11/08.
//  Copyright © 2020 LSH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var graphViewModels: [StockGraphViewModel?] = [StockGraphViewModel?](repeating: nil, count: 5)
    var dataTasks : [URLSessionDataTask] = []
    
    var companies: [String] = ["GOOGL", "TSLA", "DIS", "AAPL", "KO"]
    
    var companyColors: [[UIColor]] = [[UIColor(hex: "#4D7CE2"),UIColor(hex: "#E5B33D"),UIColor(hex: "#FF3B30")],[UIColor(hex: "#C63331"),UIColor(hex: "#A62E2A"),UIColor(hex: "#872624")],[UIColor(hex: "#050B2E"),UIColor(hex: "#122868"),UIColor(hex: "#234090")], [UIColor(hex: "#C1C9CA"),UIColor(hex: "#949494"),UIColor(hex: "#949494")], [UIColor(hex: "#BD393B"),UIColor(hex: "#B4373B"),UIColor(hex: "#963336")]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
    }
    
    func setupCollectionView() {
        
        let layout = CarouselLayout()
        
        layout.itemSize = CGSize(width: 300, height: 250)
        layout.sideItemScale = 0.8
        layout.spacing = -100
        layout.isPagingEnabled = true
        
        collectionView.collectionViewLayout = layout
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.register(UINib(nibName: "StockCell", bundle: nil), forCellWithReuseIdentifier: "stockCell")
    }
    
    func setupNavigationBar() {
        
        let title = UILabel()
        title.text = "Stock Charts"
        title.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        title.sizeToFit()
        
        let leftItem = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return graphViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stockCell", for: indexPath) as! StockCell
        
        if let graphViewModel = graphViewModels[indexPath.row]{
            cell.indicator.stopAnimating()
            cell.noticeLabel.isHidden = true
            cell.colors = companyColors[indexPath.row]
            cell.graphViewModel = graphViewModel
        }else {
            cell.indicator.startAnimating()
            cell.colors = nil
            cell.graphViewModel = nil
            dataTasks = NetworkManager.shared.fetchData(companies: companies, dataTasks: dataTasks, index: indexPath.row) { [weak self] (stockGraph) in
                guard let graph = stockGraph else {
                    DispatchQueue.main.async {
                        cell.noticeLabel.isHidden = false
                        cell.indicator.stopAnimating()
                    }
                    return}
                
                self?.graphViewModels[indexPath.row] = StockGraphViewModel(strokcGraph: graph)
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: indexPath.row, section: 0)
                    
                    guard let collectionView = self?.collectionView else {return}
                    
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
                    }
                }
            }
        }
        return cell
    }
}

extension ViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            dataTasks = NetworkManager.shared.fetchData(companies: companies, dataTasks: dataTasks, index: indexPath.row) { [weak self] (stockGraph) in
                guard let graph = stockGraph else {return}
                
                self?.graphViewModels[indexPath.row] = StockGraphViewModel(strokcGraph: graph)
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: indexPath.row, section: 0)
                    
                    guard let collectionView = self?.collectionView else {return}
                    
                    if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                        collectionView.reloadItems(at: [IndexPath(row: indexPath.row, section: 0)])
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            dataTasks = NetworkManager.shared.cancelFetchData(companies: companies, index: indexPath.row, dataTasks: dataTasks)
        }
    }
}

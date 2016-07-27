//
//  TiledSummaryVC.swift
//  Spare
//
//  Created by Matt Quiros on 27/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case Graph = "Graph"
    case Cell = "Cell"
}

class TiledSummaryVC: UIViewController {
    
    var summary: Summary {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView
    var layoutManager: UICollectionViewFlowLayout
    
    init(summary: Summary) {
        self.summary = summary
        
        let layoutManager = UICollectionViewFlowLayout()
        layoutManager.scrollDirection = .Vertical
        self.layoutManager = layoutManager
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layoutManager)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = Color.White
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.registerNib(__SVCGraphView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Graph.rawValue)
        self.collectionView.registerNib(__TSVCCategoryCell.nib(), forCellWithReuseIdentifier: ViewID.Cell.rawValue)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TiledSummaryVC: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = glb_allCategories()
            else {
                return 0
        }
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.Cell.rawValue, forIndexPath: indexPath) as? __TSVCCategoryCell
            else {
                fatalError()
        }
        cell.info = self.summary.info?[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let graphView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.Graph.rawValue, forIndexPath: indexPath) as? __SVCGraphView
            where kind == UICollectionElementKindSectionHeader
            else {
                fatalError()
        }
        graphView.totalLabel.text = glb_displayTextForTotal(self.summary.total)
        graphView.summary = self.summary
        return graphView
    }
    
}

extension TiledSummaryVC: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let category = self.summary.info?[indexPath.item].0
            else {
                return
        }
        
        // Notify the container that a category cell has been tapped.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(
            Event.CategoryTappedInSummaryVC.rawValue,
            object: nil,
            userInfo: [
                "category" : category,
                "startDate" : self.summary.startDate,
                "endDate" : self.summary.endDate
            ])
    }
    
}

extension TiledSummaryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width * 0.8)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let side = (collectionView.bounds.size.width / 2) - 1
        return CGSizeMake(side, side)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}

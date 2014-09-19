//
//  ColorPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 9/18/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let kPadding = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the color picker cell Nib.
        self.collectionView.registerNib(UINib(nibName: Classes.ColorPickerCell, bundle: nil), forCellWithReuseIdentifier: Identifier.Cell.toRaw())
    }
    
    func colorNumberForIndexPath(indexPath: NSIndexPath) -> Int {
        let base = indexPath.section > 0 ? 1 : 0
        let offset = indexPath.section > 0 ? (5 * (indexPath.section - 1)) : 0
        let row = indexPath.row
        
        let colorNumber = base + offset + row
        return colorNumber
    }
    
}

// MARK: Private enum

extension ColorPickerViewController {
    
    private enum Identifier: String {
        case Cell = "Cell"
        case Header = "Header"
    }
    
}

// MARK: Collection view data source
extension ColorPickerViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return Colors.sections.count
    }
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            // The first section only has 1 color. All else has 5.
            if section == 0 {
                return 1
            }
            return 5
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Identifier.Cell.toRaw(), forIndexPath: indexPath) as ColorPickerCell
            cell.contents = (self.colorNumberForIndexPath(indexPath), false)
            return cell
    }
    
}

// MARK: Collection view flow layout
extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            // Five boxes should fit in a single row.
            let boxesPerRow = CGFloat(5)
            let numberOfPaddings = boxesPerRow + 1
            let availableWidth = self.collectionView.frame.size.width - (kPadding * numberOfPaddings)
            let side = availableWidth / boxesPerRow
            
            return CGSizeMake(CGFloat(side), CGFloat(side))
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return 0
    }
    
}
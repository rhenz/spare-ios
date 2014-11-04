//
//  ColorPickerViewController.swift
//  Spare
//
//  Created by Matt Quiros on 9/18/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// MARK: Protocol
protocol ColorPickerViewControllerDelegate {
    
    func colorPicker(colorPicker: ColorPickerViewController, didSelectColorNumber colorNumber: Int)
    
}

// MARK: Class
class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let kPadding = CGFloat(0)
    
    var selectedColorNumber = 0
    var delegate: ColorPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the nibs.
        self.collectionView.registerNib(ColorPickerHeader.nib(),
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: Identifier.Header.rawValue)
        self.collectionView.registerNib(ColorPickerCell.nib(),
            forCellWithReuseIdentifier: Identifier.Cell.rawValue)
    }
    
    @IBAction func selectButtonTapped(sender: UIBarButtonItem) {
        // Inform the delegate that a selection has been made.
        self.delegate?.colorPicker(self, didSelectColorNumber: self.selectedColorNumber)
        
        // Pop the view controller.
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func colorNumberForIndexPath(indexPath: NSIndexPath) -> Int {
        let base = indexPath.section > 0 ? 1 : 0
        let offset = indexPath.section > 0 ? (5 * (indexPath.section - 1)) : 0
        let row = indexPath.row
        
        let colorNumber = base + offset + row
        return colorNumber
    }
    
    func indexPathForColorNumber(colorNumber: Int) -> NSIndexPath {
        let base = colorNumber > 0 ? 1 : 0
        let row = (colorNumber - base) % 5
        let section = colorNumber > 0 ? (colorNumber - (base + row)) / 5 + 1 : 0
        
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        return indexPath
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
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Identifier.Cell.rawValue, forIndexPath: indexPath) as ColorPickerCell
            
            let colorNumber = self.colorNumberForIndexPath(indexPath)
            let selected = colorNumber == self.selectedColorNumber
            cell.contents = (colorNumber, selected)
            return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            if kind != UICollectionElementKindSectionHeader {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Identifier.Header.rawValue, forIndexPath: indexPath) as ColorPickerHeader
            header.section = Colors.sections[indexPath.section]
            return header
    }
    
}

// MARK: Collection view delegate
extension ColorPickerViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath) {
            let colorNumber = self.colorNumberForIndexPath(indexPath)
            if colorNumber == selectedColorNumber {
                // Do nothing if the selection is the same.
                return
            }
            
            let oldSelection = self.indexPathForColorNumber(self.selectedColorNumber)
            self.selectedColorNumber = colorNumber
            self.collectionView.reloadItemsAtIndexPaths([oldSelection, indexPath])
    }
    
}

// MARK: Collection view flow layout
extension ColorPickerViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: Header
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSizeMake(self.collectionView.frame.width, 26)
    }
    
    // MARK: Items
    
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
            let inset = CGFloat(6)
            return UIEdgeInsetsMake(inset, 0, inset, 0)
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
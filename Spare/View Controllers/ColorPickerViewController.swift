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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the color picker cell Nib.
        self.collectionView.registerNib(UINib(nibName: Classes.ColorPickerCell, bundle: nil), forCellWithReuseIdentifier: Identifier.Cell.toRaw())
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
            cell.contents = (0, false)
            return cell
    }
    
}
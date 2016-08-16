//
//  CategoryPickerDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 14/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CategoryPickerDelegate: NSObject {

    var categories: [Category]
    var selectedIndex: Int
    
    init(categories: [Category]) {
        self.categories = categories
        self.selectedIndex = 0
    }

}

extension CategoryPickerDelegate: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CustomPickerVC.ViewID.ItemCell.rawValue) as! CustomPickerCell
        
        cell.checkLabel.hidden = indexPath.row != self.selectedIndex
        cell.itemLabel.text = self.categories[indexPath.row].name
        
        return cell
    }
    
}

extension CategoryPickerDelegate: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let previousIndex = self.selectedIndex
        self.selectedIndex = indexPath.row
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: previousIndex, inSection: 0), NSIndexPath(forRow: indexPath.row, inSection: 0)], withRowAnimation: .None)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let maxWidth = UIScreen.mainScreen().bounds.size.width - (CustomPickerCell.ItemLabelLeading + CustomPickerCell.ItemLabelTrailing)
        let sizerLabel = CustomPickerCell.sizerLabel
        sizerLabel.text = self.categories[indexPath.row].name
        let labelSize = sizerLabel.sizeThatFits(CGSizeMake(maxWidth, CGFloat.max))
        let height = CustomPickerCell.ItemLabelTop + labelSize.height + CustomPickerCell.ItemLabelBottom
        return height
    }
    
}

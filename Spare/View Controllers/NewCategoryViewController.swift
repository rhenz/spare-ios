//
//  NewCategoryViewController.swift
//  Spare
//
//  Created by Matt Quiros on 9/18/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// MARK: Class declaration
class NewCategoryViewController: UIViewController {
    
    lazy var fields: [Field] = {
        return [Field(name: "Name"), Field(name: "Color", value: Colors.allColors.first)]
        }()
    
}

// MARK: Internal enums
extension NewCategoryViewController {
    
    private enum Row: Int {
        
        case Name = 0, Color
        
        init(_ int: Int) {
            switch int {
            case 0:
                self = .Name
            default:
                self = .Color
            }
        }
        
        func identifier() -> String {
            switch self {
            case .Name:
                return "kNameCell"
            default: // .Color
                return "kColorCell"
            }
        }
        
    }
    
}

// MARK: IBActions
extension NewCategoryViewController {
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: Table view data source
extension NewCategoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return self.fields.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let identifier = Row(indexPath.row).identifier()
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
            
            return cell
    }
    
}

// MARK: Table view delegate
extension NewCategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
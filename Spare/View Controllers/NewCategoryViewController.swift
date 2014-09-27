//
//  NewCategoryViewController.swift
//  Spare
//
//  Created by Matt Quiros on 9/18/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// Row numbers
private let kRowName = 0
private let kRowColor = 1
private let kRowDelete = 0

// Section numbers
private let kSectionFields = 0
private let kSectionDelete = 1

// Cell identifiers
private let kCellName = "kCellName"
private let kCellColor = "kCellColor"
private let kCellDelete = "kCellDelete"

// Alert view tags
private let kAlertViewConfirmDelete = 1000

// MARK: Class declaration
class NewCategoryViewController: UIViewController {
    
    // Lazy stored properties
    lazy var fields: [Field] = [Field("Name"), Field("Color", value: 0)]
    
    // Subview tags
    private let kTextFieldTag = 1000
    private let kColorBoxTag = 1000
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // Computed properties
    var isForEditing: Bool {
        if let category = self.categoryToEdit {
            return true
        }
        return false
    }
    
    // Stored properties
    var categoryToEdit: SPRCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.isForEditing ? "Edit Category" : "New Category"
        
        // Add a gesture recognizer to dismiss keyboard on tap.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isForEditing {
            self.fields[kRowName].value = self.categoryToEdit?.name
            self.fields[kRowColor].value = self.categoryToEdit?.colorNumber
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segues.ShowColorPicker {
            let colorPicker = segue.destinationViewController as ColorPickerViewController
            colorPicker.delegate = self
            
            let selectedColorNumber = self.fields[kRowColor].value as Int
            colorPicker.selectedColorNumber = selectedColorNumber
        }
    }
}

// MARK: Target actions
extension NewCategoryViewController {
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.hideKeyboard()
        self.validateCategoryWithCompletion({[unowned self] errorMessage in
            if let message = errorMessage {
                UIAlertView(title: "Missing fields", message: message, delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                self.saveCategoryWithCompletion({[unowned self] savedCategory in
                    if let category = savedCategory {
                        // Post a notification that a new category has been added.
                        let notificationCenter = NSNotificationCenter.defaultCenter()
                        notificationCenter.postNotificationName(Notifications.CategoryAdded, object: category)
                        
                        // Dismiss the modal.
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        UIAlertView(title: "Error", message: "Failed to save category.", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                })
            }
        })
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func validateCategoryWithCompletion(completionBlock: (String?) -> ()) {
        // Only check the Name field for nullity. The color field is defaulted to 0.
        var missingFields = [String]()
        let nameField = self.fields[kRowName]
        if let value = nameField.value {
            let stringValue = value as String
            if stringValue.isEmpty {
                missingFields.append(nameField.name)
            }
        } else {
            missingFields.append(nameField.name)
        }
        
        if missingFields.count > 0 {
            completionBlock("You must enter a category name.")
        } else {
            completionBlock(nil)
        }
    }
    
    func saveCategoryWithCompletion(completionBlock: (SPRCategory?) -> ()) {
        let document = SPRManagedDocument.sharedDocument()
        let category = NSEntityDescription.insertNewObjectForEntityForName(Classes.Category, inManagedObjectContext: document.managedObjectContext) as SPRCategory
        
        // Set the values.
        category.name = self.fields[kRowName].value! as NSString
        category.colorNumber = NSNumber(integer: (self.fields[kRowColor].value! as Int))
        
        // Append the category to the end of the list.
        let numberOfCategories = SPRCategory.allCategories().count
        let displayOrder = numberOfCategories > 0 ? numberOfCategories - 1 : 0
        category.displayOrder = NSNumber(integer: displayOrder)
        
        // Save the document.
        document.saveWithCompletionHandler({[unowned self] success in
            if success {
                completionBlock(category)
            } else {
                completionBlock(nil)
            }
        })
    }
    
}

// MARK: Table view data source
extension NewCategoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.isForEditing {
            // The second section just contains a delete button.
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            switch section {
            case kSectionFields:
                return self.fields.count
            case kSectionDelete:
                return 1
            default:
                return 0
            }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // Get the identifier.
            var identifier: String!
            switch indexPath.section {
            case kSectionFields:
                let fieldIdentifiers = [kCellName, kCellColor]
                identifier = fieldIdentifiers[indexPath.row]
            case kSectionDelete:
                identifier = kCellDelete
            default: ()
            }
            
            // Get the cell.
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
            
            if indexPath.section == kSectionFields {
                switch indexPath.row {
                case kRowName:
                    let textField = cell.viewWithTag(kTextFieldTag) as FormTextField
                    textField.field = self.fields[indexPath.row]
                    textField.delegate = self
                default:
                    let colorBox = cell.viewWithTag(kColorBoxTag)
                    let colorNumber = self.fields[kRowColor].value as Int
                    colorBox?.backgroundColor = Colors.allColors[colorNumber]
                }
            }
            
            return cell
    }
    
}

// MARK: Table view delegate
extension NewCategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            // For the delete button, show a confirmation dialog.
            if indexPath.section == kSectionDelete {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
                self.confirmDelete()
                return
            }
            
            // Do nothing when the Name cell is selected.
            // Only the Color cell has a dedicated action.
            if indexPath.row == kRowName {
                return
            }
            
            // Reassert the background color of the color box so that it does
            // not disappear with the table view cell highlight.
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let colorBox = cell?.viewWithTag(kColorBoxTag)
            let colorNumber = (self.fields[kRowColor].value as NSNumber).integerValue
            colorBox?.backgroundColor = Colors.allColors[colorNumber]
            
            // Remove the table view cell highlight.
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Segue to the color picker.
            self.performSegueWithIdentifier(Segues.ShowColorPicker, sender: self)
    }
    
    func confirmDelete() {
        let message = "Deleting a category also deletes all expenses in it. This can't be undone. Are you sure?"
        let proceedButton = "Yes, delete!"
        let alertView = UIAlertView(title: DialogTitles.Confirm.toRaw(), message: message, delegate: self, cancelButtonTitle: DialogButtons.Cancel.toRaw(), otherButtonTitles: proceedButton)
        alertView.tag = kAlertViewConfirmDelete
        alertView.show()
    }
    
}

// MARK: Text field delegate
extension NewCategoryViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            if let field = (textField as FormTextField).field {
                // Replace the field's old value with the new one.
                var oldValue: NSString?
                if let value = field.value {
                    oldValue = field.value as? NSString
                } else {
                    oldValue = ""
                }
                let newValue = oldValue?.stringByReplacingCharactersInRange(range, withString: string)
                field.value = newValue
            }
            
            return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        if let field = (textField as FormTextField).field {
            field.value = nil
        }
        return true
    }
    
}

// MARK: Alert view delegate
extension NewCategoryViewController: UIAlertViewDelegate {
    
    func alertView(alertView: UIAlertView,
        clickedButtonAtIndex buttonIndex: Int) {
            if alertView.tag == kAlertViewConfirmDelete {
                if buttonIndex == 1 {
                    // Proceed deletion.
                    if let category = self.categoryToEdit {
                        let displayOrder = category.displayOrder
                        let context = category.managedObjectContext
                        context.deleteObject(category)
                        
                        let document = SPRManagedDocument.sharedDocument()
                        document.saveWithCompletionHandler {[unowned self] success in
                            if success {
                                // Post a notification that the category has been deleted.
                                let notificationCenter = NSNotificationCenter.defaultCenter()
                                notificationCenter.postNotificationName(Notifications.CategoryDeleted, object: displayOrder)
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    }
                }
            }
    }
    
}

// MARK: Color picker delegate
extension NewCategoryViewController: ColorPickerViewControllerDelegate {
    
    func colorPicker(colorPicker: ColorPickerViewController,
        didSelectColorNumber colorNumber: Int) {
            let field = self.fields[kRowColor]
            field.value = colorNumber
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: kRowColor, inSection: 0)], withRowAnimation: .Automatic)
    }
    
}
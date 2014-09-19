//
//  NewCategoryViewController.swift
//  Spare
//
//  Created by Matt Quiros on 9/18/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// MARK: Protocol
protocol NewCategoryViewControllerDelegate {
    
    func newCategoryViewController(newCategoryViewController: NewCategoryViewController,
        didAddCategory category: SPRCategory)
    
}

// MARK: Class declaration
class NewCategoryViewController: UIViewController {
    
    lazy var fields: [Field] = {
        return [Field("Name"), Field("Color", value: 0)]
        }()
    
    private let kTextFieldTag = 1000
    private let kColorBoxTag = 1000
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: NewCategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a gesture recognizer to dismiss keyboard on tap.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segues.ShowColorPicker {
            let colorPicker = segue.destinationViewController as ColorPickerViewController
            colorPicker.delegate = self
            
            let selectedColorNumber = self.fields[Row.Color.toRaw()].value as Int
            colorPicker.selectedColorNumber = selectedColorNumber
        }
    }
}

// MARK: Private enums
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
                        // Inform the delegate that a category has been added.
                        self.delegate?.newCategoryViewController(self, didAddCategory: category)
                        
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
        let nameField = self.fields[Row.Name.toRaw()]
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
        category.name = self.fields[Row.Name.toRaw()].value! as NSString
        category.colorNumber = NSNumber(integer: (self.fields[Row.Color.toRaw()].value! as Int))
        
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
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return self.fields.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let row = Row(indexPath.row)
            let identifier = row.identifier()
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell
            
            switch row {
            case .Name:
                let textField = cell.viewWithTag(kTextFieldTag) as FormTextField
                textField.field = self.fields[indexPath.row]
                textField.delegate = self
            default:
                let colorBox = cell.viewWithTag(kColorBoxTag)
                let colorNumber = self.fields[Row.Color.toRaw()].value as Int
                colorBox?.backgroundColor = Colors.allColors[colorNumber]
            }
            
            return cell
    }
    
}

// MARK: Table view delegate
extension NewCategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            // Do nothing when the Name cell is selected.
            if indexPath.row == Row.Name.toRaw() {
                return
            }
            
            // Reassert the background color of the color box so that it does
            // not disappear with the table view cell highlight.
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let colorBox = cell?.viewWithTag(kColorBoxTag)
            let colorNumber = (self.fields[Row.Color.toRaw()].value as NSNumber).integerValue
            colorBox?.backgroundColor = Colors.allColors[colorNumber]
            
            // Remove the table view cell highlight.
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            // Segue to the color picker.
            self.performSegueWithIdentifier(Segues.ShowColorPicker, sender: self)
    }
    
}

// MARK: Text field delegate
extension NewCategoryViewController: UITextFieldDelegate {
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            let field = (textField as FormTextField).field
            
            // Replace the field's old value with the new one.
            var oldValue: NSString?
            if let value = field.value {
                oldValue = field.value as? NSString
            } else {
                oldValue = ""
            }
            let newValue = oldValue?.stringByReplacingCharactersInRange(range, withString: string)
            field.value = newValue
            
            return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        let field = (textField as FormTextField).field
        field.value = nil
        return true
    }
    
}

// MARK: Color picker delegate

extension NewCategoryViewController: ColorPickerViewControllerDelegate {
    
    func colorPicker(colorPicker: ColorPickerViewController,
        didSelectColorNumber colorNumber: Int) {
            let field = self.fields[Row.Color.toRaw()]
            field.value = colorNumber
            self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: Row.Color.toRaw(), inSection: 0)], withRowAnimation: .Automatic)
    }
    
}
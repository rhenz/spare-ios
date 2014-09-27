//
//  NewExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 2/09/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// MARK: Class
class NewExpenseViewController: UIViewController {

    private struct Row {
        
        static let Description = 0
        static let Amount = 1
        static let Category = 2
        static let DateSpent = 3
        
    }
    
    private let kCellIdentifiers = ["kDescriptionCell", "kAmountCell", "kCategoryCell", "kDateSpentCell"]
    
    private let kTextFieldTag = 1000
    
    @IBOutlet weak private var tableView: UITableView!

    private lazy var fields: [Field] = {
        return [Field("Description"),
            Field("Amount"),
            Field("Category", value: AppState.sharedState.preselectedCategory),
            Field("Date spent", value: NSDate.simplifiedDate())]
    }()
    
    lazy var categoryPickerCell: CategoryPickerCell = {
        let cell = NSBundle.mainBundle().loadNibNamed(Classes.CategoryPickerCell, owner: self, options: nil).last as CategoryPickerCell
        cell.delegate = self
        return cell
        }()
    
    lazy var datePickerCell: DatePickerCell = {
        let cell = NSBundle.mainBundle().loadNibNamed(Classes.DatePickerCell, owner: self, options: nil).last as DatePickerCell
        cell.delegate = self
        return cell
        }()

    // MARK: View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: Target actions

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        // Hide keyboard and collapse all cells.
        self.hideKeyboard()
        self.categoryPickerCell.collapse()
        self.datePickerCell.collapse()
        
        self.validateExpenseWithCompletion({[unowned self] in
            if let message = $0 {
                let alert = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.saveExpenseWithCompletion({[unowned self] expense in
                    // Send a notification that an expense has been saved.
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName(Notifications.ExpenseAdded, object: expense)
                    
                    // Dismiss modal or popover.
                    let idiom = UIDevice.currentDevice().userInterfaceIdiom
                    switch idiom {
                    case .Phone:
                        self.dismissViewControllerAnimated(true, completion: nil)
                    default: ()
                    }
                })
            }
        })
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }

    func validateExpenseWithCompletion(completionBlock: (String?) -> ()) {
        // Enumerate the missing fields.
        var missingFields = [String]()
        for field in self.fields {
            if let value = field.value {
                // Make sure that empty strings are considered missing.
                if let stringValue = value as? String {
                    if stringValue.isEmpty {
                        missingFields.append(field.name)
                    }
                }
            } else {
                missingFields.append(field.name)
            }
        }
        
        if (missingFields.count > 0) {
            let message = String(format: "You must enter the following:\n%@", ", ".join(missingFields))
            completionBlock(message)
        } else {
            completionBlock(nil)
        }
    }

    func saveExpenseWithCompletion(completionBlock: (SPRExpense) -> ()) {
        let document = SPRManagedDocument.sharedDocument()
        let expense = NSEntityDescription.insertNewObjectForEntityForName(Classes.Expense, inManagedObjectContext: document.managedObjectContext) as SPRExpense
        
        expense.name = self.fields[Row.Description].value as NSString
        expense.amount = NSDecimalNumber.decimalNumberWithString(self.fields[Row.Amount].value as NSString)
        expense.category = self.fields[Row.Category].value as SPRCategory
        expense.dateSpent = self.fields[Row.DateSpent].value as NSDate
        expense.displayOrder = NSNumber.numberWithInt(0)

        document.saveWithCompletionHandler({[unowned self] success in
            completionBlock(expense)
        })
    }
    
}

// MARK: Table view data source
extension NewExpenseViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell: UITableViewCell
            switch indexPath.row {
            case Row.Description, Row.Amount:
                cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifiers[indexPath.row]) as UITableViewCell
                let textField = cell.viewWithTag(kTextFieldTag) as FormTextField?
                textField?.field = self.fields[indexPath.row]
                textField?.delegate = self
            
            case Row.Category:
                cell = self.categoryPickerCell
                
            default: // Row.DateSpent
                cell = self.datePickerCell
            }
            
            return cell
    }
    
}

// MARK: Table view delegate
extension NewExpenseViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            switch indexPath.row {
            case Row.Category:
                let height = self.categoryPickerCell.height
                return height
            case Row.DateSpent:
                let height = self.datePickerCell.height
                return height
            default:
                return UITableViewAutomaticDimension
            }
    }
    
}

// MARK: Category picker cell delegate
extension NewExpenseViewController: CategoryPickerCellDelegate {
    
    func categoryPickerCellDidToggle(categoryPickerCell: CategoryPickerCell) {
        self.hideKeyboard()
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        // Scroll the cell to the middle if it has been expanded.
        if categoryPickerCell.isExpanded {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: Row.Category, inSection: 0),
                atScrollPosition: .Middle, animated: true)
        }
    }
    
    func categoryPickerCell(categoryPickerCell: CategoryPickerCell,
        didSelectCategory category: SPRCategory) {
            self.fields[Row.Category].value = category
    }
    
}

// MARK: Date picker delegate
extension NewExpenseViewController: DatePickerCellDelegate {
    
    func datePickerCellDidToggle(datePickerCell: DatePickerCell) {
        self.hideKeyboard()
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        // Scroll the cell to the middle if it has been expanded.
        if datePickerCell.isExpanded {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: Row.DateSpent, inSection: 0),
                atScrollPosition: .Middle, animated: true)
        }
    }
    
    func datePickerCell(datePickerCell: DatePickerCell, didSelectDate date: NSDate) {
        self.fields[Row.DateSpent].value = date
    }
    
}

// MARK: Text field delegate
extension NewExpenseViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Collapse the picker cells if a text field will begin editing.
        self.categoryPickerCell.collapse()
        self.datePickerCell.collapse()
        return true
    }
    
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            if let field = (textField as FormTextField).field {
                // If this is the Amount field, check if the characters are valid.
                if field === self.fields[Row.Amount] {
                    let invalidCharacterSet = NSCharacterSet(charactersInString: "1234567890.").invertedSet
                    if string.intersectsWithCharacterSet(invalidCharacterSet) {
                        return false
                    }
                }
                
                // Update the field's value.
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
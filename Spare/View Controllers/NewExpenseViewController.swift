//
//  NewExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 2/09/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

private struct Row {
    
    static let Description = 0
    static let Amount = 1
    static let Category = 2
    static let DateSpent = 3
    
}

let kCellIdentifiers = ["kDescriptionCell", "kAmountCell", "kCategoryCell", "kDateSpentCell"]

class NewExpenseViewController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!

    var categorySummary: CategorySummary?

    private lazy var fields: [Field] = {
        return [Field(name: "Description"), Field(name: "Amount"), Field(name: "Category", value: self.categorySummary!.category), Field(name: "Date spent", value: NSDate.simplifiedDate())]
    }()
    
    lazy var categoryPickerCell: CategoryPickerCell = {
        let cell = NSBundle.mainBundle().loadNibNamed(Classes.CategoryPickerCell, owner: self, options: nil).last as CategoryPickerCell
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
        self.validateExpenseWithCompletion({[unowned self] in
            if let message = $0 {
                let alert = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            } else {
                self.saveExpenseWithCompletion({[unowned self] expense in
                    // Send a notification that an expense has been saved.
                    let notificationCenter = NSNotificationCenter.defaultCenter()
                    notificationCenter.postNotificationName(Notifications.NewExpense, object: expense)
                })
            }
        })
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }

    func validateExpenseWithCompletion(completionBlock: (_: String?) -> ()) {
        // Enumerate the missing fields.
        var missingFields = [String]()
        for field in self.fields {
            if (field.value? as String).isEmpty {
                missingFields.append(field.name!)
            }
        }
        
        if (missingFields.count > 0) {
            let message = String(format: "You must enter the following:\n%@", ", ".join(missingFields))
            completionBlock(message)
        } else {
            completionBlock(nil)
        }
    }

    func saveExpenseWithCompletion(completionBlock: (_: SPRExpense) -> ()) {
        let document = SPRManagedDocument.sharedDocument()
        let expense = NSEntityDescription.insertNewObjectForEntityForName(Classes.Expense, inManagedObjectContext: document.managedObjectContext) as SPRExpense
        expense.name = self.fields[Row.Description].value as NSString
        expense.amount = NSDecimalNumber.decimalNumberWithString(self.fields[Row.Amount].value as NSString)
        expense.category = self.categorySummary!.category
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
            if indexPath.row == Row.Category {
                let cell = self.categoryPickerCell
                return cell
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifiers[indexPath.row]) as UITableViewCell
            return cell
    }
    
}

// MARK: Table view delegate
extension NewExpenseViewController: UITableViewDelegate {

    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            switch indexPath.row {
            case Row.Category:()
            case Row.DateSpent:
                ()
            default: ()
            }
    }
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            switch indexPath.row {
            case Row.Category:
                return self.categoryPickerCell.height
            default:
                return UITableViewAutomaticDimension
            }
    }
    
}

// MARK: Category picker cell delegate
extension NewExpenseViewController: CategoryPickerCellDelegate {
    
    func categoryPickerCellDidToggleExpandMode(categoryPickerCell: CategoryPickerCell) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}
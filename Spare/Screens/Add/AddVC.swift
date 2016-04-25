//
//  AddVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class AddVC: BaseVC {
    
    let customView = __AVCView.instantiateFromNib() as __AVCView
    let tabController = UITabBarController(nibName: nil, bundle: nil)
    
    override init() {
        super.init()
        self.title = "Add New"
        self.tabBarItem.title = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addCancelAndDoneBarButtonItems()
        
        self.tabController.viewControllers = [UIViewController(), EditCategoryVC(category: nil)]
        self.tabController.tabBar.hidden = true
        self.embedChildViewController(self.tabController, toView: self.customView.tabContainer, fillSuperview: true)
        
        self.customView.segmentedControl.addTarget(self, action: #selector(handleTapOnSegmentedControl(_:)), forControlEvents: .ValueChanged)
    }
    
    override func handleTapOnCancelBarButtonItem(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func handleTapOnDoneBarButtonItem(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleTapOnSegmentedControl(sender: AnyObject) {
        guard let segmentedControl = sender as? UISegmentedControl
            else {
                return
        }
        self.tabController.selectedIndex = segmentedControl.selectedSegmentIndex
    }
    
}

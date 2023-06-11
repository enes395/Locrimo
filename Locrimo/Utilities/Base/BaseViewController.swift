//
//  BaseViewController.swift
//  Locrimo
//
//  Created by Tahir Anil Oghan on 16.03.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    func setupNavBar(title: String?, leftIcon: String?, rightIcon: String?, leftItemAction: Selector? = nil, rightItemAction: Selector? = nil) {
        if let leftIcon = leftIcon {
            let leftItem = UIBarButtonItem(image: UIImage(systemName: leftIcon)?.withRenderingMode(.automatic), style: .done, target: self, action: leftItemAction == nil ? #selector(goBack) : leftItemAction)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        
        if let rightIcon = rightIcon {
            let rightItem = UIBarButtonItem(image: UIImage(systemName: rightIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: rightItemAction)
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        self.title = title
        
    }
    
    @objc func goBack() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

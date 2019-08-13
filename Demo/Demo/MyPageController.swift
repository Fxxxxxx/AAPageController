//
//  MyPageController.swift
//  AAPageController
//
//  Created by Aaron on 2019/4/16.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
import AAPageController

class MyPageController: AAPageController {
    
    var ctrs: [UIViewController] = [FirstTableViewController(), SecondTableViewController()]
    var titles = ["first", "second"]
    
    override func viewDidLoad() {
        
        for _ in 0..<10 {
            ctrs += [FirstTableViewController(), SecondTableViewController()]
            titles += ["first", "second"]
        }
        
        self.selectedColor = .purple
        self.dataSource = self
        self.delegate = self
        self.topBarItemWidth = 0
        self.topBarItemSpace = 10
        self.topBarHeight = 50
        super.viewDidLoad()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyPageController: AAPageControllerDataSource, AAPageControllerDelegate {
    
    func indexOfChildController(pageController: AAPageController, child: UIViewController) -> Int {
        return ctrs.firstIndex(of: child)!
    }
    
    func numbersOfChildControllers(pageController: AAPageController) -> Int {
        return ctrs.count
    }
    
    func childControllers(pageController: AAPageController, index: Int) -> UIViewController {
        return ctrs[index]
    }
    
    func titlesForChildControllers(pageController: AAPageController, index: Int) -> String {
        return "\(titles[index]) \(index)"
    }
    
    func pageController(_: AAPageController, didDisplayedChildAt index: Int) {
        print("display at: \(index)")
    }
    
}

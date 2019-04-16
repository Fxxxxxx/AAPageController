//
//  MyPageController.swift
//  AAPageController
//
//  Created by Aaron on 2019/4/16.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit

class MyPageController: AAPageController {
    
    var ctrs: [UIViewController] = [FirstTableViewController(), SecondTableViewController()]
    var titles = ["first", "second"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0..<10 {
            ctrs += [FirstTableViewController(), SecondTableViewController()]
            titles += ["first", "second"]
        }
        
        self.selectedColor = .purple
        self.dataSource = self
        self.topBarItemWidth = UIScreen.main.bounds.width / 6
        self.topBarHeight = 50
        self.bottomLineWidth = 30
        
        start()
        
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

extension MyPageController: AAPageControllerDataSource {
    
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
    
}

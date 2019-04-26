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
        super.viewDidLoad()
        for _ in 0..<10 {
            ctrs += [FirstTableViewController(), SecondTableViewController()]
            titles += ["first", "second"]
        }
        
        self.selectedColor = .purple
        self.dataSource = self
        self.delegate = self
        self.topBarItemWidth = UIScreen.main.bounds.width / 6
        self.topBarHeight = 50
        
        bottomView = UIView.init(frame: CGRect.init(origin: .zero, size: .init(width: 6, height: 6)))
        bottomView?.backgroundColor = .white

        let path = UIBezierPath.init()
        path.move(to: .init(x: 3, y: 0))
        path.addLine(to: .init(x: 6, y: 6))
        path.addLine(to: .init(x: 0, y: 6))
        path.close()
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.green.cgColor
        bottomView?.layer.addSublayer(shapeLayer)
        
        setUI()
        
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

//
//  AAPageControllerProtocol.swift
//  AAPageController
//
//  Created by Aaron on 2019/4/16.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
import Foundation

public protocol AAPageControllerDataSource: NSObjectProtocol {
    //需要显示的子控制器数量
    func numbersOfChildControllers(pageController: AAPageController) -> Int
    //子控制器对应的标题
    func titlesForChildControllers(pageController: AAPageController, index: Int) -> String
    //序号对应的子控制器
    func childControllers(pageController: AAPageController, index: Int) -> UIViewController
    //子控制器对应的序号
    func indexOfChildController(pageController: AAPageController, child: UIViewController) -> Int
}

extension AAPageControllerDataSource {
    func titlesForChildControllers(pageController: AAPageController, index: Int) -> String {
        return "\(index)"
    }
}

//
//  AAPageController.swift
//  AAPageController
//
//  Created by Aaron on 2019/4/16.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit

open class AAPageController: UIViewController {
    
    //DataSource  & delegate
    public weak var dataSource: AAPageControllerDataSource?
    public weak var delegate: AAPageControllerDelegate?
    
    private var currentIndex = 0
    private var nextIndex: Int?
    public func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    public var topBarHeight: CGFloat = 30.0
    public var topBarItemWidth: CGFloat = 50.0
    public var topBarOriginY: CGFloat?
    public var topBarItemFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var topBarItemSelectedFont: UIFont?
    public var bottomViewWidth: CGFloat?
    public var selectedColor: UIColor = .blue
    
    //UI
    public lazy var topBar: UICollectionView = {
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.register(AAItemCell.self, forCellWithReuseIdentifier: "CELL")
        return collection
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: topBarItemWidth, height: topBarHeight)
        return layout
    }()
    private lazy var pageController: UIPageViewController = {
        let ctr = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        ctr.dataSource = self
        ctr.delegate = self
        return ctr
    }()
    public var bottomView: UIView?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if topBarOriginY == nil {
            topBarOriginY = UIApplication.shared.statusBarFrame.height
            if let navBar = self.navigationController?.navigationBar {
                topBarOriginY! += navBar.isHidden ? 0 :navBar.bounds.height
            }
        }
        
    }
    
    open func setUI() {
        
        topBar.frame = CGRect.init(x: 0, y: topBarOriginY!, width: view.bounds.width, height: topBarHeight)
        view.addSubview(topBar)
        
        if bottomView == nil {
            bottomViewWidth = bottomViewWidth ?? topBarItemWidth
            bottomView = UIView()
            bottomView?.frame = CGRect.init(x: 0, y: topBarHeight - 1, width: bottomViewWidth!, height: 1)
            bottomView?.backgroundColor = selectedColor
        }
        topBar.addSubview(bottomView!)
        bottomView?.frame.origin.y = topBarHeight - (bottomView?.bounds.height ?? 0)
        bottomView?.center.x = topBarItemWidth / 2

        self.addChild(pageController)
        pageController.view.frame = CGRect.init(x: 0, y: topBar.frame.origin.y + topBarHeight, width: view.bounds.width, height: view.bounds.height - topBar.frame.maxY)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        if let currentCtr = dataSource?.childControllers(pageController: self, index: currentIndex) {
            pageController.setViewControllers([currentCtr], direction: .forward, animated: false, completion: nil)
        }
        
    }
    
    public func reloadData() {
        topBar.reloadData()
        scrollToChildController(of: 0)
    }
    
    //显示对应的子控制器
    private func scrollToChildController(of index: Int) {
        let total = dataSource?.numbersOfChildControllers(pageController: self) ?? 0
        guard index < total else {
            return
        }
        if let ctr = dataSource?.childControllers(pageController: self, index: index) {
            pageController.setViewControllers([ctr], direction: index > currentIndex ? .forward : .reverse, animated: true, completion: nil)
            currentIndex = index
            let currentIndexPath = IndexPath.init(item: currentIndex, section: 0)
            topBar.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
            topBar.reloadItems(at: topBar.indexPathsForVisibleItems)
            delegate?.pageController(self, didDisplayedChildAt: currentIndex)
            UIView.animate(withDuration: 0.35) {
                self.bottomView?.center.x = (CGFloat(self.currentIndex) + 0.5) * self.topBarItemWidth
            }
        }
    }

}

extension AAPageController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numbersOfChildControllers(pageController: self) ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! AAItemCell
        cell.label.text = dataSource?.titlesForChildControllers(pageController: self, index: indexPath.item)
        if indexPath.item == currentIndex {
            cell.label.textColor = selectedColor
            cell.label.font = topBarItemSelectedFont ?? topBarItemFont
        } else {
            cell.label.font = topBarItemFont
            cell.label.textColor = .black
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != currentIndex else {
            return
        }
        scrollToChildController(of: indexPath.item)
    }
    
}

extension AAPageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let total = dataSource?.numbersOfChildControllers(pageController: self) ?? 0
        guard total > 1 else {
            return nil
        }
        let next = (currentIndex + total - 1) % total
        return dataSource?.childControllers(pageController: self, index: next)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let total = dataSource?.numbersOfChildControllers(pageController: self) ?? 0
        guard total > 1 else {
            return nil
        }
        let next = (currentIndex + total + 1) % total
        return dataSource?.childControllers(pageController: self, index: next)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        nextIndex = dataSource?.indexOfChildController(pageController: self, child: pendingViewControllers.first!)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            nextIndex = nil
            return
        }
        if let index = nextIndex {
            currentIndex = index
            nextIndex = nil
            let currentIndexPath = IndexPath.init(item: currentIndex, section: 0)
            topBar.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
            topBar.reloadItems(at: topBar.indexPathsForVisibleItems)
            delegate?.pageController(self, didDisplayedChildAt: currentIndex)
            UIView.animate(withDuration: 0.35) {
                self.bottomView?.center.x = (CGFloat(self.currentIndex) + 0.5) * self.topBarItemWidth
            }
        }
    }
    
}

private class AAItemCell: UICollectionViewCell {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.frame = contentView.bounds
        label.textAlignment = .center
        contentView.addSubview(label)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

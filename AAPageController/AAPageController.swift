//
//  AAPageController.swift
//  AAPageController
//
//  Created by Aaron on 2019/4/16.
//  Copyright © 2019 Aaron. All rights reserved.
//

import UIKit
import SnapKit

open class AAPageController: UIViewController {
    
    //DataSource  & delegate
    public weak var dataSource: AAPageControllerDataSource?
    public weak var delegate: AAPageControllerDelegate?
    
    private var currentIndex = -1
    private var nextIndex: Int?
    public func getCurrentIndex() -> Int {
        return currentIndex
    }
    
    public var topBarHeight: CGFloat = 30.0
    public var topBarItemWidth: CGFloat = 50.0
    public var topBarItemSpace: CGFloat = 0.0
    public var topBarOriginY: CGFloat = 0.0
    public var topBarItemFont: UIFont = UIFont.systemFont(ofSize: 16)
    public var topBarItemSelectedFont: UIFont?
    public var indexTagViewWidth: CGFloat = 20.0
    public var selectedColor: UIColor = .blue
    public var normalTitleColor: UIColor = .darkText
    
    //UI
    public lazy var topBar: UICollectionView = {
        let collection = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.register(AAItemCell.nib(), forCellWithReuseIdentifier: "CELL")
        return collection
    }()
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = topBarItemSpace
        layout.minimumInteritemSpacing = topBarItemSpace
        return layout
    }()
    private lazy var pageController: UIPageViewController = {
        let ctr = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        ctr.dataSource = self
        ctr.delegate = self
        return ctr
    }()
    public var indexTagView = UIView()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.clipsToBounds = true
        setTopBar()
        setPageView()
    }
    
    open func setTopBar() {
        guard !topBar.isHidden else { return }
        view.addSubview(topBar)
        topBar.snp.makeConstraints { (maker) in
            maker.top.equalTo(view.snp.topMargin).offset(topBarOriginY)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(topBarHeight)
        }
        
        indexTagView.backgroundColor = selectedColor
        indexTagView.frame = .init(x: -indexTagViewWidth, y: topBarHeight - 2, width: indexTagViewWidth, height: 2)
        topBar.addSubview(indexTagView)
    }
    
    open func setPageView() {
        self.addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        pageController.view.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(view.snp.topMargin).offset(topBarOriginY + topBarHeight)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.scrollToChildController(of: 0)
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
            nextIndex = index
            pageViewController(pageController, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: true)
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
            cell.label.textColor = normalTitleColor
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != currentIndex else {
            return
        }
        scrollToChildController(of: indexPath.item)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = topBarItemWidth
        if width == 0 {
            let title = dataSource?.titlesForChildControllers(pageController: self, index: indexPath.item) ?? ""
            var font = indexPath.item == currentIndex ? topBarItemSelectedFont : topBarItemFont
            font = font ?? topBarItemFont
            let rect = NSString.init(string: title).boundingRect(with: .init(width: 0, height: topBarHeight), options: .usesLineFragmentOrigin, attributes: [.font: font!], context: nil)
            width = rect.width + 5
        }
        return .init(width: width, height: topBarHeight)
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
            if let frame = layout.layoutAttributesForItem(at: currentIndexPath)?.frame {
                UIView.animate(withDuration: 0.35) {
                    self.indexTagView.center.x = frame.midX
                }
            }
        }
    }
    
}


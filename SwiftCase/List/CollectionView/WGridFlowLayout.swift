//
//  WGridFlowLayout.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/6.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

protocol WGridFlowLayoutDelegate: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, columnCountForSection section: Int) -> Int
}

class WGridFlowLayout: UICollectionViewFlowLayout {
    
    // 显式的列数 默认两列
    var columnCount = 2
    // 存放所有item的attribute属性
    var itemAttributes = [UICollectionViewLayoutAttributes]()
    // 存放所有header、footer的attribute属性
    var supplementaryAttributes = [[String: UICollectionViewLayoutAttributes]]()
    var contentHeight: CGFloat = 0
    var headerHeight: CGFloat = 0
    var footerHeight: CGFloat = 0
    var delegate: WGridFlowLayoutDelegate?
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.minimumInteritemSpacing = 2
        self.minimumLineSpacing = 2
    }
    
    override func prepare() {
        contentHeight = 0
        itemAttributes.removeAll()
        supplementaryAttributes.removeAll()
        let numberOfSections: Int = (self.collectionView?.numberOfSections)!
        for section in 0..<numberOfSections {
            if let delegate = self.delegate, let collectionView = self.collectionView {
                minimumInteritemSpacing = delegate.collectionView!(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section)
                minimumLineSpacing = delegate.collectionView!(collectionView, layout: self, minimumLineSpacingForSectionAt: section)
                sectionInset = delegate.collectionView!(collectionView, layout: self, insetForSectionAt: section)
                columnCount = delegate.collectionView(collectionView, layout: self, columnCountForSection: section)
            }
            
            contentHeight += sectionInset.top
            
            // header frame
            var supplementary = [String: UICollectionViewLayoutAttributes]()
            if headerHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath.init(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: contentHeight, width: (self.collectionView?.frame.size.width)!, height: headerHeight)
                itemAttributes.append(attributes)
                supplementary[UICollectionElementKindSectionHeader] = attributes
                contentHeight = attributes.frame.maxY
            }
            
            // 存储列中最高的
            var columnHeights = [CGFloat]()
            for i in 0..<columnCount {
                columnHeights[i] = contentHeight
            }
            
            // item frame
            let itemCount: Int = (self.collectionView?.numberOfItems(inSection: section))!
            for i in 0..<itemCount {
                let indexPath = IndexPath(item: i, section: section)
                // 返回数组最小值对应的索引值，即找出位置高度最短的一列
                let columnIndex = columnHeights.index(of: columnHeights.min()!)
                var size = self.itemSize
                if let delegate = self.delegate, let collectionView = self.collectionView {
                     size = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                }
                let x = sectionInset.left + (size.width + CGFloat(minimumInteritemSpacing)) * CGFloat(columnCount)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: x, y: columnHeights[columnIndex!], width: size.width, height: size.height)
                itemAttributes.append(attributes)
                columnHeights[columnIndex!] = attributes.frame.maxY + minimumLineSpacing
            }
            contentHeight = columnHeights.max()!
            if itemCount == 0 {
                contentHeight += UIScreen.main.bounds.size.height
            }
            // footer frame
            if footerHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: contentHeight, width: (self.collectionView?.frame.size.width)!, height: footerHeight)
                itemAttributes.append(attributes)
                supplementary[UICollectionElementKindSectionFooter] = attributes
                contentHeight = attributes.frame.maxY
            }
            supplementaryAttributes.append(supplementary)
            contentHeight += sectionInset.bottom
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: (self.collectionView?.frame.size.width)!, height: contentHeight)
    }
    
    // 返回当前屏幕视图框内item（可见的item）的属性，可以直接返回所有item属性，指定区域的cell布局对象
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = itemAttributes.filter { (attr) -> Bool in
            return rect.intersects(attr.frame);
        }
        return array
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var index = indexPath.item
        for section in 0..<indexPath.section {
            index += (self.collectionView?.numberOfItems(inSection: section))!
        }
        return self.itemAttributes[index]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementaryAttributes[indexPath.section][elementKind]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = (self.collectionView?.bounds)!
        if newBounds.width != oldBounds.width {
            return true
        }
        return false
    }
    
}

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
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepare() {
        contentHeight = 0
        itemAttributes.removeAll()
        supplementaryAttributes.removeAll()
        let numberOfSections: Int = collectionView!.numberOfSections
        for section in 0..<numberOfSections {
            if let interitemSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) {
                minimumInteritemSpacing = interitemSpacing
            }
            if let lineSpacing = delegate?.collectionView?(collectionView!, layout: self, minimumLineSpacingForSectionAt: section) {
                minimumLineSpacing = lineSpacing
            }
            if let inset = delegate?.collectionView?(collectionView!, layout: self, insetForSectionAt: section) {
                sectionInset = inset
            }
            if let count = delegate?.collectionView(collectionView!, layout: self, columnCountForSection: section) {
                columnCount = count
            }
            
            contentHeight += sectionInset.top
            
            // header frame
            var supplementary = [String: UICollectionViewLayoutAttributes]()
            if headerHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: contentHeight, width: collectionView!.frame.width, height: headerHeight)
                itemAttributes.append(attributes)
                supplementary[UICollectionElementKindSectionHeader] = attributes
                contentHeight = attributes.frame.maxY
            }
            
            // 存储列中最高的
            var columnHeights: [CGFloat] = []
            for i in 0..<columnCount {
                columnHeights.insert(contentHeight, at: i)
            }
            
            // item frame
            let itemCount: Int = collectionView!.numberOfItems(inSection: section)
            for i in 0..<itemCount {
                let indexPath = IndexPath(item: i, section: section)
                // 返回数组最小值对应的索引值，即找出位置高度最短的一列
                let columnIndex = columnHeights.index(of: columnHeights.min()!)!
                if let size = delegate?.collectionView?(collectionView!, layout: self, sizeForItemAt: indexPath) {
                    itemSize = size
                }
                let x = sectionInset.left + (itemSize.width + CGFloat(minimumInteritemSpacing)) * CGFloat(columnIndex)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: x, y: columnHeights[columnIndex], width: itemSize.width, height: itemSize.height)
                itemAttributes.append(attributes)
                columnHeights[columnIndex] = attributes.frame.maxY + minimumLineSpacing
            }
            contentHeight = columnHeights.max()!
            if itemCount == 0 {
                contentHeight += UIScreen.main.bounds.size.height
            }
            // footer frame
            if footerHeight > 0 {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(x: 0, y: contentHeight, width: collectionView!.frame.width, height: footerHeight)
                itemAttributes.append(attributes)
                supplementary[UICollectionElementKindSectionFooter] = attributes
                contentHeight = attributes.frame.maxY
            }
            supplementaryAttributes.append(supplementary)
            contentHeight += sectionInset.bottom
        }
        
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: contentHeight)
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
            index += collectionView!.numberOfItems(inSection: section)
        }
        return self.itemAttributes[index]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementaryAttributes[indexPath.section][elementKind]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.width != collectionView!.bounds.width {
            return true
        }
        return false
    }
    
}

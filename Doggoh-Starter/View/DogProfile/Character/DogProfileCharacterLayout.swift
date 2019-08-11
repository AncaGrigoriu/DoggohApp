//
//  DogProfileLayout.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 08/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

protocol DogProfileCharacterDelegate: class {
    func collectionView(_ collectionView:UICollectionView, widthForItemAtIndexPath indexPath:IndexPath) -> CGFloat
}

struct DogProfileCharacterConstants {
    public static let numberOfRows = 3
    public static let xCellPadding: CGFloat = 8
    public static let yCellPadding: CGFloat = 8
}

class DogProfileCharacterLayout: UICollectionViewFlowLayout {
    
    weak var delegate: DogProfileCharacterDelegate!
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentWidth: CGFloat = 0
    
    private var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.height - (insets.top + insets.bottom)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        let rowHeight = contentHeight / CGFloat(DogProfileCharacterConstants.numberOfRows)
        
        var yOffset = [CGFloat]()
        for row in 0..<DogProfileCharacterConstants.numberOfRows {
            yOffset.append(CGFloat(row) * rowHeight)
        }
        
        var row = 0
        var xOffset = [CGFloat](repeating: 0, count: DogProfileCharacterConstants.numberOfRows)
        
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let labelWidth = delegate.collectionView(collectionView, widthForItemAtIndexPath: indexPath)
            let width = DogProfileCharacterConstants.xCellPadding * 2.0 + labelWidth
            let frame = CGRect(x: xOffset[row], y: yOffset[row], width: width, height: rowHeight)
            
            let insetFrame = frame.insetBy(dx: DogProfileCharacterConstants.xCellPadding, dy: DogProfileCharacterConstants.yCellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentWidth = max(contentWidth, frame.maxX)
            xOffset[row] = xOffset[row] + width
            
            row = row < (DogProfileCharacterConstants.numberOfRows - 1) ? (row + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.row]
    }
}

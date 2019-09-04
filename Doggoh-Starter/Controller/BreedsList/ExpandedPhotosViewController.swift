//
//  ExpandedPhotosViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 02/09/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import CoreData

class ExpandedPhotosViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let collectionViewCellIdentifier = "MaximizedDogPhotoCollectionViewCell"

    var onDismissCompletion: ((_ currentPage: Int) -> Void)?
    var viewmodel: ExpanededPhotoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = viewmodel.numberOfPhotos()
        pageControl.currentPage = 0
        
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        
        photosCollectionView.showsHorizontalScrollIndicator = false
        
        registerCell(collectionViewCellIdentifier)
        
        photosCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let indexPath = IndexPath(item: viewmodel.currentPhotoIndex, section: 0)
        photosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    func registerCell(_ id: String) {
        let nib = UINib(nibName: id, bundle: .main)
        photosCollectionView.register(nib, forCellWithReuseIdentifier: id)
    }
}

extension ExpandedPhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.numberOfPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! MaximizedDogPhotoCollectionViewCell
        cell.delegate = self
        cell.viewmodel = viewmodel.cellViewModel(atIndexPath: indexPath)

        return cell
    }
}

extension ExpandedPhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = photosCollectionView.bounds.size
        return CGSize(width: size.width - 20, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl()
    }
    
    private func updatePageControl() {
        let visibleRect = CGRect(origin: photosCollectionView.contentOffset, size: photosCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = photosCollectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
}

extension ExpandedPhotosViewController: MaximizedDogPhotoCollectionViewCellDelegate {
    func minimize() {
        onDismissCompletion?(pageControl.currentPage)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

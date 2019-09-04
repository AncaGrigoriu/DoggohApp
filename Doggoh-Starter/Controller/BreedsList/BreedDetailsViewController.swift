//
//  BreedDetailsViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit
import CoreData

class BreedDetailsViewController: UIViewController {
    
    @IBOutlet weak var breedPhotosCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lateralGradientView: UIView!
    
    let collectionViewCellIdentifier = "BreedDetailsCollectionViewCell"

    var isInitialCellLoading = true
    var viewmodel: BreedDetailsViewModel!
    var coordinator: BreedsCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coordinator.detailsFlowDelegate = self
        
        pageControl.numberOfPages = viewmodel.photosCount
        pageControl.currentPage = 0
        
        viewmodel.onImagesLoaded = reloadImagesData
        
        configureNavigationBar()
        configureGradientViews()
        
        breedPhotosCollectionView.dataSource = self
        breedPhotosCollectionView.delegate = self
        breedPhotosCollectionView.showsHorizontalScrollIndicator = false
        breedPhotosCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 110)
        
        registerCell(collectionViewCellIdentifier)
    }
    
    func configureNavigationBar() {
        self.title = viewmodel.navigationBarTitleString
        
        let backImage = UIImage(named: "backButton")
        let barButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBackToList))
        barButton.tintColor = UIColor(named: "backButtonColor")
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    func configureGradientViews() {        
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.84).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
        
        let lateralGradient = CAGradientLayer()
        lateralGradient.frame = lateralGradientView.bounds
        lateralGradient.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0.59).cgColor]
        lateralGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        lateralGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        lateralGradientView.layer.insertSublayer(lateralGradient, at: 0)
    }
    
    @objc func goBackToList() {
        navigationController?.popViewController(animated: true)
    }
    
    func registerCell(_ id: String) {
        let nib = UINib(nibName: id, bundle: .main)
        breedPhotosCollectionView.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func reloadImagesData() {
        isInitialCellLoading = true
        breedPhotosCollectionView.reloadData()
    }
}

extension BreedDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfImages = viewmodel.numberOfImages()
        pageControl.numberOfPages = numberOfImages
        return numberOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! BreedDetailsCollectionViewCell
        cell.delegate = self
        cell.viewmodel = viewmodel.cellViewModel(atIndexPath: indexPath)
        
        if isInitialCellLoading && indexPath.row == 1 {
            applyTransformation(for: cell as UICollectionViewCell, with: 0.9)
            isInitialCellLoading = false
        }
        
        return cell
    }
    
    private func applyTransformation(for cell: UICollectionViewCell, with scale: CGFloat) {
        let currentHeight = cell.bounds.height
        
        var transformation = CGAffineTransform.identity
        transformation = transformation.translatedBy(x: 0, y: currentHeight * (1 - scale) / 2)
        transformation = transformation.scaledBy(x: scale, y: scale)
        
        cell.transform = transformation
    }
}

extension BreedDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePhotosScale(scrollView)
        updatePageControl()
    }
    
    private func updatePhotosScale(_ scrollView: UIScrollView) {
        let centerX = breedPhotosCollectionView.center.x
        
        for cell in breedPhotosCollectionView.visibleCells {
            let basePosition = cell.convert(CGPoint.zero, to: self.view)
            let cellCenterX = basePosition.x + breedPhotosCollectionView.frame.size.height / 2.0
            
            let distance = abs(cellCenterX - centerX)
            
            let scrollTolerance : CGFloat = 0.05
            var scale = 1.0 + scrollTolerance - ((distance / centerX) * 0.1)
            
            if(scale > 1.0){
                scale = 1.0
            }
            
            if(scale < 0.9){
                scale = 0.9
            }
            
            applyTransformation(for: cell, with: scale)
        }
    }
    
    private func updatePageControl() {
        let visibleRect = CGRect(origin: breedPhotosCollectionView.contentOffset, size: breedPhotosCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = breedPhotosCollectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = visibleIndexPath.row
        }
    }
}

extension BreedDetailsViewController: BreedDetailsCollectionViewCellDelegate {
    func expand() {
        coordinator.onImageSelected(atIndex: pageControl.currentPage)
    }
}

extension BreedDetailsViewController: BreedDetailsFlowDelegate {
    func showMaximizedPictures(withViewController viewController: ExpandedPhotosViewController) {
        self.navigationController!.present(viewController, animated: true, completion: nil)
    }
    
    func goBack(_ imageIndex: Int) {
        let indexPath = IndexPath(row: imageIndex, section: 0)
        breedPhotosCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

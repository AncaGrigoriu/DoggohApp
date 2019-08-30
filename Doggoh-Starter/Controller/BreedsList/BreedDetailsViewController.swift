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
    
    var breed: Breed!
    var breedIndexPath: IndexPath!
    var isInitialCellLoading = true
    
    let photosCount = 4
    let collectionViewCellIdentifier = "BreedDetailsCollectionViewCell"
    
    @IBOutlet weak var breedPhotosCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lateralGradientView: UIView!
    
    var fetchRC: NSFetchedResultsController<BreedImage>?
    var images: [BreedImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = photosCount
        pageControl.currentPage = 0
        
        getRandomImages()
        configureNavigationBar()
        configureGradientViews()
        
        breedPhotosCollectionView.dataSource = self
        breedPhotosCollectionView.delegate = self
        
        breedPhotosCollectionView.showsHorizontalScrollIndicator = false
        
        registerCell(collectionViewCellIdentifier)
        
        breedPhotosCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 110)
    }
    
    func configureNavigationBar() {
        let isSingularBreed = (breed.specificBreedName.lowercased() == breed.generalBreedName.lowercased())
        let subBreedNameValue = !isSingularBreed ? "\(breed.specificBreedName.uppercased()) " : ""
        let breedName = breed.generalBreedName.uppercased()
        self.title = "\(subBreedNameValue)\(breedName)"
        
        let backImage = UIImage(named: "backButton")
        let barButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
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
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func registerCell(_ id: String) {
        let nib = UINib(nibName: id, bundle: .main)
        breedPhotosCollectionView.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func getRandomImages() {
        if let dogImages = breed.breedPhotos,
            dogImages.count > 0 {
            images = dogImages.allObjects as? [BreedImage]
        } else {
            DogImagesRepository.getImages(for: breed, withCount: photosCount) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("error: \(error)")
                    case .success(_):
                        if let dogImages = self.breed.breedPhotos {
                            self.images = dogImages.allObjects as? [BreedImage]
                        }
                        self.isInitialCellLoading = true
                        self.breedPhotosCollectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension BreedDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! BreedDetailsCollectionViewCell
        let data = images![indexPath.row].image
        cell.breedImageView.image = UIImage(data: data as Data)
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

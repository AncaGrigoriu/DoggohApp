//
//  BreedDetailsViewController.swift
//  Doggoh-Starter
//
//  Created by Anca Grigoriu on 19/08/2019.
//  Copyright © 2019 Endava Internship 2019. All rights reserved.
//

import UIKit

class BreedDetailsViewController: UIViewController {
    
    var breedName: String!
    var subBreedName: String?
    var photos = [UIImage]()
    
    let photosCount = 3
    
    let collectionViewCellIdentifier = "BreedDetailsCollectionViewCell"
    
    @IBOutlet weak var breedPhotosCollectionView: UICollectionView!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRandomImages()
        configureNavigationBar()
        configureGradientView()
        
        breedPhotosCollectionView.dataSource = self
        breedPhotosCollectionView.delegate = self
        
        registerCell(collectionViewCellIdentifier)
    }
    
    func configureNavigationBar() {
        let subBreedNameValue = subBreedName != nil ? "\(subBreedName!.uppercased()) " : ""
        self.title = "\(subBreedNameValue)\(breedName ?? "")"
        
        let backImage = UIImage(named: "backButton")
        let barButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(goBack))
        barButton.tintColor = UIColor(named: "backButtonColor")
        
        navigationItem.leftBarButtonItem = barButton
    }
    
    func configureGradientView() {        
        let gradient = CAGradientLayer()
        
        gradient.frame = gradientView.bounds
        gradient.colors = [UIColor(red: 1, green: 1, blue: 1, alpha: 0.84).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func registerCell(_ id: String) {
        let nib = UINib(nibName: id, bundle: .main)
        breedPhotosCollectionView.register(nib, forCellWithReuseIdentifier: id)
    }
    
    func getRandomImages() {
        DogImagesRepository.getRandomImages(forBreed: breedName.lowercased(), withCount: photosCount) { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let values):
                do {
                    for itemURL in values {
                        let data = try Data(contentsOf: URL(string: itemURL)!)
                        let image = UIImage(data: data)!
                        self.photos.append(image)
                    }
                } catch let error {
                    print("error: \(error)")
                }
                
                DispatchQueue.main.async {
                    self.breedPhotosCollectionView.reloadData()
                }
            }
        }
    }
}

extension BreedDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! BreedDetailsCollectionViewCell
        if photos.count > indexPath.row {
            cell.breedImageView.image = photos[indexPath.row]
        }
        return cell
    }
}

extension BreedDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: 340)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

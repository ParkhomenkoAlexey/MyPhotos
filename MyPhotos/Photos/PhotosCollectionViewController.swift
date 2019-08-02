//
//  PhotosCollectionViewController.swift
//  MyPhotos
//
//  Created by Алексей Пархоменко on 30/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    let networkDataFetcher = NetworkDataFetcher()
    
    let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    
    var photos = [UnsplashPhoto]()
    
    private let itemsPerRow: CGFloat = 3 // относится к UICollectionViewDelegateFlowLayout
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0) // относится к UICollectionViewDelegateFlowLayout
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        
        return UIBarButtonItem(barButtonSystemItem: .add,
                               target: self,
                               action: #selector(addBarButtonTapped(sender:)))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action,
                               target: self,
                               action: #selector(actionBarButtonTapped(sender:)))
    }()
    
    var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        collectionView.allowsMultipleSelection = true
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.layoutMargins = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        collectionView.backgroundColor = .white
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        
        setupNavigationBar()
        setupSearchBar()
        
        if let waterfallLayout = collectionViewLayout as? WaterfallLayout {
            waterfallLayout.delegate = self
        }
    }
    
    func setupNavigationBar() {
        let titleLabel = UILabel(text: "PHOTOS", font: .systemFont(ofSize: 15, weight: .medium), textColor: #colorLiteral(red: 0.5, green: 0.5, blue: 0.5, alpha: 1))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
        navigationController?.hidesBarsOnSwipe = true
        actionBarButtonItem.isEnabled = false
        addBarButtonItem.isEnabled = false
    }
    
    func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    func updateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    @objc private func addBarButtonTapped(sender: AnyObject?) {
        print(#function)
        
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem) {
        
        var selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosss, indexPath) -> [UIImage] in
            var mutablePhotos = photosss
            

            let photo = photos[indexPath.item]
            print(photo.urls)
            let photoUrl = photo.urls["small"]
            let imageView = UIImageView()
            imageView.setImage(imageURL: photoUrl)
            guard let image = imageView.image else { return mutablePhotos }
            mutablePhotos.append(image)
            
            
            return mutablePhotos
        })
        print("selectedPhotos:", selectedPhotos)
        
        let shareController = UIActivityViewController(activityItems: selectedPhotos ?? [UIImage](), applicationActivities: nil)
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController,
                animated: true,
                completion: nil)
        selectedPhotos?.removeAll()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
    }
}

// MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                self?.photos = searchResults?.results ?? []
                self?.collectionView.reloadData()
            }
        })
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

//extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let photo = photos[indexPath.item]
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = view.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
//        return CGSize(width: widthPerItem, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}

// MARK: - WaterfallLayoutDelegate
extension PhotosCollectionViewController: WaterfallLayoutDelegate {
    func waterfallLayout(_ layout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let photo = photos[indexPath.item]
        //        print("photo.width: \(photo.width) photo.height: \(photo.height)\n")
        return CGSize(width: photo.width, height: photo.height)
    }
}

extension PhotosCollectionViewController: UITabBarControllerDelegate {
    
}






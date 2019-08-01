//
//  PhotosCell.swift
//  MyPhotos
//
//  Created by Алексей Пархоменко on 30/07/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class PhotosCell: UICollectionViewCell {
    
    static let reuseId = "PhotosCell"
    
    private var checkmark: UIImageView = {
        let image = UIImage(named: "checkmark")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override var isSelected: Bool {
        
        didSet {
            print(isSelected)
            updateSelectedState()
        }
    }
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["small"]
            photoImageView.setImage(imageURL: photoUrl)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.setImage(imageURL: nil)


    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSelected = false
        setupPhotoImageView()
        setupCheckmarkView()
        updateSelectedState()
    }
    
    private func updateSelectedState() {
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
        
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupCheckmarkView() {
        addSubview(checkmark)
        checkmark.rightAnchor.constraint(equalTo: photoImageView.rightAnchor, constant:  -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant:  -8).isActive = true        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

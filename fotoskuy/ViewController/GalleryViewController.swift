//
//  GalleryViewController.swift
//  fotoskuy
//
//  Created by Kevin Harijanto on 07/04/22.
//

import UIKit
import Photos

class GalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var imageArray = [UIImage]()
    @IBOutlet weak var labelNoPhotos: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Gallery"
        
        labelNoPhotos.alpha = 0
        
        let layout = UICollectionViewFlowLayout()
        
        galleryCollectionView.collectionViewLayout = layout
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        galleryCollectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: "Cell")
        
        grabPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoItemCell
        cell.img.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "imagePreview") as! ImagePreviewViewController
        viewController.imageArray = self.imageArray
        viewController.passedContentOffset = indexPath
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4 - 1, height: collectionView.frame.width/4 - 1)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        galleryCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    private func grabPhotos() {
        imageArray = []
        
        print("Loading images")
        
        DispatchQueue.global(qos: .background).async {
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .opportunistic
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let phAssetCollection = SingletonCustomPhotoAlbum.sharedInstance.fetchAssetCollectionForAlbum()
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: phAssetCollection!, options: fetchOptions)
            
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count {
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width: 32, height: 32), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("No photos")
                DispatchQueue.main.async {
                    self.labelNoPhotos.alpha = 1
                }
            }
            
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
                self.galleryCollectionView.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.galleryCollectionView.alpha = 1
                })
            }
        }
    }
}

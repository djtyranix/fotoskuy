//
//  ImagePreviewViewController.swift
//  fotoskuy
//
//  Created by Michael Ricky on 11/04/22.
//

import UIKit
import Photos

class ImagePreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var previewCollectionView: UICollectionView!
    var imageArray = [UIImage]()
    var indexArray = [Int]()
    var passedContentOffset = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UIFlowLayoutCustom()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        previewCollectionView.collectionViewLayout = layout
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        previewCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        previewCollectionView.isPagingEnabled = true
        
        DispatchQueue.main.async {
            self.previewCollectionView.scrollToItem(at: self.passedContentOffset, at: .centeredHorizontally, animated: false)
        }
        
        reloadWithHDPicture(index: passedContentOffset.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        
        cell.imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: previewCollectionView.frame.width - (previewCollectionView.safeAreaInsets.left + previewCollectionView.safeAreaInsets.right) , height: previewCollectionView.frame.height - (previewCollectionView.safeAreaInsets.top + previewCollectionView.safeAreaInsets.bottom))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = previewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = previewCollectionView.frame.size
        flowLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let offset = previewCollectionView.contentOffset
        let width = previewCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        previewCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.previewCollectionView.reloadData()
            self.previewCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
    private func reloadWithHDPicture(index: Int) {
        DispatchQueue.global(qos: .default).async {
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .opportunistic
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let phAssetCollection = SingletonCustomPhotoAlbum.sharedInstance.fetchAssetCollectionForAlbum()
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: phAssetCollection!, options: fetchOptions)
            
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: CGSize(width: 1024, height: 1024), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                self.imageArray[index] = image!
                self.indexArray.append(index)
            })
            
            DispatchQueue.main.async {
                self.previewCollectionView.reloadData()
            }
        }
    }
    
    private func releaseMemoryFromBigImage(index: Int) {
        DispatchQueue.global(qos: .background).async {
            let imgManager = PHImageManager.default()
            
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .opportunistic
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            let phAssetCollection = SingletonCustomPhotoAlbum.sharedInstance.fetchAssetCollectionForAlbum()
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(in: phAssetCollection!, options: fetchOptions)
            
            imgManager.requestImage(for: fetchResult.object(at: index) as PHAsset, targetSize: CGSize(width: 32, height: 32), contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                self.imageArray[index] = image!
            })
        }
    }
    
    class UIFlowLayoutCustom: UICollectionViewFlowLayout {
        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexes = previewCollectionView.indexPathsForVisibleItems
//        print(indexes)
        DispatchQueue.global().async {
            for i in self.indexArray {
                self.releaseMemoryFromBigImage(index: i)
            }
        }
        
        for i in indexes {
            reloadWithHDPicture(index: i.row)
        }
    }
}

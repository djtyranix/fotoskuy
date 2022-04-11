//
//  ImagePreviewViewController.swift
//  fotoskuy
//
//  Created by Michael Ricky on 11/04/22.
//

import UIKit

class ImagePreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var previewCollectionView: UICollectionView!
    var imageArray = [UIImage]()
    var passedContentOffset = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        previewCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        previewCollectionView.delegate = self
        previewCollectionView.dataSource = self
        previewCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        previewCollectionView.isPagingEnabled = true
        previewCollectionView.scrollToItem(at: IndexPath(item: 4, section: 0), at: .left, animated: true)
        previewCollectionView.showsHorizontalScrollIndicator = false
        
        
        self.view.addSubview(previewCollectionView)
        
        previewCollectionView.autoresizingMask = UIView.AutoresizingMask(
            rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue))
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        
        cell.imageView.image = imageArray[indexPath.row]
        
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = previewCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = previewCollectionView.frame.size
        flowLayout.invalidateLayout()
        
        previewCollectionView.collectionViewLayout.invalidateLayout()
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
}

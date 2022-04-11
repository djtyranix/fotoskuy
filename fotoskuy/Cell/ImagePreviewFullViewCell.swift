//
//  ImagePreviewFullViewCell.swift
//  fotoskuy
//
//  Created by Michael Ricky on 11/04/22.
//

import UIKit

class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var scrollImage: UIScrollView!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollImage = UIScrollView()
        scrollImage.delegate = self
        scrollImage.alwaysBounceVertical = false
        scrollImage.alwaysBounceHorizontal = false
        scrollImage.showsVerticalScrollIndicator = false
        scrollImage.showsHorizontalScrollIndicator = false
        scrollImage.flashScrollIndicators()
        
        scrollImage.minimumZoomScale = 1.0
        scrollImage.maximumZoomScale = 4.0
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollImage.addGestureRecognizer(doubleTapGesture)
        
        self.addSubview(scrollImage)
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "user3")
        imageView.contentMode = .scaleAspectFit
        scrollImage.addSubview(imageView!)
    }
    
    @objc private func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        switch scrollImage.zoomScale {
        case 1:
            scrollImage.zoom(to: zoomRectForScale(scale: scrollImage.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
            
        default:
            scrollImage.setZoomScale(1, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = imageView.convert(center, from: scrollImage)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImage.frame = self.bounds
        imageView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImage.setZoomScale(1, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

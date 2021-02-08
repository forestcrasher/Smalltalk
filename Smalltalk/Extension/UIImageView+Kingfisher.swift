//
//  UIImageView+Kingfisher.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 17.12.2020.
//

import Foundation
import Kingfisher

extension UIImageView {

    func setImage(with url: URL?) {
        if let downloadURL = url {
            let processor = DownsamplingImageProcessor(size: self.superview?.bounds.size ?? CGSize(width: 0, height: 0))
            let resourse = ImageResource(downloadURL: downloadURL, cacheKey: downloadURL.absoluteString)
            self.kf.setImage(with: resourse, options: [.processor(processor), .loadDiskFileSynchronously, .backgroundDecode])
        }
    }

}

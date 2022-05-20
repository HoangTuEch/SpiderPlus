//
//  SPPhotoBrowserController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import Foundation
import ImageViewer

class SPPhotoBrowserController: NSObject {

    var items: [GalleryItem] = []

    static func presentPhotoBrowser(on viewController: UIViewController, photos: [Any], startIndex: Int) {
        guard photos.count > 0 else { return }

        let photoBrowserController = SPPhotoBrowserController()

        for item in photos {
            var galleryItem: GalleryItem?

            if let image = item as? UIImage {
                galleryItem = GalleryItem.image {$0(image) }
            }

            if let aGalleryItem = galleryItem {
                photoBrowserController.items .append(aGalleryItem)
            }

        }

        guard photoBrowserController.items.count > 0 else { return }

        let galleryViewController = GalleryViewController(startIndex: startIndex,
                                                          itemsDataSource: photoBrowserController,
                                                          configuration: galleryConfiguration())
        viewController.presentImageGallery(galleryViewController)
    }

    private static func galleryConfiguration() -> GalleryConfiguration {
        return [
            GalleryConfigurationItem.deleteButtonMode(.none),
            GalleryConfigurationItem.thumbnailsButtonMode(.none),
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffect.Style.light),
            GalleryConfigurationItem.videoControlsColor(.white),
            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }
}

extension SPPhotoBrowserController: GalleryItemsDataSource {

    func itemCount() -> Int {
        return items.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {
        return items[index]
    }
}

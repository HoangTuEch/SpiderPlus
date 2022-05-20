//
//  PDFEditView+UIPinchGestureRecognizer.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/20/22.
//

import UIKit

// MARK: - UIPinchGestureRecognizer
extension PDFEditView {

    @objc func pinch(_ sender: UIPinchGestureRecognizer) {
        if currentTextOrButtonAnnotation == nil {
            return
        }
        if sender.state == .ended || sender.numberOfTouches < 2 {
            return
        }

        let location = sender.location(in: sender.view)
        guard let page = pdfView.page(for: location,
                                      nearest: true) else { return }

        page.removeAnnotation(currentTextOrButtonAnnotation)

        let dx = currentTextOrButtonAnnotation.bounds.width * sender.scale - currentTextOrButtonAnnotation.bounds.width
        let dy = currentTextOrButtonAnnotation.bounds.height * sender.scale - currentTextOrButtonAnnotation.bounds.height

        let width = currentTextOrButtonAnnotation.bounds.width + dx
        let newWidth = width < currentTextAnnotationMinWidth ? currentTextAnnotationMinWidth : width

        let height = currentTextOrButtonAnnotation.bounds.height + dy
        let newHeight = height < currentTextAnnotationMinHeight ? currentTextAnnotationMinHeight : height

        let touch1 = sender.location(ofTouch: 0, in: sender.view)
        let touch2 = sender.location(ofTouch: 1, in: sender.view)

        let deltaTouchX = abs( touch1.x - touch2.x )
        let deltaTouchY = abs( touch1.y - touch2.y )
        let ratio = deltaTouchX / deltaTouchY

        let horizontal = deltaTouchY == 0 || ratio > 2
        let vertical = deltaTouchX == 0 || ratio < 0.5

        if horizontal || vertical {
            currentTextOrButtonAnnotation.bounds = CGRect(x: currentTextOrButtonAnnotation.bounds.origin.x,
                                                  y: currentTextOrButtonAnnotation.bounds.origin.y,
                                                  width: horizontal ? newWidth : currentTextOrButtonAnnotation.bounds.width,
                                                  height: vertical ? newHeight : currentTextOrButtonAnnotation.bounds.height)
        } else {
            currentTextOrButtonAnnotation.bounds = CGRect(x: currentTextOrButtonAnnotation.bounds.origin.x,
                                                  y: currentTextOrButtonAnnotation.bounds.origin.y,
                                                  width: newWidth,
                                                  height: newHeight)
        }

        page.addAnnotation(currentTextOrButtonAnnotation)

        sender.scale = 1.0
    }

}

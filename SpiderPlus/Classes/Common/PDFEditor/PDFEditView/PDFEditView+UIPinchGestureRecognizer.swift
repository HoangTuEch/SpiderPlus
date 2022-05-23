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
        if currentTextAnnotation == nil {
            return
        }
        if sender.state == .ended || sender.numberOfTouches < 2 {
            return
        }

        let location = sender.location(in: sender.view)
        guard let page = pdfView.page(for: location,
                                      nearest: true) else { return }

        page.removeAnnotation(currentTextAnnotation)

        let dx = currentTextAnnotation.bounds.width * sender.scale - currentTextAnnotation.bounds.width
        let dy = currentTextAnnotation.bounds.height * sender.scale - currentTextAnnotation.bounds.height

        let width = currentTextAnnotation.bounds.width + dx
        let newWidth = width < currentTextAnnotationMinWidth ? currentTextAnnotationMinWidth : width

        let height = currentTextAnnotation.bounds.height + dy
        let newHeight = height < currentTextAnnotationMinHeight ? currentTextAnnotationMinHeight : height

        let touch1 = sender.location(ofTouch: 0, in: sender.view)
        let touch2 = sender.location(ofTouch: 1, in: sender.view)

        let deltaTouchX = abs( touch1.x - touch2.x )
        let deltaTouchY = abs( touch1.y - touch2.y )
        let ratio = deltaTouchX / deltaTouchY

        let horizontal = deltaTouchY == 0 || ratio > 2
        let vertical = deltaTouchX == 0 || ratio < 0.5

        if horizontal || vertical {
            currentTextAnnotation.bounds = CGRect(x: currentTextAnnotation.bounds.origin.x,
                                                  y: currentTextAnnotation.bounds.origin.y,
                                                  width: horizontal ? newWidth : currentTextAnnotation.bounds.width,
                                                  height: vertical ? newHeight : currentTextAnnotation.bounds.height)
        } else {
            currentTextAnnotation.bounds = CGRect(x: currentTextAnnotation.bounds.origin.x,
                                                  y: currentTextAnnotation.bounds.origin.y,
                                                  width: newWidth,
                                                  height: newHeight)
        }

        page.addAnnotation(currentTextAnnotation)

        sender.scale = 1.0
    }

}

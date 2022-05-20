//
//  PDFAnnotation+RemovePath.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import PDFKit
import Foundation

extension PDFAnnotation {

    func removePath(at point: CGPoint) -> PDFAnnotation? {
        if type == "Widget" {
            if bounds.contains(point) {
                page?.removeAnnotation(self)
                return self
            }
            return nil
        }

        guard let paths = paths else { return nil }
        for path in paths {
            let erasePath = path.cgPath.copy(strokingWithWidth: 10.0,
                                             lineCap: .round,
                                             lineJoin: .round,
                                             miterLimit: 0)
            if erasePath.contains(point, using: .evenOdd) {
                remove(path)
            }
            if erasePath.contains(point) {
                remove(path)
            }
        }
        if self.paths?.count == 0 {
            page?.removeAnnotation(self)
            return self
        }
        page?.addAnnotation(self)
        return nil
    }
}

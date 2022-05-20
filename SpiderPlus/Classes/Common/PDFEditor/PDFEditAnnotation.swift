//
//  PDFEditAnnotation.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import Foundation
import PDFKit

class PDFEditAnnotation: PDFAnnotation {
    override var hasAppearanceStream: Bool {
        return true
    }
}

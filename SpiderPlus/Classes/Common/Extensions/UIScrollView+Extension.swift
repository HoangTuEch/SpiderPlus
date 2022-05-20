//
//  UIScrollView+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

extension UIScrollView {
    static let defaultPDFPageHeight: CGFloat = 792
    static let defaultPDFPageWidth: CGFloat = 612
    static let defaultPDFPageMargin: CGFloat = 50

    // 参照：https://github.com/azu/ScrollViewToPDF
    func saveAsPDF(fileUrl: URL) -> Bool {
        var result = false

        let orgFrame = self.frame
        let orgContentOffset = self.contentOffset
        let orgHorizontalScrollIndicator = self.showsHorizontalScrollIndicator
        let orgVerticalScrollIndicator = self.showsVerticalScrollIndicator

        let contentWidth = max(UIScrollView.defaultPDFPageWidth, self.frame.size.width)

        let maxHeight = UIScrollView.defaultPDFPageHeight - (2 * UIScrollView.defaultPDFPageMargin)
        let maxWidth = contentWidth + (2 * UIScrollView.defaultPDFPageMargin)
        let height = self.contentSize.height

        // Set up the pdf we're going to be generating in.
        self.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: maxHeight)
        let pages = Int(ceil(height / maxHeight))
        let pdfData = NSMutableData()
        // スクリーンショットを撮る準備。
        self.prepareForCapture()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        for i in 0..<pages {
            if (maxHeight * CGFloat(i + 1)) > height {
                // Check to see if page draws more than the height of the UIScrollview's contentSize.
                var frame = self.frame
                frame.size.height -= ((maxHeight * CGFloat(i + 1)) - height)
                self.frame = frame
            }
            // Specify the size of the pdf page.
            UIGraphicsBeginPDFPageWithInfo(CGRect(x: (contentWidth - self.frame.size.width) / 2.0, y: 0.0, width: maxWidth, height: UIScrollView.defaultPDFPageHeight), nil)
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                UIGraphicsEndPDFContext()
                return result
            }
            // ページ数を打って。
            self.drawPageNumber(i + 1)
            // Move the context for the margins.
            // マーギン
            currentContext.translateBy(x: UIScrollView.defaultPDFPageMargin, y: -(maxHeight * CGFloat(i)) + UIScrollView.defaultPDFPageMargin)
            // 中身をスクロールさせて描画する領域を変える。
            self.setContentOffset(CGPoint(x: 0.0, y: maxHeight * CGFloat(i)), animated: false)
            self.layer.render(in: currentContext)
        }
        UIGraphicsEndPDFContext()

        // Restore state.
        self.frame = orgFrame
        self.contentOffset = orgContentOffset
        self.showsHorizontalScrollIndicator = orgHorizontalScrollIndicator
        self.showsVerticalScrollIndicator = orgVerticalScrollIndicator
        // Save to url.
        result = pdfData.write(to: fileUrl, atomically: true)

        return result
    }
}

extension UIScrollView {

    private func prepareForCapture() {
        // スクリーンショット用の準備。
        self.setContentOffset(CGPoint.zero, animated: false)
        // インジケータを非表示にする。
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }

    // ページ番号を描画
    private func drawPageNumber(_ pageNumber: Int) {
        let pageString = "\(pageNumber)" as NSString
        let font = UIFont.systemFont(ofSize: 12)
        let pageStringSize = CGSize(width: 24, height: 16)
        let scrollViewX = UIScrollView.defaultPDFPageMargin
        let scrollViewY = (UIScrollView.defaultPDFPageHeight - UIScrollView.defaultPDFPageMargin) + (UIScrollView.defaultPDFPageMargin - pageStringSize.height) / 2
        let stringRect = CGRect(x: scrollViewX, y: scrollViewY, width: pageStringSize.width, height: pageStringSize.height)
        // Draw.
        pageString.draw(in: stringRect, withAttributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.black])
    }

    func setCustomIndicator(image: UIImage?) {
        if #available(iOS 13.0, *) {
            if let verticalScrollIndicator: UIView = self.subviews.last {
                // 追加した画像があれば削除
                let subviews = verticalScrollIndicator.subviews
                for subview in subviews {
                    subview.removeFromSuperview()
                }

                let scrollBarImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
                scrollBarImageView.contentMode = .scaleToFill
                scrollBarImageView.image = image
                scrollBarImageView.translatesAutoresizingMaskIntoConstraints = false
                verticalScrollIndicator.addSubview(scrollBarImageView)
                // ScrollBar いっぱいに画像を設置
                scrollBarImageView.bottomAnchor.constraint(
                    equalTo: verticalScrollIndicator.bottomAnchor,
                    constant: 0.0
                    ).isActive = true
                scrollBarImageView.trailingAnchor.constraint(
                    equalTo: verticalScrollIndicator.trailingAnchor,
                    constant: 0.0
                    ).isActive = true
                scrollBarImageView.topAnchor.constraint(
                    equalTo: verticalScrollIndicator.topAnchor,
                    constant: 0.0
                ).isActive = true
            }
        } else {
            if let horizontalIndicator: UIImageView = self.subviews[self.subviews.count-1] as? UIImageView {
                 horizontalIndicator.image = image
            }
        }
    }
}

//
//  UIView+Extension.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

struct Edge: OptionSet {
    let rawValue: Int
    static let left = Edge(rawValue: 1<<0)
    static let right = Edge(rawValue: 1<<2)
    static let top = Edge(rawValue: 1<<3)
    static let bottom = Edge(rawValue: 1<<4)
}

extension UIView {
    class func instance(nibName name: String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    func makeContraintToFullWithParentView() {
        guard let parrentView = self.superview else {
            return
        }
        let dict = ["view": self]
        self.translatesAutoresizingMaskIntoConstraints = false
        parrentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: dict))
        parrentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: dict))
    }

    func makeContraintsWithParent(ins: UIEdgeInsets = .zero, edges: Edge) {
        guard let parrentView = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(Edge.top) {
            topAnchor.constraint(equalTo: parrentView.topAnchor, constant: ins.top).isActive = true
        }

        if edges.contains(Edge.bottom) {
            bottomAnchor.constraint(equalTo: parrentView.bottomAnchor, constant: ins.bottom).isActive = true
        }

        if edges.contains(Edge.left) {
            leadingAnchor.constraint(equalTo: parrentView.leadingAnchor, constant: ins.left).isActive = true
        }

        if edges.contains(Edge.right) {
            trailingAnchor.constraint(equalTo: parrentView.trailingAnchor, constant: ins.right).isActive = true
        }
    }

    func saveContentAsPDF(fileUrl: URL) -> Bool {
        var result = false

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.bounds, nil)
        UIGraphicsBeginPDFPage()

        guard let pdfContext = UIGraphicsGetCurrentContext() else {
            return result
        }

        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()

        result = pdfData.write(to: fileUrl, atomically: true)

        return result
    }

    // MARK: - IB Helpers
    @IBInspectable var spBorderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else { return UIColor.clear }
            return UIColor(cgColor: borderColor)
        }
        set {
            self.layer.borderColor = (newValue ?? UIColor.clear).cgColor
        }
    }

    @IBInspectable var spBorderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable var spCornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable var spMasksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }

    func applySketchShadow(color: UIColor = .black,
                           alpha: Float = 0.4,
                           x: CGFloat = 0,
                           y: CGFloat = 0,
                           radius: CGFloat = 5,
                           spread: CGFloat = 0) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = alpha
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowRadius = radius
        if spread == 0 {
            self.layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func setBorder(_ borderColor: UIColor, borderWidth: CGFloat = 1, cornerRadius: CGFloat? = nil, masksToBounds: Bool = true) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        if let radius = cornerRadius {
            self.layer.cornerRadius = radius
        }
        self.layer.masksToBounds = masksToBounds
    }

    func setCornerRadius(_ cornerRadius: CGFloat, masksToBounds: Bool = true) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = masksToBounds
    }

    // Use for Home and setting common
    func drawLineWith(points: [CGPoint], lineWidth: CGFloat = 1.0, color: UIColor = .lightGray) {
        // remove old value
        var keyToSave = "layerOfLine"
        if let oldlayer = objc_getAssociatedObject(self, &keyToSave) as? CALayer, let sublayer = self.layer.sublayers, let index = sublayer.firstIndex(of: oldlayer) {
            self.layer.sublayers?.remove(at: index)
        }
        // init path
        let path = UIBezierPath()

        // add line to draw
        for (index, value) in points.enumerated() {
            if index == 0 {
                path.move(to: value)
            } else {
                path.addLine(to: value)
            }
        }

        path.lineWidth = lineWidth

        // add new sublayer
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(layer)

        // save new value
        objc_setAssociatedObject(self, &keyToSave, layer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    public func createBorderForView(color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        let cgColor: CGColor = color.cgColor
        self.layer.borderColor = cgColor
    }

    public func renderImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)

            let image = renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
            return image
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }

    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
        return ()
    }
}

extension UIView {
    func removeAllSubviews() {
        for subview in subviews {
            print("============> \(subview)")
            subview.removeFromSuperview()
        }
    }
}

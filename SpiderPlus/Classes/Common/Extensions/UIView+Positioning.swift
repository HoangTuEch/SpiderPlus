//
//  UIView+Positioning.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/17/22.
//

import UIKit

public extension UIView {
    // MARK: - Basic Properties
    var x: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(x: _pixelIntegral(newValue),
                                  y: self.y,
                                  width: self.width,
                                  height: self.height)
        }
    }

    var y: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(x: self.x,
                                  y: _pixelIntegral(newValue),
                                  width: self.width,
                                  height: self.height)
        }
    }

    var width: CGFloat {
        get { return self.frame.size.width }
        set { self.frame = CGRect(x: self.x,
                                  y: self.y,
                                  width: _pixelIntegral(newValue),
                                  height: self.height)
        }
    }

    var height: CGFloat {
        get { return self.frame.size.height }
        set { self.frame = CGRect(x: self.x,
                                  y: self.y,
                                  width: self.width,
                                  height: _pixelIntegral(newValue))
        }
    }

    // MARK: - Origin and Size
    var origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame = CGRect(x: _pixelIntegral(newValue.x),
                                  y: _pixelIntegral(newValue.y),
                                  width: self.width,
                                  height: self.height)
        }
    }

    var size: CGSize {
        get { return self.frame.size }
        set { self.frame = CGRect(x: self.x,
                                  y: self.y,
                                  width: _pixelIntegral(newValue.width),
                                  height: _pixelIntegral(newValue.height))
        }
    }

    // MARK: - Extra Properties
    var right: CGFloat {
        get { return self.x + self.width }
        set { self.x = newValue - self.width }
    }

    var bottom: CGFloat {
        get { return self.y + self.height }
        set { self.y = newValue - self.height }
    }

    var top: CGFloat {
        get { return self.y }
        set { self.y = newValue }
    }

    var left: CGFloat {
        get { return self.x }
        set { self.x = newValue }
    }

    var centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue, y: self.centerY) }
    }

    var centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.centerX, y: newValue) }
    }

    var lastSubviewOnX: UIView? {
        return self.subviews.reduce(UIView(frame: .zero)) {
            return $1.x > $0.x ? $1 : $0
        }
    }

    var lastSubviewOnY: UIView? {
        return self.subviews.reduce(UIView(frame: .zero)) {
            return $1.y > $0.y ? $1 : $0
        }
    }

    // MARK: - Bounds Methods
    var boundsX: CGFloat {
        get { return self.bounds.origin.x }
        set { self.bounds = CGRect(x: _pixelIntegral(newValue),
                                   y: self.boundsY,
                                   width: self.boundsWidth,
                                   height: self.boundsHeight)
        }
    }

    var boundsY: CGFloat {
        get { return self.bounds.origin.y }
        set { self.frame = CGRect(x: self.boundsX,
                                  y: _pixelIntegral(newValue),
                                  width: self.boundsWidth,
                                  height: self.boundsHeight)
        }
    }

    var boundsWidth: CGFloat {
        get { return self.bounds.size.width }
        set { self.frame = CGRect(x: self.boundsX,
                                  y: self.boundsY,
                                  width: _pixelIntegral(newValue),
                                  height: self.boundsHeight)
        }
    }

    var boundsHeight: CGFloat {
        get { return self.bounds.size.height }
        set { self.frame = CGRect(x: self.boundsX,
                                  y: self.boundsY,
                                  width: self.boundsWidth,
                                  height: _pixelIntegral(newValue))
        }
    }

    // MARK: - Private Methods
    fileprivate func _pixelIntegral(_ pointValue: CGFloat) -> CGFloat {
        let scale = UIScreen.main.scale
        return (round(pointValue * scale) / scale)
    }

    func convertOriginTo(parentView: UIView) -> CGPoint {
        var view = self
        var point: CGPoint = self.origin
        while view.superview != nil && view.superview != parentView {
            view = view.superview!
            point.x += view.x
            point.y += view.y
        }
        return point
    }
}

// MARK: - caculate height for view
public extension UIView {
    func systemFitting(width: CGFloat? = nil, minHeight: CGFloat = 0.0, configuration: (() -> Void)? = nil) -> CGFloat {
        var w = self.width
        if let wi = width, wi > 0 { w = wi }
        let widthFenceConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: w)
        self.addConstraint(widthFenceConstraint)
        configuration?()
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.removeConstraint(widthFenceConstraint)
        return size.height < minHeight ? minHeight : size.height
    }
}

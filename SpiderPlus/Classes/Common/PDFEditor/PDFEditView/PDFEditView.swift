//
//  PDFEditView.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import UIKit
import PDFKit

protocol PDFEditViewDelegate: AnyObject {
    func drawingEnded(_ annotations: [PDFAnnotation])
}

public enum DrawingTool: Int {
    case hand = 0
    case pen = 1
    case text = 2
    case eraser = 3
    case disable = 4
}

public class PDFEditView: UIView {

    // MARK: - Constants and Computed
    private let viewInstrumentsWidth: CGFloat = 60.0
    private let viewThumbnailPDFHeight: CGFloat = 100.0
    private var viewInstrumentsOffsetLeft: CGFloat = 20.0
    private var viewInstrumentsOffsetTop: CGFloat = 40.0
    private var colorPickerHeight: CGFloat = 300.0
    private var drawingWidthDivider: CGFloat = 50.0

    let currentTextAnnotationMinWidth: CGFloat = 150.0

    private var viewInstrumentsHeight: CGFloat {
        return CGFloat(buttonViewModelArray.count) * viewInstrumentsWidth
    }

    // MARK: - Stored
    weak var delegate: PDFEditViewDelegate?
    private(set) var drawingColor: UIColor = .red {
        didSet {
//            buttonViewModelArray = buttonViewModelArray.map {
//                if $0.index == colorPick.index {
//                    var model = $0
//                    model.tintColor = drawingColor
//                    return model
//                }
//                return $0
//            }
            instrumentsView.reloadData()
        }
    }
    private(set) var drawingWidth: CGFloat = 2
    private(set) var drawingFontSize: CGFloat = 12
    private(set) var drawingAlpha: CGFloat = 1

    public var document: PDFDocument! {
        get {
            return pdfView.document
        }
        set {
            pdfView.document = newValue
            currentPage = pdfView.currentPage

        }
    }

    private lazy var hand = InstrumentsButtonViewModel(index: 0,
                                                 image: getImage(with: "hand"),
                                                 tintColor: .black,
                                                 isSelected: false)

    private lazy var pencil = InstrumentsButtonViewModel(index: 1,
                                                 image: getImage(with: "pencil"),
                                                 tintColor: .black,
                                                 isSelected: false)

    private lazy var text = InstrumentsButtonViewModel(index: 2,
                                               image: getImage(with: "text"),
                                               tintColor: .black,
                                               isSelected: false)

    private lazy var erase = InstrumentsButtonViewModel(index: 3,
                                                image: getImage(with: "erase"),
                                                tintColor: .black,
                                                isSelected: false)

    private lazy var arrowLeft = InstrumentsButtonViewModel(index: 4,
                                                     image: getImage(with: "arrow_left"),
                                                     tintColor: .black,
                                                     isSelected: false)

    private lazy var arrowRight = InstrumentsButtonViewModel(index: 5,
                                                      image: getImage(with: "arrow_right"),
                                                      tintColor: .lightGray,
                                                      isSelected: false)

//    private lazy var colorPick = InstrumentsButtonViewModel(index: 6,
//                                                     image: getImage(with: "color_pick"),
//                                                     tintColor: drawingColor,
//                                                     isSelected: false)

    private lazy var trash = InstrumentsButtonViewModel(index: 6,
                                                image: getImage(with: "trash"),
                                                tintColor: .black,
                                                isSelected: false)

    private lazy var save = InstrumentsButtonViewModel(index: 7,
                                                image: getImage(with: "save"),
                                                tintColor: .black,
                                                isSelected: false)

    private lazy var buttonViewModelArray = [
        hand,
        pencil,
        text,
        erase,
        arrowLeft,
        arrowRight,
//        colorPick,
        trash,
        save
    ]

    private lazy var drawingGestureRecognizer: DrawingGestureRecognizer = {
        let drawingGestureRecognizer = DrawingGestureRecognizer()
        drawingGestureRecognizer.drawingDelegate = self
        return drawingGestureRecognizer
    }()

//    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
//        let tapGestureRecognizer = UITapGestureRecognizer()
//        tapGestureRecognizer.delegate = self
//        return tapGestureRecognizer
//    }()

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        panGestureRecognizer.delegate = self
        return panGestureRecognizer
    }()

    private lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = {
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch(_:)))
        pinchGestureRecognizer.delegate = self
        return pinchGestureRecognizer
    }()

    private(set) var lastRemovedAnnotations: [PDFAnnotation] = [] {
        didSet {
            let tintColor: UIColor = lastRemovedAnnotations.count > 0 ? .black : .lightGray
            buttonViewModelArray = buttonViewModelArray.map {
                if $0.index == arrowRight.index {
                    var model = $0
                    model.tintColor = tintColor
                    return model
                }
                return $0
            }
            instrumentsView.reloadData()
        }
    }

    private(set) var currentTextAnnotation: PDFAnnotation!
    private(set) var currentTextAnnotationMinHeight: CGFloat = 30.0

    private(set) var currentPage: PDFPage!

    private(set) var drawingTool: DrawingTool = .disable {
        didSet {
            pdfView.removeGestureRecognizer(panGestureRecognizer)
            pdfView.removeGestureRecognizer(pinchGestureRecognizer)
            pdfView.addGestureRecognizer(drawingGestureRecognizer)

            if let page = currentPage, let currentTextAnnotation = currentTextAnnotation {
                page.removeAnnotation(currentTextAnnotation)
                let appearance = PDFAppearanceCharacteristics()
                currentTextAnnotation.setValue(appearance, forAnnotationKey: .widgetAppearanceDictionary)
                page.addAnnotation(currentTextAnnotation)
            }
            currentTextAnnotation = nil

            if drawingTool == .disable {
                buttonViewModelArray = buttonViewModelArray.map {
                    var newModel = $0
                    newModel.isSelected = false
                    return newModel
                }
                pdfView.removeGestureRecognizer(drawingGestureRecognizer)
//                pdfView.addGestureRecognizer(tapGestureRecognizer)
            } else {
                pdfView.addGestureRecognizer(drawingGestureRecognizer)
//                pdfView.removeGestureRecognizer(tapGestureRecognizer)
            }
        }
    }

    // MARK: - UIElements
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
//        pdfView.usePageViewController(true) // Disable scrolling
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.autoScales = true
        pdfView.displayDirection = .horizontal
        pdfView.displayMode = .singlePage
//        (pdfView.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView)?.isScrollEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(handlePageChange(notification:)), name: .PDFViewPageChanged, object: nil)

        currentPage = pdfView.currentPage
//        pdfView.addGestureRecognizer(tapGestureRecognizer)
        return pdfView
    }()

    @objc private func handlePageChange(notification: Notification) {
        lastRemovedAnnotations = []

        if let page = currentPage, let currentTextAnnotation = currentTextAnnotation {
            page.removeAnnotation(currentTextAnnotation)
            let appearance = PDFAppearanceCharacteristics()
            currentTextAnnotation.setValue(appearance, forAnnotationKey: .widgetAppearanceDictionary)
            page.addAnnotation(currentTextAnnotation)
        }
        currentTextAnnotation = nil
        currentPage = pdfView.currentPage
        drawingTool = .disable
    }

    private lazy var instrumentsShadowLayer: CALayer = {
        let instrumentsShadowLayer = CALayer()
        instrumentsShadowLayer.backgroundColor = UIColor.white.cgColor
        instrumentsShadowLayer.shadowColor = UIColor.lightGray.cgColor
        instrumentsShadowLayer.shadowOpacity = 0.8
        instrumentsShadowLayer.shadowOffset = .zero
        instrumentsShadowLayer.shadowRadius = 10
        instrumentsShadowLayer.cornerRadius = instrumentsView.cornerRadius
        return instrumentsShadowLayer
    }()

    private lazy var instrumentsView: InstrumentsView = {
        let instrumentsView = InstrumentsView()
        if let index = buttonViewModelArray.firstIndex(where: {$0.isSelected == true}) {
            instrumentsView.tableView.selectRow(at: IndexPath(row: index, section: 0),
                                                animated: true,
                                                scrollPosition: .none)
        }
        return instrumentsView
    }()

    private lazy var drawConfigurationView: DrawConfigurationView = {
        let drawConfigurationView = DrawConfigurationView()
        drawConfigurationView.pickedColor = drawingColor
        drawConfigurationView.isHidden = true
        drawConfigurationView.delegate = self
        drawConfigurationView.alphaSlider.value = Float(drawingAlpha)
        drawConfigurationView.widthSlider.value = Float(drawingWidth / drawingWidthDivider)
        return drawConfigurationView
    }()

    private lazy var colorPickerView: ColorPickerView = {
        let colorPickerView = ColorPickerView()
        colorPickerView.delegate = self
        colorPickerView.isHidden = true
        return colorPickerView
    }()

    // MARK: - Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupInitialState()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        if let sublayers = layer.sublayers, !sublayers.contains(instrumentsShadowLayer) {
            layer.insertSublayer(instrumentsShadowLayer, below: instrumentsView.layer)
        }

        instrumentsShadowLayer.frame = CGRect(x: viewInstrumentsOffsetLeft,
                                              y: (bounds.height - viewInstrumentsHeight)/2,
                                              width: viewInstrumentsWidth,
                                              height: viewInstrumentsHeight)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        pdfView.frame = CGRect(x: 0.0,
                               y: 0.0,
                               width: bounds.width,
                               height: bounds.height)

        instrumentsView.frame = CGRect(x: viewInstrumentsOffsetLeft,
                                       y: (bounds.height - viewInstrumentsHeight)/2,
                                       width: viewInstrumentsWidth,
                                       height: viewInstrumentsHeight)

        instrumentsView.delegate = self

        updateConstraints()
    }

    private(set) var needCreateConstraints: Bool = true
    override public func updateConstraints() {
        super.updateConstraints()

        if !needCreateConstraints {
            return
        }
        needCreateConstraints = false

        NSLayoutConstraint.activate([
            drawConfigurationView.topAnchor.constraint(equalTo: instrumentsView.bottomAnchor, constant: -viewInstrumentsWidth),
            drawConfigurationView.leadingAnchor.constraint(equalTo: instrumentsView.trailingAnchor, constant: 8.0),
            drawConfigurationView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0.0),
            drawConfigurationView.trailingAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.trailingAnchor, constant: -8.0),
            drawConfigurationView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0.0),

            colorPickerView.topAnchor.constraint(equalTo: drawConfigurationView.colorPickerButton.bottomAnchor, constant: 8.0),
            colorPickerView.trailingAnchor.constraint(equalTo: drawConfigurationView.trailingAnchor, constant: 0.0),
            colorPickerView.widthAnchor.constraint(equalTo: drawConfigurationView.widthAnchor, constant: 0.0),
            colorPickerView.heightAnchor.constraint(equalToConstant: colorPickerHeight)
        ])
    }
}

// MARK: - ColorPickerViewDelegate
extension PDFEditView: ColorPickerViewDelegate {

    func didTriggerColorPicker(color: UIColor) {
        drawConfigurationView.pickedColor = color
        drawingColor = color
    }

}

// MARK: - DrawConfigurationViewDelegate
extension PDFEditView: DrawConfigurationViewDelegate {

    func didTriggerColor() {
        colorPickerView.isHidden = !colorPickerView.isHidden
        colorPickerView.setNeedsDisplay()
    }

    func didTriggerWidth(_ width: CGFloat) {
        drawingWidth = width * drawingWidthDivider
    }

    func didTriggerAlpha(_ alpha: CGFloat) {
        drawingAlpha = alpha
    }
}

// MARK: - InstrumentsViewDelegate
extension PDFEditView: InstrumentsViewDelegate {

    func buttonsForInstruments() -> [InstrumentsButtonViewModel] {
        return buttonViewModelArray
    }

    func didTriggerButton(at model: InstrumentsButtonViewModel, type: TriggerType) {
        buttonViewModelArray = buttonViewModelArray.enumerated().map { (arg) -> InstrumentsButtonViewModel in
            var (key, value) = arg
            switch type {
            case .select:
                value.updateIsSelected(key == model.index)
            case .deselect:
                value.updateIsSelected(false)
            }
            return value
        }

        drawConfigurationView.isHidden = true
        colorPickerView.isHidden = true

        if type == .deselect {
            drawingTool = .disable
            return
        }

        if model.index == hand.index {
            drawingTool = .hand
            lastRemovedAnnotations = []
        } else if model.index == pencil.index {
            drawingTool = .pen
            lastRemovedAnnotations = []
        } else if model.index == text.index {
            drawingTool = .text
            lastRemovedAnnotations = []
        } else if model.index == erase.index {
            drawingTool = .eraser
            lastRemovedAnnotations = []
        } else if model.index == arrowLeft.index {
            handleActionUndo()
        } else if model.index == arrowRight.index {
            handleActionRedo()
        }/*else if model.index == colorPick.index {
            drawingTool = .disable
            drawConfigurationView.isHidden = false
            drawConfigurationView.setNeedsDisplay()
        }
         */else if model.index == trash.index {
            handleActionTrash()
        } else if model.index == save.index {
            handleActionSave()
        }
    }
}

// MARK: - Handle action
extension PDFEditView {
    private func handleActionUndo() {
        drawingTool = .disable
        guard let page = currentPage else { return }
        guard let last = page.annotations.last else { return }
        lastRemovedAnnotations.append(last)
        page.removeAnnotation(last)
    }

    private func handleActionRedo() {
        drawingTool = .disable
        guard let page = currentPage else { return }
        guard let last = lastRemovedAnnotations.last else { return }
        lastRemovedAnnotations.removeLast()
        page.addAnnotation(last)
    }

    private func handleActionTrash() {
        guard let page = currentPage else { return }
        for annotation in page.annotations.reversed() {
            page.removeAnnotation(annotation)
            lastRemovedAnnotations.append(annotation)
        }
    }

    private func handleActionSave() {
        guard let pdfData = document.dataRepresentation() else { return }

        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                .userDomainMask,
                                                                true)[0]

        let url = URL(fileURLWithPath: "\(documentsPath)/file.pdf")
        try? pdfData.write(to: url)
    }
}

// MARK: - DrawingGestureRecognizerDelegate
extension PDFEditView: DrawingGestureRecognizerDelegate {

    func drawingBegan(_ location: CGPoint) {

        if drawingTool == .disable || drawingTool == .eraser {
            return
        }

        guard let page = pdfView.page(for: location,
                                      nearest: true) else { return }
        let convertedPoint = pdfView.convert(location,
                                             to: page)

        if drawingTool == .pen {

            // Создаем и сохраняем path
            let pathRect = CGRect(x: convertedPoint.x, y: convertedPoint.y, width: 0, height: 0)
            let path = UIBezierPath(ovalIn: pathRect)

            let annotation = createDrawAnnotation(page: page,
                                                  bounds: page.bounds(for: pdfView.displayBox),
                                                  color: drawingColor,
                                                  width: drawingWidth,
                                                  alpha: drawingAlpha)
            annotation.add(path)
            page.addAnnotation(annotation)
            return
        }
    }

    func drawingMoved(_ location: CGPoint) {
        if drawingTool == .disable {
            return
        }
        guard let page = pdfView.page(for: location,
                                      nearest: true) else { return }
        let convertedPoint = pdfView.convert(location,
                                             to: page)

        if drawingTool == .eraser {
            eraseAnnotationAtPoint(point: convertedPoint,
                                    page: page)
            return
        }

        if drawingTool == .pen {
            addLine(on: page, to: convertedPoint)
            return
        }
    }

    func drawingEnded(_ location: CGPoint) {
        if drawingTool == .disable {
            return
        }

        guard let page = pdfView.page(for: location,
                                      nearest: true) else { return }
        let convertedPoint = pdfView.convert(location,
                                             to: page)

        if drawingTool == .text {
            let annotation = createTextAnnotation(page: page,
                                                  bounds: CGRect(x: convertedPoint.x,
                                                                 y: convertedPoint.y,
                                                                 width: currentTextAnnotationMinWidth,
                                                                 height: currentTextAnnotationMinHeight - 8.0),
                                                  color: drawingColor,
                                                  fontSize: drawingFontSize,
                                                  alpha: drawingAlpha)
            page.addAnnotation(annotation)
            lastRemovedAnnotations = []

            pdfView.removeGestureRecognizer(drawingGestureRecognizer)
            pdfView.addGestureRecognizer(panGestureRecognizer)
            pdfView.addGestureRecognizer(pinchGestureRecognizer)

            currentTextAnnotation = annotation

            return
        }

        if drawingTool == .hand {
            let annotation = createButtonAnnotation(page: page,
                                                  bounds: CGRect(x: convertedPoint.x,
                                                                 y: convertedPoint.y,
                                                                 width: 10,
                                                                 height: 10),
                                                  color: drawingColor,
                                                  fontSize: drawingFontSize,
                                                  alpha: drawingAlpha)
            page.addAnnotation(annotation)
            lastRemovedAnnotations = []

            pdfView.removeGestureRecognizer(drawingGestureRecognizer)
            pdfView.addGestureRecognizer(panGestureRecognizer)
            pdfView.addGestureRecognizer(pinchGestureRecognizer)

            currentTextAnnotation = annotation

            delegate?.drawingEnded(page.annotations)
            return
        }

        if drawingTool == .eraser {
            eraseAnnotationAtPoint(point: convertedPoint,
                                    page: page)
            return
        }

        if drawingTool == .pen {
            addLine(on: page, to: convertedPoint)
            delegate?.drawingEnded(page.annotations)
            return
        }
    }
}

// MARK: - UIPanGestureRecognizer

extension PDFEditView {

    @objc func pan(_ sender: UIPanGestureRecognizer) {
        if currentTextAnnotation == nil {
            return
        }
        if sender.state == .ended {
            return
        }

        let translation = sender.translation(in: sender.view)
        let location = sender.location(in: sender.view)

        guard let page = pdfView.page(for: location,
                                      nearest: true) else { return }

        page.removeAnnotation(currentTextAnnotation)
        currentTextAnnotation.bounds = currentTextAnnotation.bounds.offsetBy(dx: translation.x, dy: -translation.y)
        page.addAnnotation(currentTextAnnotation)

        sender.setTranslation(.zero, in: sender.view)
    }

}

// MARK: - UIGestureRecognizerDelegate

extension PDFEditView: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UITapGestureRecognizer {
//            return true
//        }
        if gestureRecognizer is UIPanGestureRecognizer && otherGestureRecognizer is UISwipeGestureRecognizer {
            return true
        }
        if gestureRecognizer is UIPinchGestureRecognizer && otherGestureRecognizer is UIPinchGestureRecognizer {
            return true
        }
//        if gestureRecognizer is UITapGestureRecognizer && String(describing: type(of: otherGestureRecognizer)) == "UIScrollViewPanGestureRecognizer" {
//
//            let location = gestureRecognizer.location(in: pdfView)
//            if let page = pdfView.page(for: location,
//                                       nearest: true) {
//                currentTextAnnotation = page.annotation(at: location)
//
//                print("ks: \(page.bounds(for: .mediaBox))")
//
//                if currentTextAnnotation != nil {
//                    pdfView.removeGestureRecognizer(drawingGestureRecognizer)
//                    pdfView.addGestureRecognizer(panGestureRecognizer)
//                    pdfView.addGestureRecognizer(pinchGestureRecognizer)
//                }
//            }
//
//
//            return false
//        }
        return false
    }

}

// MARK: - Private
extension PDFEditView {

    private func setupInitialState() {
        addSubview(pdfView)
        addSubview(instrumentsView)
        addSubview(drawConfigurationView)
        addSubview(colorPickerView)
        drawConfigurationView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func createDrawAnnotation(page: PDFPage,
                                      bounds: CGRect,
                                      color: UIColor,
                                      width: CGFloat,
                                      alpha: CGFloat) -> PDFAnnotation {
        let border = PDFBorder()
        border.lineWidth = width

        let annotation = PDFAnnotation(bounds: bounds,
                                       forType: .ink,
                                       withProperties: nil)
        annotation.color = color.withAlphaComponent(alpha)
        annotation.border = border
        return annotation
    }

    private func createTextAnnotation(page: PDFPage,
                                      bounds: CGRect,
                                      color: UIColor,
                                      fontSize: CGFloat,
                                      alpha: CGFloat) -> PDFAnnotation {

        let annotation = PDFEditAnnotation(bounds: bounds,
                                       forType: .widget,
                                       withProperties: nil)
        annotation.fieldName = UUID().uuidString
        annotation.widgetFieldType = .text
        annotation.fontColor = color.withAlphaComponent(alpha)
        annotation.font = UIFont.boldSystemFont(ofSize: fontSize)
        annotation.isMultiline = true

        let border = PDFBorder()
        border.lineWidth = 1.0
        annotation.border = border

        //annotation.widgetStringValue = "Add"

        let appearance = PDFAppearanceCharacteristics()
        appearance.borderColor = color
        appearance.backgroundColor = color.withAlphaComponent(0.1)

        annotation.setValue(appearance, forAnnotationKey: .widgetAppearanceDictionary)
        return annotation
    }

    private func createButtonAnnotation(page: PDFPage,
                                        bounds: CGRect,
                                        color: UIColor,
                                        fontSize: CGFloat,
                                        alpha: CGFloat) -> PDFAnnotation {

        let annotation = PDFEditAnnotation(bounds: bounds,
                                       forType: .widget,
                                       withProperties: nil)
        annotation.fieldName = UUID().uuidString
        annotation.widgetFieldType = .button
        annotation.widgetControlType = .pushButtonControl
        annotation.fieldName = "Radio Button"
        annotation.color = color
        annotation.backgroundColor = color

        let border = PDFBorder()
        border.lineWidth = 1.0
        annotation.border = border

        return annotation
    }

    private func eraseAnnotationAtPoint(point: CGPoint,
                                        page: PDFPage) {
        for annotation in page.annotations {
            if currentTextAnnotation === annotation.removePath(at: point) {
                currentTextAnnotation = nil
            }
        }
    }

    private func addLine(on page: PDFPage, to point: CGPoint) {
        guard let annotation = page.annotations.last else { return }
        guard let oldBezierPath = annotation.paths?.last else { return }
        guard let newBezierPath = oldBezierPath.copy() as? UIBezierPath else { return }

        newBezierPath.addLine(to: point)
        annotation.remove(oldBezierPath)
        annotation.add(newBezierPath)
    }

    private func getImage(with name: String) -> UIImage {
        return UIImage(named: name)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
    }

    private func findTextView(in searchView: UIView) -> UITextView? {
        for view in searchView.subviews {
            if view.isKind(of: UITextView.self) {
                return view as? UITextView
            } else {
                return findTextView(in: view)
            }
        }
        return nil
    }

}

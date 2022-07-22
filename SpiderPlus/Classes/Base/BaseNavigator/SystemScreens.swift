//
//  SystemScreens.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/25/22.
//

import UIKit
import Photos
import MobileCoreServices

/// システムスクリーン
public enum SystemScreens: String, CaseIterable, Screen {
    case imagePicker
    case alert
    case actionSheet
    case activity
    case alertTextField

    public var path: String {
        return rawValue
    }

    public var transition: NavigateTransions {
        switch self {
        case .imagePicker, .alert, .actionSheet, .activity, .alertTextField:
            return .present
            //        default:
            //            return .push
        }
    }

    public func createViewController(_ payload: Any? = nil) -> UIViewController {
        switch self {
        case .imagePicker:
            guard let payload = payload as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate, UIImagePickerController.SourceType, [CFString]) else {
                fatalError()
            }
            let vc = UIImagePickerController()
            vc.delegate = payload.0
            vc.sourceType = payload.1
            vc.mediaTypes = payload.2 as [String]
            return vc
        case .alert:
            return createUIAlertController(payload, .alert)
        case .actionSheet:
            return createUIAlertController(payload, .actionSheet)
        case .activity:
            guard let payload = payload as? ActivityInfo else {
                fatalError("invalid payload")
            }
            let vc = UIActivityViewController(activityItems: payload.activityItems,
                                              applicationActivities: payload.applicationActivities)
            vc.excludedActivityTypes = payload.excludedActivityTypes
            vc.popoverPresentationController?.sourceView = vc.view
            vc.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.midX,
                                                                  y: vc.view.frame.midY,
                                                                  width: 0,
                                                                  height: 0)
            vc.popoverPresentationController?.permittedArrowDirections = []
            return vc
        case .alertTextField:
            return payload as! UIAlertController
        }
    }

    private func createUIAlertController(_ payload: Any?,
                                         _ preferredStyle: UIAlertController.Style) -> UIAlertController {
        guard let payload = payload as? AlertInfo else {
            fatalError()
        }
        let vc =  UIAlertController(title: nil, message: nil, preferredStyle: preferredStyle)
        vc.title = payload.title
        vc.message = payload.message
        if let messageFont = payload.messageFont {
            vc.setMessage(font: messageFont, color: nil)
        }
        var actions = payload.actions.map { pair -> UIAlertAction in
            return UIAlertAction(title: pair.key, style: pair.value.0, handler: { _ in
                pair.value.1()
            })
        }
        if let cancel = payload.cancel {
            let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: { _ in
                payload.onCancel?()
            })
            if vc.preferredStyle == .alert {
                actions.insert(cancelAction, at: 0)
            } else {
                actions.append(cancelAction)
            }
        }

        // Fix bug SDM 1622, set sourceView, sourceRect with current view controller
        if let controller = AppDelegate.shared.appRootViewController.currentViewController(), let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = controller.view
            /*
             controller.handleViewWillLayoutSubviews {
             popoverController.sourceRect = CGRect(x: controller.view.bounds.midX, y: controller.view.bounds.maxY, width: 0, height: 0)
             }             
             */
            popoverController.sourceRect = CGRect(x: controller.view.bounds.midX, y: controller.view.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        } else {
            // In case of not getting the current controller, I will use logic your old one
            vc.popoverPresentationController?.sourceView = vc.view
            vc.popoverPresentationController?.sourceRect = CGRect(x: vc.view.frame.midX,
                                                                  y: vc.view.frame.midY,
                                                                  width: 0,
                                                                  height: 0)
            vc.popoverPresentationController?.permittedArrowDirections = []
        }

        actions.forEach { vc.addAction($0) }
        return vc
    }
}

/// Alert情報
public struct AlertInfo {
    public let title: String?
    public let message: String?
    public let messageFont: UIFont?
    public let actions: [String: (UIAlertAction.Style, () -> Void)]
    public let cancel: String?
    public let onCancel: (() -> Void)?
}

/// Activity情報
public struct ActivityInfo {
    public let activityItems: [Any]
    public let applicationActivities: [UIActivity]?
    public let excludedActivityTypes: [UIActivity.ActivityType]?
}

/// MediaPickerTypeSelectActionSheet
public protocol MediaPickerTypeSelectActionSheetHandler {
    func sheetTitle() -> String?
    func sheetMessage() -> String?
    func photoLibraryButtonTitle() -> String
    func imageLibraryButtonTitle() -> String
    func cameraButtonTitle() -> String
    func cancelButtonTitle() -> String
    func onCancel()
}

/// CameraRollEventHandler
public protocol CameraRollEventHandler {
    func onFailAccessCamera()
    func onFailAccessPhotoLibrary()
    func onCanceled()
    func onImageSelected(_ image: UIImage)
    func onImageSelected(_ image: UIImage, _ typeAccess: Bool)
    func onMediaSelected(_ url: URL)
}

extension CameraRollEventHandler {
    func onFailAccessCamera() {}
    func onFailAccessPhotoLibrary() {}
    func onCanceled() {}
    func onImageSelected(_ image: UIImage) {}
    func onImageSelected(_ image: UIImage, _ typeAccess: Bool) {}
    func onMediaSelected(_ url: URL) {}
}


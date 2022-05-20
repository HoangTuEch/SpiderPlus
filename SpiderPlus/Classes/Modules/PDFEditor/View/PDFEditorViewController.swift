//
//  PDFEditorViewController.swift
//  SpiderPlus
//
//  Created by DatND2 on 5/19/22.
//

import UIKit
import PDFKit

class PDFEditorViewController: BaseViewController {

    lazy var pdfEditView: PDFEditView = {
        let pdfEditView = PDFEditView()
        return pdfEditView
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pdfEditView.frame = view.bounds
        pdfEditView.delegate = self
        if !pdfEditView.isDescendant(of: view) {
            view.addSubview(pdfEditView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        openPDFLocal()
        // fetchPDF()
    }

    private func openPDFLocal() {
        if let decoded = UserDefaults.standard.object(forKey: "annotations") as? Data {
            let decodedTeams = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? [PDFAnnotation]
            print("===============> \(String(describing: decodedTeams))")
        }

        if let path = Bundle.main.path(forResource: "Test", ofType: "pdf") {
            let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path))
            DispatchQueue.main.async { [weak self] in
                self?.pdfEditView.document = pdfDocument
            }
        }
    }

    private func fetchPDF() {
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        let urlSession = URLSession(configuration: .default,
                                    delegate: self,
                                    delegateQueue: nil)

        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
}

extension PDFEditorViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)

        let pdfDocument = PDFDocument(url: location)

        DispatchQueue.main.async { [weak self] in
            self?.pdfEditView.document = pdfDocument
        }
    }
}

extension PDFEditorViewController: PDFEditViewDelegate {
    func drawingEnded(_ annotations: [PDFAnnotation]) {
        let encodeData = try? NSKeyedArchiver.archivedData(withRootObject: annotations, requiringSecureCoding: false)
        UserDefaults.standard.set(encodeData, forKey: "annotations")
        UserDefaults.standard.synchronize()
    }
}

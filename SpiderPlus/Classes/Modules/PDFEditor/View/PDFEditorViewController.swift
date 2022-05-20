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
        if !pdfEditView.isDescendant(of: view) {
            view.addSubview(pdfEditView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        openPDFLocal()
        // fetchPDF()

        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 60.0) { [weak self] in
            guard let pdfData = self?.pdfEditView.document.dataRepresentation() else { return }

            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)[0]

            let url = URL(fileURLWithPath: "\(documentsPath)/file.pdf")
            print("============> \(url)")
            try? pdfData.write(to: url)
        }
    }

    private func openPDFLocal() {
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

//
//  PDFViewerController.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import WebKit

class PDFViewerController: UIViewController {

    var mPresenter = PDFViewerModel()
    
    @IBOutlet weak var pdfView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mPresenter.mView = self
        mPresenter.getPDF()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mPresenter.deletePDF()
    }
}

extension PDFViewerController: PDFViewerView {
    func openPDF(path: String) {
        let targetURL = NSURL.fileURL(withPath: path)
        let data = NSData.init(contentsOf: targetURL)
        pdfView.load(data! as Data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: targetURL.deletingLastPathComponent())
    }    
}

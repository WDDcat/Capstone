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

}

extension PDFViewerController: PDFViewerView {
    func openPDF(data: Data, url: URL) {
        pdfView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: url)
    }    
}

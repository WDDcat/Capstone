//
//  PDFViewerContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol PDFViewerView {
    func openPDF(data: Data, url:URL)
}

protocol PDFViewerPresenter {
    func getPDF()
}

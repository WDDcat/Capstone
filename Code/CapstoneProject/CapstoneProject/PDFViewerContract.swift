//
//  PDFViewerContract.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation

protocol PDFViewerView {
    func openPDF(path: String)
}

protocol PDFViewerPresenter {
    func getPDF()
    func deletePDF()
}

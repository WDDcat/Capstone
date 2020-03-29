//
//  PDFViewerModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PDFViewerModel: PDFViewerPresenter {
    
    var mView: PDFViewerView?
    
//    func getPDF() {
//        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
//        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "type": "pdf"]
//        Alamofire.download(URL(string :"\(BASEURL)get_pdf")!, parameters: param, headers: getHeader(), to: destination)
//            .downloadProgress { progress in
//                print("当前进度: \(progress.fractionCompleted)")
//            }
//            .response { response in
//                print("下载成功: \(response.destinationURL!)")
//                let data = NSData(contentsOf: response.destinationURL!)
//                print("data: \(data?.bytes)")
//                if data != nil {
//                    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
//                    let fileManager = FileManager.default
////                    documentsDirectory.appendingPathComponent("PDF")
//
//                    //创建目录
//                    do {
//                        try fileManager.createDirectory(atPath: documentsDirectory as String, withIntermediateDirectories: true, attributes: nil)
//                    } catch _ {
//
//                    }
//
//                    //创建文件
//                    let documentPath = documentsDirectory.appendingPathComponent("get_pdf.pdf")
//
//                    fileManager.createFile(atPath: documentPath, contents: data! as Data, attributes: nil)
//
//                    self.mView?.openPDF(path: documentPath)
//                }
//            }
//    }
    
    func getPDF() {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent("\(remoteGetCompanyName()).pdf")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "type": "pdf"]
        Alamofire.download(URL(string :"\(BASEURL)get_pdf")!, parameters: param, headers: getHeader(), to: destination)
            .downloadProgress { progress in
//                print("当前进度: \(progress.fractionCompleted)")
                print("进度: \(progress.completedUnitCount) / \(progress.totalUnitCount)")
            }
            .response { response in
                print("下载成功: \(response.destinationURL!)")
                let data = NSData(contentsOf: response.destinationURL!)
                if data != nil {
                    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
                    let fileManager = FileManager.default
                    documentsDirectory.appendingPathComponent("PDF")

                    //创建目录
                    do {
                        try fileManager.createDirectory(atPath: documentsDirectory as String, withIntermediateDirectories: true, attributes: nil)
                    } catch _ {

                    }

                    //创建文件
                    let documentPath = documentsDirectory.appendingPathComponent("\(remoteGetCompanyName()).pdf")

                    fileManager.createFile(atPath: documentPath, contents: data! as Data, attributes: nil)

                    self.mView?.openPDF(path: documentPath)
                }
            }
    }
    
    func deletePDF() {
//        let fileManager = FileManager.default
//        do {
//            let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString
//            let documentPath = documentsDirectory.appendingPathComponent("get_pdf.pdf")
//            try fileManager.removeItem(at: NSURL.fileURL(withPath: documentPath))
//        } catch _ {
//            print("delete fail")
//        }
    }
}

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
    
    var documentPath: String = ""
    
    func getPDF() {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "type": "pdf"]
        Alamofire.download(URL(string :"\(BASEURL)get_pdf")!, parameters: param, headers: getHeader(), to: destination)
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
            .response { response in
                print("下载成功: \(response.destinationURL!)")
                let data = NSData(contentsOf: response.destinationURL!)
                print("data: \(data?.bytes)")
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
                    self.documentPath = documentsDirectory.appendingPathComponent("\(remoteGetCompanyName()).pdf")
                    
                    fileManager.createFile(atPath: self.documentPath, contents: data! as Data, attributes: nil)
                    
                    self.mView?.openPDF(path: self.documentPath)
                }
            }
    }
    
    func deletePDF() {
        let fileManager = FileManager.default
        do {
            let targetURL = URL.init(fileURLWithPath: documentPath)
            try fileManager.removeItem(at: targetURL)
        } catch _ {
            print("delete fail")
        }
    }
}

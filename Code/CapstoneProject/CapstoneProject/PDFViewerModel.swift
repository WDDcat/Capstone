//
//  PDFViewerModel.swift
//  CapstoneProject
//
//  Created by Shiyu Wang on 2020/3/27.
//  Copyright © 2020 Shiyu Wang. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class PDFViewerModel: PDFViewerPresenter {
    
    var mView: PDFViewerView?
    
    func getPDF() {
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        let param:[String:Any] = ["c_id": remoteGetCompanyId(), "type": "pdf"]
        Alamofire.download(URL(string :"\(BASEURL)get_pdf")!, parameters: param, headers: getHeader(), to: destination)
            .downloadProgress { progress in
                print("当前进度: \(progress.fractionCompleted)")
            }
            .responseJSON { response in
                print("下载成功: \(response.destinationURL!)")
                let data = NSData(contentsOf: response.destinationURL!)
                print("data: \(data)")
                let url = response.destinationURL!
                self.mView?.openPDF(data: data! as Data, url: url)
            }
    }
}

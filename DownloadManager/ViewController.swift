//
//  ViewController.swift
//  DownloadManager
//
//  Created by Pawan kumar on 30/03/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var imageDowloadButton: UIButton!
    @IBOutlet weak var videoDowloadButton: UIButton!
    @IBOutlet weak var pdfDowloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func imageDowloadButtonTap(_ sender: UIButton) {
        
        let url = "https://www.tutorialspoint.com/images/QAicon.png"
        DownloadManagerRequest.shared.imageWithRequest(url: url, imageView: imageImageView, placeholder: "placeholder")
        
    }
    @IBAction func videoDowloadButtonTap(_ sender: UIButton) {
           
           let url = "http://clips.vorwaerts-gmbh.de/VfE_html5.mp4"
           DownloadManagerRequest.shared.videoWithRequest(url: url, completionHandler: {(url) -> Void in
            
            print("videoDowloadButtonTap ", url)
           })
    }
    @IBAction func pdfDowloadButtonTap(_ sender: UIButton) {
           
           let url = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
            DownloadManagerRequest.shared.pdfWithRequest(url: url, completionHandler: {(url) -> Void in print("pdfDowloadButtonTap ", url)
            })
    }
}


# Download Manager

## Download Manager Download image, video, pdf in device.


Added Some screens here.

![](https://github.com/pawankv89/DownloadManager/blob/master/images/screen_1.png)
![](https://github.com/pawankv89/DownloadManager/blob/master/images/screen_2.png)
![](https://github.com/pawankv89/DownloadManager/blob/master/images/screen_3.png)
![](https://github.com/pawankv89/DownloadManager/blob/master/images/screen_4.png)


## Usage

#### Controller

```swift

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

```

#### DownloadManagerRequest

```swift

import Foundation
import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

class DownloadManagerRequest {

    static let shared = DownloadManagerRequest()
    
    //Constructor
    private init() { }
    
    // - Returns: URL
    func getDocumentsDirectory() -> URL {

       let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       let documentsDirectory = paths[0]
       //"documentsDirectory ", documentsDirectory
       return documentsDirectory
    }
    
    //Downloads An Image From A Remote URL
    func imageWithRequest(url: String, imageView: UIImageView, placeholder: String) -> () {
           
        var isDownloaded: Bool = false
        
        //First Placeholder Image
        let image = UIImage(named: placeholder)
        if image == nil {
            imageView.image = UIImage(named: "placeholder")
        } else {
            imageView.image = UIImage(named: placeholder)
        }
        
        //Step I
        //1. Get The URL Of The Image
        guard let imageURL = URL(string: url) else { return }
        //2. Create The Download Session
       
        let filename = imageURL.deletingPathExtension().lastPathComponent
        print("filename ",filename) //filename  QAicon
        
        let pathExtension = imageURL.pathExtension
        print("pathExtension ",pathExtension) //pathExtension  png
        
        let lastPathComponent = imageURL.lastPathComponent
        print("lastPathComponent ",lastPathComponent) //lastPathComponent  QAicon.png
        
        let documentsDirectory = self.getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(lastPathComponent) //QAicon.png
        print("Downloaded fileURL ",fileURL)
        do {
            //1. Create A Data Object From Our URL
            let imageData = try Data(contentsOf: fileURL)
            if imageData != nil {
                // Display the image on screen using the main queue
                let image = UIImage(data: imageData)
                isDownloaded = true
                if image != nil {
                         DispatchQueue.main.async {
                        imageView.image = UIImage(data: imageData)
                    }
                }
            }
        } catch {
            //Print
            print("DownloadManager error saving file to documents \(error)")
        }
        
        // Go Back is Image Downloaded
        if isDownloaded == true { return }
        
        // Create a session that we can use for this request
        let session = URLSession(configuration: .default)

        // Create a task that will be responsible for downloading the image
        let task = session.dataTask(with: imageURL) { (data, response, error) in

            // ensure we did not get an error
            guard error == nil else { return }
            
            // Convert response to an HTTPURLResponse so we can get the status code
            if let httpResponse = response as? HTTPURLResponse {
                
                // Ensure we got back a status code of 200 - Success
                guard httpResponse.statusCode == 200 else { return }
                
                //let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let documentsDirectory = self.getDocumentsDirectory()
                let fileURL = documentsDirectory.appendingPathComponent(lastPathComponent) //QAicon.png
                //let fileURL = documentsDirectory.appendingPathComponent("\(filename).jpg") ////QAicon.jpg
                
                // Make sure we received the data
                if let receivedData = data {
                    
                    do {
                        print("Downloading fileURL ",fileURL)
                        try receivedData.write(to: fileURL)
                        
                    } catch {
                       
                        //Print
                        print("DownloadManager error saving file to documents \(error)")
                    }
                    
                    // Display the image on screen using the main queue
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: receivedData)
                    }
                }
            }
        }
        
         task.resume()
    }
    
    //Downloads An Video From A Remote URL
   func videoWithRequest(url: String, completionHandler: @escaping (URL)-> ()) -> () {
        
        var isDownloaded: Bool = false
        
        //Step I
       //1. Get The URL Of The Image
        guard let imageURL = URL(string: url) else { return }
    
        //2. Create The Download Session
       
        let filename = imageURL.deletingPathExtension().lastPathComponent
        print("filename ",filename) //filename  VfE_html5
        
        let pathExtension = imageURL.pathExtension
        print("pathExtension ",pathExtension) //pathExtension  mp4
        
        let lastPathComponent = imageURL.lastPathComponent
        print("lastPathComponent ",lastPathComponent) //lastPathComponent  VfE_html5.mp4
        
        let documentsDirectory = self.getDocumentsDirectory()
        let fileURL = documentsDirectory.appendingPathComponent(lastPathComponent) //VfE_html5.mp4
    
    do {
        //1. Create A Data Object From Our URL
        let videoData = try Data(contentsOf: fileURL)
        if videoData != nil {
            // Display the image on screen using the main queue
            isDownloaded = true
        }
    } catch {
        //Print
        print("DownloadManager error saving file to documents \(error)")
    }
    
        // Go Back is Image Downloaded
        if isDownloaded == true {
            print("Downloaded fileURL ",fileURL)
            completionHandler(fileURL)
            return
    }
    
        // Go Back is Image Downloaded
        if isDownloaded == true { return }
        
        // Create a session that we can use for this request
        let session = URLSession(configuration: .default)

        // Create a task that will be responsible for downloading the image
        let task = session.dataTask(with: imageURL) { (data, response, error) in

            // ensure we did not get an error
            guard error == nil else { return }
            
            // Convert response to an HTTPURLResponse so we can get the status code
            if let httpResponse = response as? HTTPURLResponse {
                
                // Ensure we got back a status code of 200 - Success
                guard httpResponse.statusCode == 200 else { return }
                
                //let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let documentsDirectory = self.getDocumentsDirectory()
                let fileURL = documentsDirectory.appendingPathComponent(lastPathComponent) //VfE_html5.mp4
              
                // Make sure we received the data
                if let receivedData = data {
                    do {
                        print("Downloading start fileURL ",fileURL)
                        try receivedData.write(to: fileURL)
                        // Display the image on screen using the main queue
                    } catch {
                       
                        //Print
                        print("DownloadManager error saving file to documents \(error)")
                    }
                    
                    // Display the image on screen using the main queue
                    completionHandler(fileURL)
                }
            }
        }
        
         task.resume()
    }
    
    //Downloads An PDF From A Remote URL
      func pdfWithRequest(url: String, completionHandler: @escaping (URL)-> ()) -> () {
           
           var isDownloaded: Bool = false
           
           //Step I
          //1. Get The URL Of The Image
           guard let imageURL = URL(string: url) else { return }
       
           //2. Create The Download Session
          
           let filename = imageURL.deletingPathExtension().lastPathComponent
           print("filename ",filename) //filename  dummy
           
           let pathExtension = imageURL.pathExtension
           print("pathExtension ",pathExtension) //pdf
           
           let lastPathComponent = imageURL.lastPathComponent
           print("lastPathComponent ",lastPathComponent) //lastPathComponent  dummy.pdf
           
           let documentsDirectory = self.getDocumentsDirectory()
           let fileURL = documentsDirectory.appendingPathComponent(lastPathComponent) //dummy.pdf
       
       do {
           //1. Create A Data Object From Our URL
           let videoData = try Data(contentsOf: fileURL)
           if videoData != nil {
               // Display the image on screen using the main queue
               isDownloaded = true
           }
       } catch {
           //Print
           print("DownloadManager error saving file to documents \(error)")
       }
       
           // Go Back is Image Downloaded
           if isDownloaded == true {
               print("Downloaded fileURL ",fileURL)
               completionHandler(fileURL)
               return
       }
       
           // Go Back is Image Downloaded
           if isDownloaded == true { return }
           
           // Create a session that we can use for this request
           let session = URLSession(configuration: .default)

           // Create a task that will be responsible for downloading the image
           let task = session.dataTask(with: imageURL) { (data, response, error) in

               // ensure we did not get an error
               guard error == nil else { return }
               
               // Convert response to an HTTPURLResponse so we can get the status code
               if let httpResponse = response as? HTTPURLResponse {
                   
                   // Ensure we got back a status code of 200 - Success
                   guard httpResponse.statusCode == 200 else { return }
                   
                   //let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                   let documentsDirectory = self.getDocumentsDirectory()
                   let fileURL = documentsDirectory.appendingPathComponent(lastPathComponent) //dummy.pdf
                 
                   // Make sure we received the data
                   if let receivedData = data {
                       do {
                           print("Downloading start fileURL ",fileURL)
                           try receivedData.write(to: fileURL)
                           // Display the image on screen using the main queue
                       } catch {
                          
                           //Print
                           print("DownloadManager error saving file to documents \(error)")
                       }
                       
                       // Display the image on screen using the main queue
                       completionHandler(fileURL)
                   }
               }
           }
           
            task.resume()
       }
    
    /*
    func imageWithRequest(imageView: UIImageView, url: String, placeholderImage: String) -> () {
        
        //First Placeholder Image
        let image = UIImage(named: placeholderImage)
        if image == nil {
            imageView.image = UIImage(named: "placeholder")
        } else {
            imageView.image = UIImage(named: placeholderImage)
        }
        
       //Second Image Cache Retrive Image
        if let cacheImage = imageCache.object(forKey: url as NSString){
            imageView.image = cacheImage
            print("cacheImage:- ", url)
            return
        }
        
        let imageURL = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: imageURL!) {(data,respose,error) in
            if error == nil {
                //checking if the response contains an image
                if let imageData = data {
                    //getting the image
                    let image = UIImage(data: imageData)
                    if image != nil {
                    DispatchQueue.main.async {
                        imageView.image = image
                        imageCache.setObject(image!, forKey: url as NSString)
                    }
                   }
                }
            }
        }
        task.resume()
    }
 */
 
}


```

## Requirements

### Build

Xcode Version 11.3 (11C29), iOS 13.2.0 SDK

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each this release can be found in the [CHANGELOG](CHANGELOG.mdown). 



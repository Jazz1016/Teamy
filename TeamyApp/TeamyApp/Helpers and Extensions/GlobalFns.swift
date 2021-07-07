//
//  GlobalFns.swift
//  TeamyApp
//
//  Created by James Lea on 7/7/21.
//

import UIKit

enum GlobalFns {
    static func displayPicture(url: String?, UIImageView: UIImageView) {
        guard let urlString = url else {return UIImageView.image = UIImage(named: "imageNotFound") }
        let url = URL(string: "\(urlString)")
        let session = URLSession(configuration: .default)
        guard let finalUrl = url else {return UIImageView.image = UIImage(named: "imageNotFound") }
        
        session.dataTask(with: finalUrl) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                DispatchQueue.main.async {
                    
                    if let res = response as? HTTPURLResponse {
                        //                        print("Downloaded picture with response code \(res.statusCode)")
                        if let imageData = data {
                            let image = UIImage(data: imageData)
                            
                            UIImageView.image = image
                        } else {
                            print("Couldn't get image: Image is nil")
                            UIImageView.image = UIImage(named: "imageNotFound")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
        }.resume()
    }
}

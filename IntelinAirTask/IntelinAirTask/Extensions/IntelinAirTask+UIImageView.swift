//
//  IntelinAirTask+UIImageView.swift
//  IntelinAirTask
//
//  Created by Vahan Grigoryan on 5/31/20.
//  Copyright © 2020 Vahan Grigoryan. All rights reserved.
//

import UIKit

extension UIImageView {
    
    public func download(from url: URL?, contentMode mode: UIView.ContentMode = .scaleAspectFit, placeholder: UIImage?) {
        self.contentMode = mode
        self.clipsToBounds = false
        self.image = placeholder
        guard let url = url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    
}

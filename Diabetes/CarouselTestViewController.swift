//
//  CarouselTestViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 12/12/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit

class CarouselTestViewController: UIViewController, iCarouselDataSource, iCarouselDelegate
{
    var images = [UIImage(named: "smiley"), UIImage(named: "determined"), UIImage(named: "sick"), UIImage(named: "sad"), UIImage(named: "angry")]
    
    @IBOutlet var carouselView: iCarousel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.reloadData()
        carouselView.type = .cylinder
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return images.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        //Create a UIView
        let tempView = UIView(frame: CGRect(x: 0,y: 0, width: 200, height: 200))
        
        //Create a UIImageView
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let imageView = UIImageView()
        imageView.frame = frame
        imageView.contentMode = .scaleAspectFit
        
        //Set the images to the imageView and add it to the tempView
        imageView.image = images[index]
        tempView.addSubview(imageView)
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            print(value)
            return value * 1.2
        }
        return value
    }
}

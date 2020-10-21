//
//  WalkThroughViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.delegate = self
        }
    }
    
    var previews: [(imageName: String, title: String)] = [
        (imageName: "Screen_1", title: "HASSLE FREE SAME DAY DOORSTEP DELIVERY"),
        (imageName: "Screen_2", title: "POCKET FRIENDLY"),
        (imageName: "Screen_3", title: "YOUR DELIVERY COMPANION YOUR DAILY WORK AND THE ONLY ONE YOU CAN TRUST")
    ]
    
    var slides: [WalkthroughPage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    func createSlides() -> [WalkthroughPage] {
        let slides = self.previews.map({ (imageName: String, title: String) -> WalkthroughPage in
            let page = WalkthroughPage()
            page.updateView(with: imageName, title: title)
            return page
        });
        
        return slides
    }
    
    func setupSlideScrollView(slides : [WalkthroughPage]) {
        scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * CGFloat(slides.count), height: self.scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.scrollView.frame.size.width * CGFloat(i), y: 0, width: self.scrollView.frame.size.width, height: self.scrollView.frame.size.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/self.scrollView.frame.size.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

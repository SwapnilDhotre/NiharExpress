//
//  WalkThroughViewController.swift
//  NiharExpress
//
//  Created by Swapnil_Dhotre on 10/20/20.
//  Copyright © 2020 Swapnil Dhotre. All rights reserved.
//

import UIKit

class WalkThroughViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var leadingBtn: UIButton!
    @IBOutlet weak var trailingBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var letsStartBtn: DesignableButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var previews: [(imageName: String, title: String)] = [
        (imageName: "Screen_1", title: "HASSLE FREE SAME DAY DOORSTEP DELIVERY"),
        (imageName: "Screen_2", title: "POCKET FRIENDLY"),
        (imageName: "Screen_3", title: "YOUR DELIVERY COMPANION YOUR DAILY WORK AND THE ONLY ONE YOU CAN TRUST")
    ]
    
    var slides: [WalkthroughPage] = []
    
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        self.setUpTimer()
        self.setUpBtns()
        
        self.scrollView.delegate = self
        
        UserDefaults.standard.set(true, forKey: "hasViewedWalkthrough")
        UserDefaults.standard.synchronize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func setUpTimer() {
        timer =  Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] (timer) in
            
            guard let safeSelf = self else {
                return
            }
            
            if safeSelf.pageControl.currentPage == safeSelf.slides.count - 1 {
                safeSelf.timer?.invalidate()
                safeSelf.timer = nil
                return
            }
            
            safeSelf.scrollView.setContentOffset(CGPoint(x: safeSelf.view.frame.width * CGFloat((safeSelf.pageControl.currentPage) + 1), y: 0), animated: true)
        }
    }
    
    func setUpBtns() {
        self.letsStartBtn.isHidden = true
        self.trailingBtn.setTitle("Next", for: .normal)
        
        if self.pageControl.currentPage == 0 {
            self.leadingBtn.setTitle("Skip", for: .normal)
        } else if self.pageControl.currentPage != 0 && self.pageControl.currentPage != self.slides.count - 1 {
            self.leadingBtn.setTitle("Previous", for: .normal)
        } else {
            self.leadingBtn.isHidden = true
            self.trailingBtn.isHidden = true
            self.letsStartBtn.isHidden = false
            self.view.bringSubviewToFront(self.letsStartBtn)
        }
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
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(slides.count), height: self.view.frame.height - 80)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0, width: self.view.frame.width, height: self.view.frame.height - 80)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/self.view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        self.setUpBtns()
    }
    
    @IBAction func leadingBtnAction(_ sender: Any) {
        if self.pageControl.currentPage == 0 {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat((self.pageControl.currentPage) - 1), y: 0), animated: true)
        }
    }
    
    @IBAction func trailingBtnAction(_ sender: Any) {
        self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat((self.pageControl.currentPage) + 1), y: 0), animated: true)
    }
    
    @IBAction func letStartAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


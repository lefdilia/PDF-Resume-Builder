//
//  SwipingScreens.swift
//  ResumeBuilder
//
//  Created by Lefdili Alaoui Ayoub on 3/11/2021.
//

import UIKit

class SwipingScreensController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let cellId = "cell"
    let screens = Onboarding.getScreens()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = screens.count
        pageControl.currentPageIndicatorTintColor = .apSwipeNextButton
        pageControl.pageIndicatorTintColor = .apSwipeNextButtonLight
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "CurrentPage"), forPage: 0)
        }
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var nextButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 166, height: 44))
        button.backgroundColor = .apSwipeNextButton
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.apSwipeNextButtonText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedTitle = NSAttributedString(string: "Next",attributes: [
            .font : UIFont(name: Theme.nunitoSansBold, size: 17) as Any,
            .foregroundColor : UIColor.apSwipeNextButtonText
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.white, for: .normal)
        let attributedTitle = NSAttributedString(string: "Skip", attributes: [
            .font: UIFont(name: Theme.nunitoSansBold, size: 17) as Any,
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleNext(){
        let nextIndex = min(pageControl.currentPage+1, screens.count-1)
        setControllIndicators(index: nextIndex)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setupGetStarted()
    }
    
    private func setControllIndicators(index: Int){
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "dot"), forPage: pageControl.currentPage)
        }
        
        pageControl.currentPage = index
        
        if #available(iOS 14.0, *) {
            pageControl.setIndicatorImage(UIImage(named: "CurrentPage"), forPage: index)
        }
    }
    
    private func setupGetStarted(){
        if pageControl.currentPage == screens.count - 1 {
            let attributed = NSAttributedString(string: "Get Started", attributes: [
                .font : UIFont(name: Theme.nunitoSansBold, size: 17) as Any,
                .foregroundColor: UIColor.apSwipeNextButtonText
            ])
            nextButton.setAttributedTitle(attributed, for: .normal)
            nextButton.removeTarget(nil, action: nil, for: .allEvents)
            nextButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
            pageControl.isEnabled = false
            pageControl.isHidden = true
            skipButton.isHidden = true
            collectionView.isScrollEnabled = false
        }
    }
    
    @objc private func skipTapped(){
        let lastIndex = screens.count-1
        pageControl.currentPage = lastIndex
        let indexPath = IndexPath(item: lastIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        setupGetStarted()
    }
    
    @objc private func getStartedTapped(){
        let _ = UIApplication.shared.hideOnBoarding(true)
        self.view.window?.rootViewController = MainTabBarController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        collectionView.backgroundColor = .apSwipeBackground
        collectionView.register(SwipingScreensCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(nextButton)
        view.addSubview(pageControl)
        view.addSubview(skipButton)

        NSLayoutConstraint.activate([
            
            nextButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 166),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
  
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            skipButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
        ])
        
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        if #available(iOS 14.0, *) {
            setControllIndicators(index: index)
        }
        setupGetStarted()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screens.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SwipingScreensCell
        cell.screen = screens[indexPath.item]

        if self.pageControl.currentPage == 0 {
            collectionView.contentOffset = .zero
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension SwipingScreensController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate { [weak self] _ in
            
            self?.collectionViewLayout.invalidateLayout()
            
            let indexPath = IndexPath(item: self?.pageControl.currentPage ?? 0, section: 0)
            self?.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
             
            if self?.pageControl.currentPage == 0 {
                self?.collectionView.contentOffset = .zero
            }
            
        }
    }

}

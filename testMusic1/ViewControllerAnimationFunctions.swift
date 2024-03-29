//
//  ViewControllerFunctions.swift
//  testMusic1
//
//  Created by Heltisace on 27.02.17.
//  Copyright © 2017 Heltisace. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

//Animations extension
extension ViewController {
    //Operations with constraints
    func setGifConstraints(left: CGFloat?, right: CGFloat?, top: CGFloat?, bottom: CGFloat?) {
        if left != nil {
            self.gifLeading.constant = left!
        }
        if top != nil {
            self.gifTop.constant = top!
        }
        if right != nil {
            self.gifTrailing.constant = right!
        }
        if bottom != nil {
            self.gifBottom.constant = bottom!
        }
    }

    //Animations if changing
    func animateGifChanging() {
        //Operations with buttons
        buttonsOperation()
        //Changing gif animation
        changeGifWithAnimation()
        returnGifToView()
        //Changing song animation
        changeSongInfoLabel()
    }

    //Set label alpha 0 and start loading new song
    func changeSongInfoLabel() {
        DispatchQueue.global().sync {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                //4
                self.songInfoView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                //7
                self.returnLabelToView()
                self.generateNewSong()
                self.loadNewSong()
                self.loadSongInfo()
            })
        }
    }

    //Move the gif to the left of view and start loading spinner
    func changeGifWithAnimation() {
        DispatchQueue.global().sync {
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.setGifConstraints(left: self.viewWidth, right: self.viewWidth, top: nil, bottom: nil)
                self.view.layoutIfNeeded()
            })
        }
    }

    //Move the gif from above to the view
    func fromTopToDown() {
        DispatchQueue.global().sync {
            UIView.animate(withDuration: 1.0, delay: 1.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.setGifConstraints(left: nil, right: nil, top: self.normalGifTop, bottom: self.normalGifBottom)
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.startMusicAndGif()
                self.returnButtons()
            })
        }
    }
    //Change label alpha to 1
    func returnLabelToView() {
        DispatchQueue.global().sync {
            UIView.animate(withDuration: 0.8, delay: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.songInfoView.alpha = 1
                self.view.layoutIfNeeded()
            })
        }
    }
    //Put the gif above the view
    func returnGifToView() {
        DispatchQueue.global().sync {
            self.setGifConstraints(left: self.normalGifLeft, right: self.normalGifRight, top: -self.viewHeight, bottom: self.viewHeight)
            self.gifView.transform = CGAffineTransform(rotationAngle: 0)
            self.view.layoutIfNeeded()
            self.fromTopToDown()
        }
    }
    //If we don't change gif
    func animateGifNotChanging() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.setGifConstraints(left: self.normalGifLeft, right: self.normalGifRight, top: nil, bottom: nil)
                self.gifView.transform = CGAffineTransform(rotationAngle: 0)
                self.view.layoutIfNeeded()
            })
        }
    }
    //Move buttons away
    func buttonsOperation() {
        DispatchQueue.global().sync {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.openGifButton.alpha = 0
                self.openSongButton.alpha = 0
                self.openGifButton.isEnabled = false
                self.openSongButton.isEnabled = false

                self.openSongLeading.constant = -200
                self.openGifTrailing.constant = -200
                self.betweenButtons.constant = 400
                self.view.layoutIfNeeded()
            })
        }
    }

    //Return buttons back
    func returnButtons() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.openGifButton.alpha = 1
                self.openSongButton.alpha = 1

                self.openSongLeading.constant = self.normalLeftButton
                self.openGifTrailing.constant = self.normalRightButton
                self.betweenButtons.constant = self.normalBetweenButtons-24
                self.view.layoutIfNeeded()
            }, completion: { _ in
                //Strart bounce
                self.buttonsBounce()
            })
        }
    }

    //Buttons bounce function
    func buttonsBounce() {
        let openGifBounds = self.openGifButton.bounds
        let openSongBounds = self.openSongButton.bounds
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0.01, usingSpringWithDamping: 0.1, initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.openGifButton.bounds = CGRect(x:
                    openGifBounds.origin.x + 15, y: openGifBounds.origin.y, width:
                    openGifBounds.size.width - 10, height: openGifBounds.size.height)
                self.openSongButton.bounds = CGRect(x:
                    openSongBounds.origin.x + 15, y: openSongBounds.origin.y, width:
                    openSongBounds.size.width - 10, height: openSongBounds.size.height)

                self.view.layoutIfNeeded()
            }, completion: { _ in
                //Set normal buttons
                self.returnNormalButtons()
            })
        }
    }

    //Set buttons to normal state
    func returnNormalButtons() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.openSongLeading.constant = self.normalLeftButton
                self.openGifTrailing.constant = self.normalRightButton
                self.betweenButtons.constant = self.normalBetweenButtons
                self.view.layoutIfNeeded()
            })
        }
    }
}

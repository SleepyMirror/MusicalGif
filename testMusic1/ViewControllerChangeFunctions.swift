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

//Load content extension
extension ViewController {
    //Get and set new music and gif
    func startTheShow() {
        DispatchQueue.global().sync {
            //Prepear for changing
            likeTheSet.isEnabled = false
            gestureRecognizer.removeTarget(self, action: #selector(handlePan))
            tap.removeTarget(self, action: #selector(doubleTapped))
            processIsWorking = true

            self.musicPrepear()
            self.loadSpinner()

            self.animateGifChanging()
        }
    }
    //Stop previous song
    func musicPrepear() {
        DispatchQueue.global().sync {
            self.musicEngine.stopPlaying()
        }
    }
    //Adds spinner animation
    func loadSpinner() {
        self.closeSpinner(spinner: self.indicator)
        DispatchQueue.global().sync {
            self.indicator = self.spinner.showActivityIndicator(gifView: self.theGif, gifContainer: self.viewInGifView)
        }
    }
    //Close the spinner
    func closeSpinner(spinner: NVActivityIndicatorView?) {
        DispatchQueue.global().sync {
            if self.indicator?.isAnimating == true {
                self.spinner.hideActivityIndicator(spinner: self.indicator!, gifContainer: self.viewInGifView, gifView: self.theGif)
            }
        }
    }

    //Load a new song
    func generateNewSong() {
        DispatchQueue.global().sync {
            if !fromFavoriteTable && !fromHistoryTable {
                var genre = ""
                if preSetGenre == "The Best" {
                    genre = self.randomSongEngine.getRandomGenre()
                } else if preSetGenre != "Full random" {
                    genre = preSetGenre
                }
                let answer = self.randomSongEngine.generateRandomSong(
                    musicEngine: self.musicEngine, genre: genre)
                songURL = answer.first!
                jsonSongURL = answer.last!
            } else {
                songURL = self.randomSongEngine.generateSong(jsonUrl: jsonSongURL, musicEngine: self.musicEngine)
            }
            if songURL != "Error" {
                self.openSongButton.isEnabled = true
            }
        }
    }

    func loadNewSong() {
        DispatchQueue.global().sync {
            self.randomSongEngine.loadRandomSong(musicEngine: self.musicEngine)
        }
    }

    func loadSongInfo() {
        DispatchQueue.global().sync {
            self.randomSongEngine.setSongInfo(infoLabel: self.songInfoLabel)
        }
    }
    
    //Show image and play music if image is loaded
    func startMusicAndGif() {
        DispatchQueue.global().sync {
            self.theGif.sd_cancelCurrentImageLoad()

            if !isVcClosed {
                if !fromFavoriteTable && !fromHistoryTable {
                    var gifTag = ""
                    if preSetGifTag == "The Best" {
                        gifTag = self.randomGifEngine.randomTag()
                    } else if preSetGifTag != "Full random" {
                        gifTag = preSetGifTag
                    }
                    self.gifURL = self.randomGifEngine.getGifWithTag(tag: gifTag)
                }
            }
            if self.gifURL != "Error" {
                self.openGifButton.isEnabled = true
            }

            self.checkForExisting()

            //Creating stream for synch
            self.theGif.sd_setImage(with: URL(string: self.gifURL)) { (_) in
                //Play the song and show the gif
                self.musicEngine.playTrack(viewController: self)
                self.closeSpinner(spinner: self.indicator)
                self.processIsWorking = false
                //Add gestures
                self.tap.addTarget(self, action: #selector(self.doubleTapped))
                self.gestureRecognizer.addTarget(self, action: #selector(self.handlePan))
            }
        }
    }
}

//
//  ViewController.swift
//  MusicMood

import UIKit


struct Favorite {
    let title: String
    let artist: String
    let genre: String
    let description: String
    let imageName: String
}

class ViewController: UIViewController {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!


    let favorites: [Favorite] = [
        Favorite(title: "Moth to a Flame", artist: "The Weeknd", genre: "Synth-pop", description: "Bright retro synths and a catchy beat.", imageName: "cover01"),
        Favorite(title: "Doin' Time", artist: "Lana Del Rey", genre: "Alternative Pop", description: "A slow song.", imageName: "cover02"),
        Favorite(title: "Dirty Diana", artist: "Michael Jackson", genre: "Hard Rock", description: "Hard Rock with a catchy beat.", imageName: "cover03"),
        Favorite(title: "No. 1 Party Anthem", artist: "Arctic Monkeys", genre: "Indie Rock", description: "Indie Rock with catchy riffs.", imageName: "cover04"),
        Favorite(title: "Summertime Sadness", artist: "Lana Del Rey", genre: "Alternative pop", description: "Dreamy pop with a nostalgic feeling.", imageName: "cover05"),
        Favorite(title: "Nervous", artist: "The Neighbourhood", genre: "Alternative Rock", description: "Alternative Rock with a moody sound", imageName: "cover06"),
        Favorite(title: "Do I Wanna Know?", artist: "Arctic Monkeys", genre: "Indie rock", description: "A moody rock song with a strong riff.", imageName: "cover07"),
        Favorite(title: "Sweater Weather", artist: "The Neighbourhood", genre: "Alternative rock", description: "Relaxed guitar sounds and a cool mood.", imageName: "cover08"),
        Favorite(title: "Starboy", artist: "The Weeknd", genre: "R&B", description: "Dark electronic sounds with an R&B feel.", imageName: "cover09"),
        Favorite(title: "Best Mistake", artist: "Ariana Grande ft. Big Sean", genre: "R&B", description: "R&B with a catchy beat.", imageName: "cover10")
    ]

    var currentTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let firstFavorite = favorites.first {
            showFavorite(firstFavorite)
        }
    }

    func showFavorite(_ favorite: Favorite) {
        songTitleLabel.text = favorite.title
        artistLabel.text = favorite.artist
        genreLabel.text = favorite.genre
        descriptionLabel.text = favorite.description
        albumImageView.image = UIImage(named: favorite.imageName)
        currentTitle = favorite.title
    }

    @IBAction func shuffleMusic(_ sender: UIButton) {
       
        var choices: [Favorite] = []

        for favorite in favorites {
            if favorite.title != currentTitle {
                choices.append(favorite)
            }
        }

        if let randomFavorite = choices.randomElement() {
            showFavorite(randomFavorite)
        }
    }
}

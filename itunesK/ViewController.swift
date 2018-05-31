//
//  ViewController.swift
//  itunesK
//
//  Created by Viet on 30/5/18.
//  Copyright © 2018 Viet. All rights reserved.
//

import Cocoa
import iTunesLibrary

var i:Double = 0
var selected_playlist: String = ""

class ViewController: NSViewController {

    @IBOutlet weak var myLable: NSTextField!
    @IBOutlet weak var myButton: NSButton!
    @IBOutlet weak var myProgress: NSProgressIndicator!
    @IBOutlet weak var myPopup: NSPopUpButton!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        let library: ITLibrary
        
        do{
            library = try ITLibrary(apiVersion: "1.1")
            
            let pls = library.allPlaylists
            
            for pls_name in pls {
                print(pls_name.name)
                
                myPopup.addItem(withTitle: pls_name.name)
            }
            
            
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func popupSelected(_ sender: Any) {
        selected_playlist = (myPopup.selectedItem?.title)!
        myPopup.title = selected_playlist
        print(selected_playlist)
    }
    func loadlibrary(){
        
        let library: ITLibrary
        let fileManager = FileManager.default
        

        do {
            
            library = try ITLibrary(apiVersion: "1.1")
            
            let pls = library.allPlaylists
            
            for item in pls{
               
                if item.name == selected_playlist{
                    
                    let totalsong = Double(item.items.count)
           
                    let songs = item.items
                    
                    
                    print(totalsong)
                    
                    
                    for song in songs{

                        let songpath:String = (song.location?.path)!
                        let songfilename = (song.location?.lastPathComponent)!
                        let myPath:String = "/Volumes/System/Users/viet/Desktop/mysong/" + songfilename
                        
                        try? fileManager.copyItem(atPath: songpath, toPath: myPath)
                        
                        print((song.location?.lastPathComponent)!, "copied")
                
                        DispatchQueue.main.async {
                            i += 100 / totalsong
                            self.myLable.stringValue = String(i.rounded()) + "%"
                            self.myProgress.doubleValue = i.rounded()
                        }
                        
                    }
                }
            }

        } catch let error as NSError {
            print(error)
            //dialogOKCancel(question: "Error!!!", text: String(error.code))
        }
    }
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    
    
    @IBAction func buttonClicked(_ sender: Any) {
        myButton.isEnabled = false
        DispatchQueue.global(qos:.background).async {
            
            self.loadlibrary()
            DispatchQueue.main.async {
                
                self.myLable.stringValue = "Done"
                self.myButton.isEnabled = true
//                self.dialogOKCancel(question: "Done copying songs", text: "Choose your answer.")
            }
        }
    }
        
    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


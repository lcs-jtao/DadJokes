//
//  ContentView.swift
//  DadJokes
//
//  Created by Russell Gordon on 2022-02-21.
//
import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    // Holds the current joke (the joke that was just retrieved)
    @State var currentJoke: DadJoke = DadJoke(id: "", joke: "Knock, knock", status: 0)
    
    // Holds a list of favourite jokes
    @State var favourites: [DadJoke] = [] // Empty list
    
    // This will let us know whether the current joke has been added to the list
    @State var currentJokeAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        VStack {
            
            Text(currentJoke.joke)
                .font(.title)
                // Shrinks text to at most half it's original size (to make it fit)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.leading)
                .padding(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.primary, lineWidth: 4)
                )
                .padding(10)
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
                // Make the image red when the current joke is favourite
                .foregroundColor(currentJokeAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    // Only when the joke does not already exist, add it
                    if currentJokeAddedToFavourites == false {
                        
                        // Add the current joke to the list
                        favourites.append(currentJoke)
                        
                        // Keep track of the fact that the joke is now a favourite
                        currentJokeAddedToFavourites = true
                    }
                }
            
            Button(action: {
                print("I've been pressed")
                
                // "Call" loadNewJoke
                // It must be called within a Task structure so that it runs asynchonously
                // NOTE: Button's action normally expects synchronous code
                Task {
                    await loadNewJoke()
                }

            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            
            HStack {
                Text("Favourites")
                    .bold()

                Spacer()
            }
            
            // Iterate (loop) over the list (array) of jokes
            // Make each joke accessible using the name "currentJoke"
            // id: \.self     <-- That tells the List structure to identify each joke using the text of the joke itself
            List(favourites, id: \.self) { currentJoke in
                Text(currentJoke.joke)
            }
            
            Spacer()
                        
        }
        // When the app opens, get a new joke from the web service
        .task {
            
            // We "call" the loadNewJoke function to tell the computer to get that new joke
            // By typing "await" we are acknowledging that we know this function may be run at the same time as other tasks in the app
            await loadNewJoke()
            
            // DEBUG
            print("Have just attempted to load a new joke.")
        }
        .navigationTitle("icanhazdadjoke?")
        .padding()
    }
    
    // MARK: Functions
    // This function loads a new joke by talking to an endpoint on the web.
    // We must mark the function as "async" so that it can be asynchronously which means it may be run at the same time as other tasks
    // This is the function definition (it is where the computer "learns" what it takes to load a new joke).
    func loadNewJoke() async {
        
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://icanhazdadjoke.com/")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the website
        var request = URLRequest(url: url)
        
        // Ask for JSON data
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Got the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                              DATA TYPE TO DECODE TO
            //                                       |
            //                                       V
            currentJoke = try JSONDecoder().decode(DadJoke.self, from: data)
            
            // If we got here, a new joke has been set (line 126)
            // So, we must reset the flag to track whether the current joke is a favourite
            currentJokeAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block populates
            print(error)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}

// PostViewModel.swift
import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var db = Firestore.firestore()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        let randomValue = Double.random(in: 0...1)
        
        db.collection("posts")
            .whereField("randomValue", isGreaterThanOrEqualTo: randomValue)
            .limit(to: 55)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                let posts = documents.compactMap { try? $0.data(as: Post.self) }
                
                DispatchQueue.main.async {
                    self.posts = posts
                }
            }
    }
}

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
        db.collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            let allPosts = (snapshot?.documents ?? []).compactMap { document -> Post? in
                try? document.data(as: Post.self)
            }
            self.posts = Array(allPosts.shuffled().prefix(55))
        }
    }
}

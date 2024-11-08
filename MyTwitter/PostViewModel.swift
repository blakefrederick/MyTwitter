import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    private var db = Firestore.firestore()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        // @TODO change to random orderiing
        db.collection("posts").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            self.posts = snapshot?.documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            } ?? []
        }
    }
}

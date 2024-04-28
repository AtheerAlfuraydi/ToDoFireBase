//
//  ContentView.swift
//  connectFireBase
//
//  Created by أثير on 14/10/1445 AH.
//
// Define Category and Task here or import them from where they are defined

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var firebaseManager: FirebaseManager
    @State private var isShowingAddCategory = false
    @State private var selectedCategory: Category? // This holds the category to edit
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(firebaseManager.categories, id: \.id) { category in
                    HStack {
                        NavigationLink(destination: TaskView(category: category)) {
                            VStack(alignment: .leading) {
                                Text(category.name)
                                    .frame(alignment: .leading)
                            }
                        }
                        
                        
                        Spacer()
                        Menu {
                            Button {
                                selectedCategory = category
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .foregroundStyle(.blue)
                            }
                            Button("Delete", role: .destructive) {
                                Task {
                                    do {
                                        try await firebaseManager.deleteCategory(category)
                                        try? await firebaseManager.fetchCategories()
                                    } catch {
                                        print("Error deleting category: \(error)")
                                    }
                                }
                            }.foregroundStyle(.red)
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(.blue)
                        }}
                }
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        isShowingAddCategory.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(item: $selectedCategory) { category in
                updateCategory(category: category)
            }
            .sheet(isPresented: $isShowingAddCategory) {
                AddCategory()
            }
            .onAppear {
                Task {
                    do {
                        try await firebaseManager.fetchCategories()
                    } catch {
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(FirebaseManager())
}





//
//  ContentView.swift
//  TruMatrix
//
//  Created by Louis Chang on 2025/1/5.
//

import SwiftUI

struct Chapter {
    let id: Int
    let title: String
}

struct Question {
    let id: Int
    let chapterID: Int
    let text: String
    let isCorrect: Bool
    let explanation: String
}

struct ContentView: View {
    @State private var chapters = [
        Chapter(id: 1, title: "Matrices, Vectors, and Systems of Linear Equations"),
        Chapter(id: 2, title: "Matrices and Linear Transformations"),
        Chapter(id: 3, title: "Determinants"),
        Chapter(id: 4, title: "Subspaces and Their Properties"),
        Chapter(id: 5, title: "Eigenvalues, Eigenvectors, and Diagonalization"),
        Chapter(id: 6, title: "Orthogonality"),
        Chapter(id: 7, title: "Vector Spaces")
    ]
    
    @State private var selectedChapter: Int?
    @State private var showingQuiz = false
    
    var body: some View {
        NavigationView {
            if selectedChapter == nil {
                List(chapters, id: \.id) { chapter in
                    Button(action: {
                        selectedChapter = chapter.id
                        showingQuiz = true
                    }) {
                        HStack {
                            Text("Chapter \(chapter.id)")
                                .fontWeight(.bold)
                            Text(chapter.title)
                        }
                        .padding()
                    }
                }
                .navigationTitle("TruMatrix")
            } else {
                QuizView(chapterID: selectedChapter!, onExit: {
                    selectedChapter = nil
                    showingQuiz = false
                })
            }
        }
    }
}

struct QuizView: View {
    let chapterID: Int
    let onExit: () -> Void
    
    @State private var questions = [
        // Chapter 1
        Question(id: 1, chapterID: 1, text: "If B is a 3 × 4 matrix, then its columns are 1 × 3 vectors.", isCorrect: false, explanation: "the columns are 3 x 1 vectors."),
        Question(id: 2, chapterID: 1, text: "The rank of the coefficient matrix of a consistent system of linear equations is equal to the number of basic variables in the general solution of the system.", isCorrect: true, explanation: ""),
        Question(id: 3, chapterID: 1, text: "The nullity of the coefficient matrix of a consistent system of linear equations is equal to the number of free variables in the general solution of the system.", isCorrect: true, explanation: ""),
        Question(id: 4, chapterID: 1, text: "Every matrix can be transformed into one and only one matrix in reduced row echelon form by means of a sequence of elementary row operations.", isCorrect: true, explanation: ""),
        Question(id: 5, chapterID: 1, text: "If the last row of the reduced row echelon form of an augmented matrix of a system of linear equations has only one nonzero entry, then the system is inconsistent.", isCorrect: false, explanation: "the nonzero entry has to be the last entry."),
        
        // Chapter 2
        Question(id: 5, chapterID: 2, text: "A symmetric matrix equals its transpose.", isCorrect: true, explanation: ""),
        Question(id: 6, chapterID: 2, text: "The product of square matrices is always defined.", isCorrect: false, explanation: "The product of a 2 x 2 and 3 × 3 matrix is not defined."),
        Question(id: 7, chapterID: 2, text: "The transpose of an invertible matrix is invertible.", isCorrect: true, explanation: "")
    ]
    
    @State private var currentQuestionIndex = 0
    @State private var showExplanation = false
    @State private var answered = false
    
    var filteredQuestions: [Question] {
        questions.filter { $0.chapterID == chapterID }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if currentQuestionIndex < filteredQuestions.count {
                Text("題目 \(currentQuestionIndex + 1) / \(filteredQuestions.count)")
                    .font(.headline)
                
                Text(filteredQuestions[currentQuestionIndex].text)
                    .padding()
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        checkAnswer(true)
                    }) {
                        Text("True")
                            .frame(width: 120)
                            .padding()
                            .background(!answered ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(answered)
                    
                    Button(action: {
                        checkAnswer(false)
                    }) {
                        Text("False")
                            .frame(width: 120)
                            .padding()
                            .background(!answered ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(answered)
                }
                
                if showExplanation {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("答錯了！正確答案是: \(filteredQuestions[currentQuestionIndex].isCorrect ? "True" : "False")")
                            .foregroundColor(.red)
                        Text("解釋：")
                            .font(.headline)
                        Text(filteredQuestions[currentQuestionIndex].explanation)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                nextQuestion()
                            }) {
                                Text("下一題")
                                    .frame(width: 120)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            } else {
                Text("完成本章節練習！")
                    .font(.title)
                
                Button("返回章節選擇") {
                    onExit()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("Chapter \(chapterID)")
        .navigationBarItems(trailing: Button("結束") { onExit() })
    }
    
    private func checkAnswer(_ answer: Bool) {
        answered = true
        if answer != filteredQuestions[currentQuestionIndex].isCorrect {
            showExplanation = true
        } else {
            nextQuestion()
        }
    }
    
    private func nextQuestion() {
        currentQuestionIndex += 1
        showExplanation = false
        answered = false
    }
}

#Preview {
    ContentView()
}

